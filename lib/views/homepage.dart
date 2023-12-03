import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jobhunt_mobile/blocs/home/app_blocs.dart';
import 'package:jobhunt_mobile/blocs/home/app_events.dart';
import 'package:jobhunt_mobile/blocs/home/app_states.dart';

import 'package:jobhunt_mobile/model/jobModel.dart';
import 'package:jobhunt_mobile/repo/repositiories.dart';
import 'package:jobhunt_mobile/services/authentication.dart';
import 'package:jobhunt_mobile/views/Profile/profile_readView.dart';
import 'package:jobhunt_mobile/views/Settings/settings.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key});
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    Text(
      'Index 0: Home',
      style: optionStyle,
    ),
    Text(
      'Index 1: Business',
      style: optionStyle,
    ),
    Text(
      'Index 2: School',
      style: optionStyle,
    ),
  ];

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  int _drawerIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final refreshBloc = BlocProvider.of<UserBloc>(context);

    return BlocProvider(
      create: (context) => UserBloc(
        UserRepository(),
      )..add(LoadUserEvent()),
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
              icon: Icon(Icons.work_outline),
              label: 'Jobs',
              selectedIcon: Icon(Icons.work),
            ),
            NavigationDestination(
              icon: Icon(Icons.bookmark_outline),
              selectedIcon: Icon(Icons.bookmark),
              label: 'Bookmarks',
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
          children: const <Widget>[
            SizedBox(height: 16),
            NavigationDrawerDestination(
              icon: Icon(Icons.work),
              label: Text('Jobs'),
            ),
            NavigationDrawerDestination(
              icon: Icon(Icons.settings),
              label: Text('Settings'),
            ),
            Divider(),
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
          title: const Text("Job Hunt"),
          actions: [
            _selectedIndex == 0
                ? IconButton(
                    onPressed: () {
                      refreshBloc.add(ReloadUserEvent());
                    },
                    icon: const Icon(Icons.replay_outlined),
                  )
                : SizedBox.shrink(),
          ],
        ),
        body: PageView(
          controller: PageController(initialPage: _selectedIndex),
          children: [
            BlocBuilder<UserBloc, UserState>(
              bloc: refreshBloc,
              builder: (context, state) {
                if (state is UserLoadingState) {
                  print("UserLoadingState");
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (state is UserErrorState) {
                  print("UserErrorState");
                  return const Center(child: Text("Error"));
                }
                if (state is UserLoadedState) {
                  print("UserLoadedState");
                  List<JobModel> userList = state.jobs;
                  return ListView.builder(
                    itemCount: userList.length,
                    itemBuilder: (_, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 4, horizontal: 8),
                        child: GestureDetector(
                          onTap: () {
                            _launchURL(
                                userList[index].applyUrl); // Launch URL on tap
                          },
                          child: Card(
                            child: ListTile(
                              title: Text(
                                userList[index].title,
                              ),
                              subtitle: Text(
                                userList[index].company,
                              ),
                              leading: CircleAvatar(
                                backgroundImage:
                                    NetworkImage(userList[index].imageUrl),
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
            Container(
              color: Colors.green,
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
      Navigator.of(context).pop();
    }
    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return SettingsView();
          },
        ),
      );
    }
    if (index == 2) {
      if (!await launchUrl(
          Uri.parse("https://github.com/Pavel401/JobScraper-Mobile"))) {
        throw Exception('Could not launch ');
      }
    }

    if (index == 3) {
      final AuthService authService = AuthService();
      authService.signOutUser();
    }
  }
}
