// bookmarks_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jobhunt_mobile/blocs/Bookmarks/bookmarks_bloc.dart';
import 'package:jobhunt_mobile/model/jobModel.dart';
import 'package:url_launcher/url_launcher.dart';

class BookmarksScreen extends StatefulWidget {
  @override
  _BookmarksScreenState createState() => _BookmarksScreenState();
}

class _BookmarksScreenState extends State<BookmarksScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookmarksBloc, BookmarksState>(
      builder: (context, state) {
        if (state is BookmarksLoading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is BookmarksLoaded) {
          return _buildJobList(state.jobs);
        } else if (state is BookmarksEmpty) {
          return Center(
            child: Text('No saved jobs.'),
          );
        } else if (state is BookmarksError) {
          return Center(
            child: Text('Error loading saved jobs.'),
          );
        } else {
          return Container(); // Handle other states if needed
        }
      },
    );
  }

  Widget _buildJobList(List<JobModel> jobs) {
    final bookmarkBloc = BlocProvider.of<BookmarksBloc>(context);

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: ListView.builder(
        key: ValueKey(jobs.length),
        itemCount: jobs.length,
        itemBuilder: (context, index) {
          JobModel job = jobs[index];
          return GestureDetector(
            onTap: () {
              _launchURL(job.applyUrl);
            },
            child: Dismissible(
            key: Key(jobs[index].toString()),
            background: Container(
              color: Colors.red.withOpacity(0.25),
              child: Icon(Icons.delete, color:Colors.red),
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(left: 20.0),
            ),
            secondaryBackground: Container(
              color:Colors.red.withOpacity(0.25),
              child: Icon(Icons.delete, color:Colors.red),
              alignment: Alignment.centerRight,
              padding: EdgeInsets.only(right: 20.0),
            ),
            dismissThresholds: {
              DismissDirection.endToStart : 0.25,
              DismissDirection.startToEnd : 0.25,
            },
            onDismissed: (direction) {
             if(direction == DismissDirection.horizontal){
              setState(() {  });
             }
              bookmarkBloc.add(DeleteBookmark(job, context));
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
                  title: Text(job.title,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color:Theme.of(context).brightness == Brightness.dark ? 
                      Colors.white
                      :Colors.grey.shade800
                  ),
                  ),
                  leading:job.imageUrl.isEmpty
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
                      image:job.imageUrl != 'null'  ?  DecorationImage(
                        image: NetworkImage(job.imageUrl)
                        ) : null
                      ),
                    ),
                  subtitle: Padding(
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
                        Text(job.company,
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
                  trailing: IconButton(
                    onPressed: () {
                      bookmarkBloc.add(DeleteBookmark(job, context));
                    },
                    icon: Icon(Icons.delete_outline),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _launchURL(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw Exception('Could not launch $url');
    }
  }
}
