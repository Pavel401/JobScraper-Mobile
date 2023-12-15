part of 'local_db_bloc.dart';

sealed class LocalDbEvent extends Equatable {
  const LocalDbEvent();

  @override
  List<Object> get props => [];
}

final class InitLocalDb extends LocalDbEvent {
  const InitLocalDb();

  @override
  List<Object> get props => [];
}

final class InsertJob extends LocalDbEvent {
  final List<JobModel> job;

  const InsertJob(this.job);

  @override
  List<Object> get props => [job];
}

final class ResetJobs extends LocalDbEvent {
  const ResetJobs();

  @override
  List<Object> get props => [];
}

final class GetJobs extends LocalDbEvent {
  const GetJobs();

  @override
  List<Object> get props => [];
}
