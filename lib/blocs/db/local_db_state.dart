part of 'local_db_bloc.dart';

sealed class LocalDbState extends Equatable {
  const LocalDbState();

  @override
  List<Object> get props => [];
}

final class LocalDbInitial extends LocalDbState {}

final class LocalDbLoaded extends LocalDbState {
  final List<JobModel> jobs;

  const LocalDbLoaded(this.jobs);

  @override
  List<Object> get props => [jobs];
}

final class LocalDbError extends LocalDbState {
  final String message;

  const LocalDbError(this.message);

  @override
  List<Object> get props => [message];
}

final class LocalDbLoading extends LocalDbState {}
