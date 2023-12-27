part of 'bookmarks_bloc.dart';

sealed class BookmarksState extends Equatable {
  const BookmarksState();

  @override
  List<Object> get props => [];
}

final class BookmarksInitial extends BookmarksState {}

final class BookmarksLoading extends BookmarksState {}

final class BookmarksLoaded extends BookmarksState {
  final List<JobModel> jobs;
  const BookmarksLoaded(
    this.jobs,
  );

  @override
  List<Object> get props => [
        jobs,
      ];
}

final class BookmarksError extends BookmarksState {
  const BookmarksError();

  @override
  List<Object> get props => [];
}

final class BookmarksEmpty extends BookmarksState {
  const BookmarksEmpty();

  @override
  List<Object> get props => [];
}

final class BookmarkDeleted extends BookmarksState {
  const BookmarkDeleted();

  @override
  List<Object> get props => [];
}

final class BookmarkAdded extends BookmarksState {
  const BookmarkAdded();

  @override
  List<Object> get props => [];
}
