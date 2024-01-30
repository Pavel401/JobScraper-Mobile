import 'package:flutter/material.dart';
import 'package:jobhunt_mobile/blocs/db/local_db_bloc.dart';

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