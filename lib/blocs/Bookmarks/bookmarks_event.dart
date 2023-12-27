part of 'bookmarks_bloc.dart';

sealed class BookmarksEvent extends Equatable {
  const BookmarksEvent();

  @override
  List<Object> get props => [];
}

final class InsertBookmark extends BookmarksEvent {
  final JobModel job;
  final BuildContext context;
  const InsertBookmark(
    this.job,
    this.context,
  );

  @override
  List<Object> get props => [
        job,
        context,
      ];
}

final class DeleteBookmark extends BookmarksEvent {
  final BuildContext context;
  final JobModel job;
  const DeleteBookmark(
    this.job,
    this.context,
  );

  @override
  List<Object> get props => [
        job,
        context,
      ];
}

final class GetBookmarks extends BookmarksEvent {
  const GetBookmarks();

  @override
  List<Object> get props => [];
}
