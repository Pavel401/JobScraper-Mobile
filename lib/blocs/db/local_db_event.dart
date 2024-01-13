// local_db_event.dart

part of 'local_db_bloc.dart';

abstract class LocalDbEvent extends Equatable {
  const LocalDbEvent();

  @override
  List<Object> get props => [];
}

class InitLocalDb extends LocalDbEvent {}

class InsertJob extends LocalDbEvent {
  final List<JobModel> job;

  const InsertJob(this.job);

  @override
  List<Object> get props => [job];
}

class ResetJobs extends LocalDbEvent {}

class GetJobs extends LocalDbEvent {}

class SearchJobs extends LocalDbEvent {
  final String query;

  const SearchJobs(this.query);

  @override
  List<Object> get props => [query];
}
