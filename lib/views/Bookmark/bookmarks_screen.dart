import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jobhunt_mobile/blocs/Bookmarks/bookmarks_bloc.dart';
import 'package:jobhunt_mobile/model/job_model.dart';
import 'package:jobhunt_mobile/utility/color_util.dart';
import 'package:jobhunt_mobile/views/home_page.dart';
import 'package:jobhunt_mobile/widgets/dissmiss_widget.dart';
import 'package:jobhunt_mobile/widgets/image.dart';
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
            child: CircularProgressIndicator(), // loading while waiting for Bookmark Data
          );
        } else if (state is BookmarksLoaded) {
          return _buildJobList(state.jobs); // List of Jobs Bookmarked 
        } else if (state is BookmarksEmpty) {
          return Center(
            child: Text('No saved jobs.'),
          );
        } else if (state is BookmarksError) {
          return Center(
            child: Text('Error loading saved jobs.'), // Unable to get Bookmarks
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
              _launchURL(job.applyUrl); // ----- Opening Job Url link -----
            },
            child: JobSlideWidget(
             jobKey: Key(index.toString()),
             icon: Icons.delete,
             primaryColor: ColorUtil.errorColor,
             onDismissed: (direction) {

            // --- DismissDirection.horizontal
            // --- It will allow you to remove bookmark with a slide from left to right or right to left horizontally.

             if(direction == DismissDirection.horizontal){
              setState(() {  });
             }
              bookmarkBloc.add(DeleteBookmark(job, context));
            },
            child:  ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 12,vertical: 6),
              title: Text(job.title,  // ---- Job Title for Bookmark ---
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color:ColorUtil.isDarkMode(context) ? 
                  Colors.white
                  :Colors.grey.shade800
              ),
              ),
              leading: CachedImageWidget(url: job.imageUrl), // ---- Job Image for Bookmark ---
              subtitle: RowWrapper(userList: job),  // ---- Company Name for Bookmark ---
              trailing: IconButton(
                onPressed: () {
                  bookmarkBloc.add(DeleteBookmark(job, context));   // ---- Bookmark Icon ---
                },
                icon: Icon(Icons.delete_outline),
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
