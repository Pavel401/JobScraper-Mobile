import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:jobhunt_mobile/model/jobModel.dart';
import 'package:jobhunt_mobile/services/bookmarkHelper.dart';
import 'package:jobhunt_mobile/widgets/toast.dart';

part 'bookmarks_event.dart';
part 'bookmarks_state.dart';

class BookmarksBloc extends Bloc<BookmarksEvent, BookmarksState> {
  BookmarksBloc() : super(BookmarksInitial()) {
    on<BookmarksEvent>((event, emit) {});

    on<InsertBookmark>((event, emit) async {
      emit(BookmarksLoading());
      insertBookmark(event.job, event.context);
      List<JobModel> jobs = await getBookmarks();
      if (jobs.length == 0) {
        emit(BookmarksEmpty());
      } else {
        emit(BookmarksLoaded(
          jobs,
        ));
      }
    });

    on<DeleteBookmark>((event, emit) async {
      deleteBookmark(event.job, event.context);
      List<JobModel> jobs = await getBookmarks();
      if (jobs.length == 0) {
        emit(BookmarksEmpty());
      } else {
        emit(BookmarksLoaded(
          jobs,
        ));
      }
    });
    on<GetBookmarks>((event, emit) async {
      emit(BookmarksLoading());
      List<JobModel> jobs = await getBookmarks();
      if (jobs.length == 0) {
        emit(BookmarksEmpty());
      } else {
        emit(BookmarksLoaded(
          jobs,
        ));
      }
    });
  }
  BookmarkDbHelper bookmarkDbHelper = BookmarkDbHelper();
  void insertBookmark(JobModel job, BuildContext context) {
    bookmarkDbHelper.initDatabase().then((value) {
      bookmarkDbHelper.insertJob(job);
    });
    ToastWidget(message: 'Job Saved.').showToast(context);
  }

  void deleteBookmark(JobModel job, BuildContext context) {
    bookmarkDbHelper.initDatabase().then((value) {
      bookmarkDbHelper.deleteJob(job);
    });

    ToastWidget(message: 'Job Deleted.').showToast(context);

  }

  Future<List<JobModel>> getBookmarks() async {
    List<JobModel> jobs = [];
    await bookmarkDbHelper.initDatabase();
    jobs = await bookmarkDbHelper.getJobs();

    return jobs;
  }
}
