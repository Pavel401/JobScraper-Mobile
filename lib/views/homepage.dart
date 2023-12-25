import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jobhunt_mobile/blocs/db/local_db_bloc.dart';

import 'package:jobhunt_mobile/model/jobModel.dart';
import 'package:jobhunt_mobile/repo/repositiories.dart';
import 'package:jobhunt_mobile/services/authentication.dart';
import 'package:jobhunt_mobile/services/dbHelper.dart';
import 'package:jobhunt_mobile/views/Profile/profile_readView.dart';
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

  final jobDatabaseHelper = JobDatabaseHelper();

  @override
  Widget build(BuildContext context) {
    jobDatabaseHelper.initDatabase();

    final localDbBloc = BlocProvider.of<LocalDbBloc>(context);

    return BlocProvider(
      create: (context) => LocalDbBloc(
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
              icon: Icon(Icons.person_outline),
              selectedIcon: Icon(Icons.person),
              label: 'Profile',
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
              icon: Icon(Icons.logout),
              label: Text('Logout'),
            ),
          ],
        ),
        appBar: AppBar(
          title: Text("Job Hunt"),
          actions: [
            _selectedIndex == 0
                ? IconButton(
                    onPressed: () {
                      localDbBloc.add(ResetJobs());
                    },
                    icon: Icon(Icons.replay_outlined),
                  )
                : SizedBox.shrink(),
          ],
        ),
        body: PageView(
          physics: NeverScrollableScrollPhysics(),
          controller: PageController(initialPage: _selectedIndex),
          children: [
            BlocBuilder<LocalDbBloc, LocalDbState>(
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
            ProfileReadView(),
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
      final AuthService authService = AuthService();
      authService.signOutUser();
    }
  }
}
