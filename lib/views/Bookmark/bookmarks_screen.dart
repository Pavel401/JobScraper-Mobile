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
        itemCount: jobs.length,
        itemBuilder: (context, index) {
          JobModel job = jobs[index];
          return GestureDetector(
            onTap: () {
              _launchURL(job.applyUrl);
            },
            child: Card(
              child: ListTile(
                trailing: IconButton(
                  onPressed: () {
                    bookmarkBloc.add(DeleteBookmark(job, context));
                  },
                  icon: Icon(Icons.delete_outline),
                ),
                title: Text(job.title),
                subtitle: Text(job.company),
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
