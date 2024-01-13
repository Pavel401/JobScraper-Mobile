import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jobhunt_mobile/blocs/Bookmarks/bookmarks_bloc.dart';
import 'package:jobhunt_mobile/blocs/db/local_db_bloc.dart';

import 'package:jobhunt_mobile/model/jobModel.dart';
import 'package:jobhunt_mobile/repo/jobRepository.dart';

import 'package:jobhunt_mobile/services/dbHelper.dart';
import 'package:jobhunt_mobile/views/About/about_us.dart';
import 'package:jobhunt_mobile/views/Bookmark/bookmarks_screen.dart';
import 'package:jobhunt_mobile/views/Settings/settings.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  int _drawerIndex = 0;

  final jobDatabaseHelper = LocalDBHelper();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    jobDatabaseHelper.initDatabase();

    final localDbBloc = BlocProvider.of<JobCRUDBloc>(context);
    final bookmarkBloc = BlocProvider.of<BookmarksBloc>(context);

    return BlocProvider(
      create: (context) => JobCRUDBloc(
        UserRepository(),
      )..add(InitLocalDb()),
      child: Scaffold(
        bottomNavigationBar: NavigationBar(
          selectedIndex: _selectedIndex,
          onDestinationSelected: (int index) {
            print("Drawer index: $index");

            setState(() {
              _selectedIndex = index;
            });
          },
          destinations: [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(Icons.bookmark_border_outlined),
              selectedIcon: Icon(Icons.bookmark),
              label: 'Bookmarks',
            ),
          ],
        ),
        key: UniqueKey(),
        drawer: NavigationDrawer(
          selectedIndex: _drawerIndex,
          onDestinationSelected: (int value) {
            setState(() {
              _drawerIndex = value;
            });
            handleDrawerOnClick(value);
          },
          children: <Widget>[
            SizedBox(height: 16),
            NavigationDrawerDestination(
              icon: Icon(Icons.settings),
              label: Text('Settings'),
            ),
            NavigationDrawerDestination(
              icon: FaIcon(FontAwesomeIcons.github),
              label: Text('Github'),
            ),
            NavigationDrawerDestination(
              icon: Icon(Icons.info_outline),
              label: Text('About Us'),
            ),
          ],
        ),
        appBar: AppBar(
          title: _selectedIndex == 0 ? Text("Job Hunt") : Text("Bookmarks"),
          actions: [
            _selectedIndex == 0
                ? IconButton(
                    onPressed: () {
                      localDbBloc.add(ResetJobs());
                    },
                    icon: Icon(Icons.replay_outlined),
                  )
                : SizedBox.shrink(),
            _selectedIndex == 0
                ? IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () async {
                      final String? result = await showSearch<String>(
                        context: context,
                        delegate: JobSearchDelegate(localDbBloc: localDbBloc),
                      );

                      if (result != null && result.isNotEmpty) {
                        // Handle the search result if needed
                        // Example: _search(result);
                      }
                    },
                  )
                : SizedBox.shrink(),
          ],
        ),
        body: PageView(
          physics: NeverScrollableScrollPhysics(),
          controller: PageController(initialPage: _selectedIndex),
          children: [
            BlocBuilder<JobCRUDBloc, LocalDbState>(
              bloc: localDbBloc,
              builder: (context, state) {
                if (state is LocalDbLoading) {
                  print("LocalDbLoading");
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (state is LocalDbLoaded) {
                  print("LocalDbLoaded");
                  List<JobModel> userList = state.jobs;
                  return ListView.builder(
                    itemCount: userList.length,
                    itemBuilder: (_, index) {
                      return Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                        child: GestureDetector(
                          onTap: () {
                            _launchURL(userList[index].applyUrl);
                          },
                          child: Card(
                            child: ListTile(
                              title: Text(userList[index].title),
                              subtitle: Text(userList[index].company),
                              trailing: IconButton(
                                onPressed: () {
                                  bookmarkBloc.add(InsertBookmark(
                                    userList[index],
                                    context,
                                  ));
                                },
                                icon: Icon(Icons.bookmark_border_outlined),
                              ),
                              leading: userList[index].imageUrl.isEmpty
                                  ? Icon(Icons.dangerous)
                                  : CircleAvatar(
                                      backgroundImage: NetworkImage(
                                          userList[index].imageUrl),
                                    ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }

                return Container();
              },
            ),
            BookmarksScreen(),
          ],
        ),
      ),
    );
  }

  Future<void> _launchURL(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw Exception('Could not launch $url');
    }
  }

  handleDrawerOnClick(int index) async {
    print("Drawer OnClick Index: $index");

    if (index == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return SettingsView();
          },
        ),
      );
    }

    if (index == 1) {
      if (!await launchUrl(
          Uri.parse("https://github.com/Pavel401/JobScraper-Mobile"))) {}
    }
    if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return AboutUs();
          },
        ),
      );
    }
  }
}

class JobSearchDelegate extends SearchDelegate<String> {
  final JobCRUDBloc localDbBloc;

  JobSearchDelegate({required this.localDbBloc});

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    localDbBloc.add(SearchJobs(query));
    return Container(); // Replace with your search result UI
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container(); // Replace with your suggestion UI
  }
}
