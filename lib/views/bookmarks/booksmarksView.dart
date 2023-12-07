import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/svg.dart';
import 'package:jobhunt_mobile/model/jobModel.dart';
import 'package:jobhunt_mobile/services/dbHelper.dart';
import 'package:jobhunt_mobile/widgets/illustration.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

class BookmarksView extends StatefulWidget {
  const BookmarksView({Key? key}) : super(key: key);

  @override
  _BookmarksViewState createState() => _BookmarksViewState();
}

class _BookmarksViewState extends State<BookmarksView> {
  List<JobModel> savedJobs = [];
  final JobDatabaseHelper jobDatabaseHelper = JobDatabaseHelper();
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    // jobDatabaseHelper.initDatabase();
    loadSavedJobs();
  }

  Future<void> loadSavedJobs() async {
    final List<JobModel> savedList = await jobDatabaseHelper.getSavedJobs();

    setState(() {
      savedJobs = savedList;
      isLoading = false;
    });
  }

  Future<void> deleteJob(int index) async {
    await jobDatabaseHelper.deleteJob(savedJobs[index].title);
    savedJobs.removeAt(index);
    SnackBar snackBar = SnackBar(
      content: Text('Job removed from bookmarks'),
      duration: Duration(seconds: 1),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);

    loadSavedJobs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Bookmarks'),
        ),
        body: savedJobs.length > 0 && !isLoading
            ? ListView.builder(
                itemCount: savedJobs.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    child: GestureDetector(
                      onTap: () {
                        _launchURL(savedJobs[index].applyUrl);
                      },
                      child: Slidable(
                        key: UniqueKey(),
                        startActionPane: ActionPane(
                          key: UniqueKey(),
                          motion: ScrollMotion(),
                          children: [
                            SlidableAction(
                              onPressed: (context) {
                                deleteJob(index);
                              },
                              backgroundColor: Theme.of(context).primaryColor,
                              foregroundColor: Colors.white,
                              icon: Icons.delete_forever_outlined,
                              label: 'Remove',
                            ),
                          ],
                        ),
                        child: Card(
                          child: ListTile(
                            title: Text(savedJobs[index].title),
                            subtitle: Text(savedJobs[index].company),
                            leading: CircleAvatar(
                              backgroundImage:
                                  NetworkImage(savedJobs[index].imageUrl),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              )
            : isLoading
                ? Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: ListView.builder(
                      itemCount:
                          5, // You can adjust the number of shimmer items
                      itemBuilder: (context, index) {
                        return Padding(
                          padding:
                              EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                          child: Card(
                            child: ListTile(
                              title: Container(
                                width: double.infinity,
                                height: 16,
                                color: Colors.white, // Shimmer color
                              ),
                              subtitle: Container(
                                width: double.infinity,
                                height: 12,
                                color: Colors.white, // Shimmer color
                              ),
                              leading: CircleAvatar(
                                backgroundColor: Colors.white, // Shimmer color
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  )
                : Illustration());
  }

  Future<void> _launchURL(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw Exception('Could not launch $url');
    }
  }
}
