// local_db_state.dart

part of 'local_db_bloc.dart';

abstract class LocalDbState extends Equatable {
  const LocalDbState();

  @override
  List<Object> get props => [];
}

class LocalDbInitial extends LocalDbState {}

class LocalDbLoaded extends LocalDbState {
  final List<JobModel> jobs;

  const LocalDbLoaded(this.jobs);

  @override
  List<Object> get props => [jobs];
}

class LocalDbError extends LocalDbState {
  final String message;

  const LocalDbError(this.message);

  @override
  List<Object> get props => [message];
}

class LocalDbLoading extends LocalDbState {}
