import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jobhunt_mobile/blocs/Bookmarks/bookmarks_bloc.dart';
import 'package:jobhunt_mobile/blocs/db/local_db_bloc.dart';

import 'package:jobhunt_mobile/model/job_model.dart';
import 'package:jobhunt_mobile/repo/job_repository.dart';

import 'package:jobhunt_mobile/services/db_helper.dart';
import 'package:jobhunt_mobile/utility/color_util.dart';
import 'package:jobhunt_mobile/views/About/about_us.dart';
import 'package:jobhunt_mobile/views/Bookmark/bookmarks_screen.dart';
import 'package:jobhunt_mobile/views/Search/search.dart';
import 'package:jobhunt_mobile/views/Settings/settings.dart';
import 'package:jobhunt_mobile/widgets/anim_widget.dart';
import 'package:jobhunt_mobile/widgets/dissmiss_widget.dart';
import 'package:jobhunt_mobile/widgets/image.dart';
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

  GlobalKey keyBottomNavigation1 = GlobalKey();
  GlobalKey keyBottomNavigation2 = GlobalKey();
  GlobalKey keyBottomNavigation3 = GlobalKey();
  GlobalKey<ScaffoldState> drawerKey  = GlobalKey<ScaffoldState>();
  PageController pageController = PageController(initialPage: 0);

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
      onSkip: () {
        return true;
      },
    );
  }

  List<TargetFocus> _createTargets() {

  try {

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
       
  } catch (e) {
     
      return [];
   }
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
        bottomNavigationBar: ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30)
          ),
          child: NavigationBar(
            selectedIndex: _selectedIndex,
            onDestinationSelected: (int index) {
              setState(() {
                _selectedIndex = index;
                 pageController.animateToPage(_selectedIndex,
                  duration: Duration(milliseconds: 300), curve: Curves.easeIn);
              });
              
            },
            destinations: [
              NavigationDestination(
                icon: Icon(Icons.home_outlined),
                selectedIcon: AnimationFadeScale(
                  key: ValueKey(6),
                  child: Icon(Icons.home)),
                 label: 'Home',
              ),
              NavigationDestination(
                icon: Icon(Icons.bookmark_border_outlined),
                selectedIcon: AnimationFadeScale(
                  key: ValueKey(_selectedIndex),
                  child: Icon(Icons.bookmark)),
                label: 'Bookmarks',
              ),
            ],
          ),
        ),
        // key: UniqueKey(),
        key: drawerKey,
        drawer: SizedBox(
          width: MediaQuery.of(context).size.width/1.7,
          child: drawer()),
        appBar: AppBar(
          toolbarHeight: 62,
          leading: InkResponse(
            onTap: () {
              drawerKey.currentState!.openDrawer();
            },
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SvgIcon(
                icon: "assets/svg/menu.svg",
                width: 24,
                height: 24,
                color: Colors.white,
              ),
            ),
          ),
          backgroundColor: Theme.of(context).primaryColor,
          title: _selectedIndex == 0 ? Text("Job Hunt") : Text("Bookmarks"),
          titleTextStyle: Theme.of(context).textTheme.titleLarge!.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold
          ),
          actions: [
            _selectedIndex == 0
                ? IconButton(
                    onPressed: () {
                      localDbBloc.add(ResetJobs());
                    },
                    icon: SvgIcon(icon: "assets/svg/refresh.svg",
                    width: 24,
                    height: 24,
                    color: Colors.white,
                    ),
                  )
                : SizedBox.shrink(),
            _selectedIndex == 0
                ? IconButton(
                    icon: SvgIcon(icon: "assets/svg/search.svg",
                    width: 26,
                    height: 26,
                    color: Colors.white,
                    ),
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
                SizedBox(width: 8)
          ],
        ),
        body: PageView(
          physics: NeverScrollableScrollPhysics(),
          controller: pageController,
          children: [
            BlocBuilder<JobCRUDBloc, LocalDbState>(
              bloc: localDbBloc,
              builder: (context, state) {
                if (state is LocalDbLoading) {
                  print('object');
                  // When state is LocalDbLoading it will show loading
                  // which means there can be instances when data don't load due to Socket Exception or Server Exception
                
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (state is LocalDbLoaded && state.jobs.isNotEmpty) {
                 
                 // When state is LocalDbLoaded list of Job Card will be displayed
                 
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
                          child: JobSlideWidget(
                          index: index,
                          jobKey: Key(index.toString()),
                          icon: Icons.bookmark,
                          onDismissed: (direction) {
                              setState(() {
                               bookmarkBloc.add(InsertBookmark(
                                    userList[index],
                                    context,
                                  ));
                              });
                          },
                          child:  ListTile(
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
                              child: RowWrapper(key: index == 0 ? keyBottomNavigation2 : null, userList: userList[index]),
                            ),
                            trailing: Padding(
                              padding: const EdgeInsets.only(right :8.0),
                              child: InkResponse(
                                key: index == 0 ? keyBottomNavigation1 : null,
                                onTap: ()async {
                                setState(() {
                                    bookmarkBloc.add(InsertBookmark(
                                    userList[index],
                                    context,
                                  ));
                                  });
                                },
                                child: SvgIcon(
                                icon:"assets/svg/bookmark.svg",
                                color: Theme.of(context).primaryColor,
                                ),
                              ),
                            ),
                            leading:CachedImageWidget(url: userList[index].imageUrl), 
                           ),
                          ),
                        ),
                      );
                    },
                  );
                }

                return NoDataWidget();
              },
            ),
            BookmarksScreen(),
          ],
        ),
        floatingActionButton: _buildScrollToTopButton(),
      ),
    );
  }

  NavigationDrawer drawer() {
    return NavigationDrawer(
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
              icon: AnimationFadeSlide(
                duration: 400,
                dx: 0.3,
                child: Icon(Icons.settings)
              ),
              label: Text('Settings'),
            ),
            NavigationDrawerDestination(
              icon:AnimationFadeSlide(
                duration: 600,
                dx: 0.5,
                child: FaIcon(FontAwesomeIcons.github),
                 ),
              label: Text('Github')),
           NavigationDrawerDestination(
              icon: AnimationFadeSlide(
                duration: 750,
                dx: 0.7,
                child:Icon(Icons.info_outline)),
              label: Text('About Us'),
          ),
        ],
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

class NoDataWidget extends StatelessWidget {
  const NoDataWidget({
    super.key,
    this.title,
    this.icon,
    this.subtitle
  });

  final String? subtitle,icon,title;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgIcon(icon: icon ?? 'assets/svg/empty.svg',
          width: 100,
          height: 100,
          color: ColorUtil.isDarkMode(context) ?
           Theme.of(context).primaryColor: Colors.black,
        ),
         SizedBox(height: 24),
        Text( title ?? 'No Job related data found',
        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
          fontWeight: FontWeight.w700,
          color: Theme.of(context).primaryColor
        ),
        ),
        SizedBox(height: 16),
        Text( subtitle ?? 'Please try again after sometime.'),
        SizedBox(height: 16),
      ],
    );
  }
}

class RowWrapper extends StatelessWidget {
  const RowWrapper({
    super.key,
    required this.userList,
  });

  final JobModel userList;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(top: 2),
        child: Row(
        children: [
          Icon(Icons.business,
          size: 15,
           color: Theme.of(context).brightness == Brightness.dark ? 
              Colors.white70
             :Colors.grey.shade600
          ),
          SizedBox(width: 6),
          Text(userList.company,
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
    );
  }
}

