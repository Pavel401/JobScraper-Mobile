import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jobhunt_mobile/blocs/home/app_blocs.dart';
import 'package:jobhunt_mobile/blocs/home/app_events.dart';
import 'package:jobhunt_mobile/blocs/home/app_states.dart';

import 'package:jobhunt_mobile/model/jobModel.dart';
import 'package:jobhunt_mobile/repo/repositiories.dart';
import 'package:jobhunt_mobile/views/Profile/profile_readView.dart';
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
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.work_outline),
              label: 'Jobs',
              activeIcon: Icon(Icons.work),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bookmark_outline),
              activeIcon: Icon(Icons.bookmark),
              label: 'Bookmarks',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
          currentIndex: _selectedIndex,
          // selectedItemColor: Colors.amber[800],
          onTap: _onItemTapped,
        ),
        key: UniqueKey(),
        drawer: Drawer(
          child: ListView(
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                ),
                child: Text(
                  'Drawer Header',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              ListTile(
                leading: Icon(Icons.home),
                title: Text('Home'),
                onTap: () {
                  // Implement the action for Home
                  Navigator.pop(context); // Close the drawer
                },
              ),
              ListTile(
                leading: Icon(Icons.settings),
                title: Text('Settings'),
                onTap: () {
                  // Implement the action for Settings
                  Navigator.pop(context); // Close the drawer
                },
              ),
              ListTile(
                leading: Icon(Icons.link),
                title: Text('GitHub'),
                onTap: () {
                  // Implement the action for GitHub
                  Navigator.pop(context); // Close the drawer
                },
              ),
              ListTile(
                leading: Icon(Icons.exit_to_app),
                title: Text('Sign Out'),
                onTap: () {
                  // Implement the action for Sign Out
                  Navigator.pop(context); // Close the drawer
                },
              ),
            ],
          ),
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
                            color: Theme.of(context).primaryColor,
                            child: ListTile(
                              title: Text(
                                userList[index].title,
                                style: const TextStyle(color: Colors.white),
                              ),
                              subtitle: Text(
                                userList[index].company,
                                style: const TextStyle(color: Colors.white),
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
}
