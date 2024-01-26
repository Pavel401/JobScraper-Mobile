import 'dart:ui';

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
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
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
  final ScrollController _scrollController = ScrollController();
  void showTutorial() {
    tutorialCoachMark.show(context: context);
  }
  late TutorialCoachMark tutorialCoachMark;

  GlobalKey keyButton = GlobalKey();
  GlobalKey keyButton1 = GlobalKey();
  GlobalKey keyButton2 = GlobalKey();
  GlobalKey keyButton3 = GlobalKey();
  GlobalKey keyButton4 = GlobalKey();
  GlobalKey keyButton5 = GlobalKey();

  GlobalKey keyBottomNavigation1 = GlobalKey();
  GlobalKey keyBottomNavigation2 = GlobalKey();
  GlobalKey keyBottomNavigation3 = GlobalKey();

  @override
  void initState() {
    createTutorial();
    Future.delayed(Duration.zero, showTutorial);
    super.initState();
  }

  void createTutorial() {
    tutorialCoachMark = TutorialCoachMark(
      targets: _createTargets(),
      colorShadow: Colors.black87,
      textSkip: "SKIP",
      paddingFocus: 10,
      opacityShadow: 0.5,
      imageFilter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
      onFinish: () {
        print("finish");
      },
      onClickTarget: (target) {
        print('onClickTarget: $target');
      },
      onClickTargetWithTapPosition: (target, tapDetails) {
        print("target: $target");
        print(
            "clicked at position local: ${tapDetails.localPosition} - global: ${tapDetails.globalPosition}");
      },
      onClickOverlay: (target) {
        print('onClickOverlay: $target');
      },
      onSkip: () {
        print("skip");
        return true;
      },
    );
  }

  List<TargetFocus> _createTargets() {
    List<TargetFocus> targets = [];
    const textStyle = TextStyle(
    color: Colors.white,
    fontSize: 16,
    fontWeight: FontWeight.w500
  );
    targets.add(
      TargetFocus(
        identify: "keyBottomNavigation3",
        keyTarget: keyBottomNavigation3,
        alignSkip: Alignment.center,
        enableOverlayTab: true,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) {
              
              return  Card(
                 elevation: 0,
                shadowColor:  Colors.grey.shade50,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(6),
                    topRight: Radius.circular(16),
                    bottomLeft: Radius.circular(16),
                    bottomRight:  Radius.circular(6)
                  )
                ),
                color: Colors.blueGrey,
                 child:Padding(
                   padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 8),
                   child: Text(
                      "Showing Job Title",
                      style: textStyle,
                    ),
                 ),
              );
            },
          ),
        ],
      ),
    );
     targets.add(
      TargetFocus(
        identify: "keyBottomNavigation2",
        keyTarget: keyBottomNavigation2,
        alignSkip: Alignment.center,
        enableOverlayTab: true,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) {
              return Card(
                 elevation: 0,
                shadowColor:  Colors.grey.shade50,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(6),
                    topRight: Radius.circular(16),
                    bottomLeft: Radius.circular(16),
                    bottomRight:  Radius.circular(6)
                  )
                ),
                color: Colors.blueGrey,
                 child:Padding(
                   padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 8),
                   child: Text(
                      "Showing Company which is providing the job.",
                      style: textStyle,
                    ),
                  ),
              );
            },
          ),
        ],
      ),
    );
    targets.add(
      TargetFocus(
        identify: "keyBottomNavigation1",
        keyTarget: keyBottomNavigation1,
        alignSkip: Alignment.topRight,
        enableOverlayTab: true,
        contents: [
          TargetContent(
            align: ContentAlign.left,
            builder: (context, controller) {
              return Card(
                color: Colors.blueGrey,
                 elevation: 0,
                shadowColor:  Colors.grey.shade50,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(6),
                    topRight: Radius.circular(16),
                    bottomLeft: Radius.circular(16),
                    bottomRight:  Radius.circular(6)
                  )
                ),
                 child:Padding(
                   padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 8),
                   child:Text(
                      "Bookmark your Job Card",
                      style: textStyle,
                    ),
                 )
              );
            },
          ),
        ],
      ),
    );
    return targets;
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
                        padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                        child: GestureDetector(
                          onTap: () {
                            _launchURL(userList[index].applyUrl);
                          },
                          child:  Dismissible(
                          key: Key(index.toString()),
                          background: Container(
                            color: Theme.of(context).primaryColor.withOpacity(0.25),
                            child: Icon(Icons.bookmark, color: Theme.of(context).primaryColor),
                            alignment: Alignment.centerLeft,
                            padding: EdgeInsets.only(left: 20.0),
                          ),
                          secondaryBackground: Container(
                            color: Theme.of(context).primaryColor.withOpacity(0.25),
                            child: Icon(Icons.bookmark, color: Theme.of(context).primaryColor),
                            alignment: Alignment.centerRight,
                            padding: EdgeInsets.only(right: 20.0),
                          ),
                          dismissThresholds: {
                            DismissDirection.endToStart : 0.25,
                             DismissDirection.startToEnd : 0.25,
                          },
                          onDismissed: (direction) {
                              setState(() {
                               bookmarkBloc.add(InsertBookmark(
                                    userList[index],
                                    context,
                                  ));
                              });
                          },
                          child:  Card(
                            elevation: 5,
                            shadowColor:  Colors.grey.shade50,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(6),
                                topRight: Radius.circular(16),
                                bottomLeft: Radius.circular(16),
                                bottomRight:  Radius.circular(6)
                              )
                            ),
                            child: ListTile(
                              contentPadding: EdgeInsets.symmetric(horizontal: 12,vertical: 6),
                              title: Text(userList[index].title,
                               key: index == 0 ? keyBottomNavigation3 : null,
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                                color:Theme.of(context).brightness == Brightness.dark ? 
                                  Colors.white
                                 :Colors.grey.shade800
                              ),
                              ),
                              subtitle: Padding(
                                padding: const EdgeInsets.only(top: 2),
                                child: Row(
                                  key: index == 0 ? keyBottomNavigation2 : null,
                                  children: [
                                    Icon(Icons.business,
                                    size: 15,
                                     color: Theme.of(context).brightness == Brightness.dark ? 
                                        Colors.white70
                                       :Colors.grey.shade600
                                    ),
                                    SizedBox(width: 6),
                                    Text(userList[index].company,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                     style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: Theme.of(context).brightness == Brightness.dark ? 
                                        Colors.white70
                                       :Colors.grey.shade600
                                    )),
                                  ],
                                ),
                              ),
                              trailing: InkResponse(
                                key: index == 0 ? keyBottomNavigation1 : null,
                                onTap: ()async {
                                setState(() {
                                    bookmarkBloc.add(InsertBookmark(
                                    userList[index],
                                    context,
                                  ));
                                  });
                                },
                                child: Icon(Icons.bookmark_border_outlined,
                                color: Theme.of(context).primaryColor,
                                ),
                              ),
                              leading: userList[index].imageUrl.isEmpty
                                  ? Icon(Icons.dangerous)
                                  : Container(
                                     width: 70,
                                     height: 70,
                                     decoration: BoxDecoration(
                                      color: Colors.blue.shade100,
                                       borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(6),
                                        topRight: Radius.circular(16),
                                        bottomLeft: Radius.circular(16),
                                        bottomRight:  Radius.circular(6)
                                      ),
                                      image:userList[index].imageUrl != 'null'  ?  DecorationImage(
                                        image: NetworkImage(userList[index].imageUrl)
                                       ) : null
                                     ),
                                    ),
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
        floatingActionButton: _buildScrollToTopButton(),
      ),
    );
  }

  Future<List<JobModel>> jobMark(JobCRUDBloc localDbBloc) async {
    //var data = await getJob(localDbBloc);
    return  localDbBloc.getJobs();
  } 

  Widget _buildScrollToTopButton() {
    return Visibility(
      visible: _scrollController.hasClients &&
          _scrollController.offset > MediaQuery.of(context).size.height,
      child: FloatingActionButton(
        onPressed: _scrollToTop,
        tooltip: 'Scroll to Top',
        child: Icon(Icons.arrow_upward),
      ),
    );
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInOut,
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
