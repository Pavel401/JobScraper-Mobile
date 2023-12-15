import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:jobhunt_mobile/model/jobModel.dart';
import 'package:jobhunt_mobile/repo/repositiories.dart';
import 'package:jobhunt_mobile/services/dbHelper.dart';

part 'local_db_event.dart';
part 'local_db_state.dart';

class LocalDbBloc extends Bloc<LocalDbEvent, LocalDbState> {
  final UserRepository _userRepository;

  LocalDbBloc(this._userRepository) : super(LocalDbInitial()) {
    on<LocalDbEvent>((event, emit) {
      if (event is InsertJob) {
        insertJob(event.job);
      }
    });

    on<ResetJobs>((event, emit) async {
      emit(LocalDbLoading());
      await jobDatabaseHelper.clearJobs();
      final users = await _userRepository.getJobs();
      insertJob(users);
      List<JobModel> jobs = await getJobs();
      emit(LocalDbLoaded(jobs));
    });

    on<InitLocalDb>((event, emit) async {
      emit(LocalDbLoading());

      List<JobModel> jobs = await getJobs();
      print("########## Initializing Local DB ${jobs.length} ##########");

      if (jobs.length == 0) {
        final users = await _userRepository.getJobs();
        insertJob(users);
        jobs = await getJobs();
      }
      // jobDatabaseHelper.clearJobs();
      emit(LocalDbLoaded(jobs));
    });
  }

  JobDatabaseHelper jobDatabaseHelper = JobDatabaseHelper();

  void insertJob(List<JobModel> job) {
    print("########## Inserting Jobs ##########");
    jobDatabaseHelper.initDatabase().then((value) {
      job.forEach((element) {
        jobDatabaseHelper.insertJob(element);
      });
    });
  }

  Future<List<JobModel>> getJobs() async {
    List<JobModel> jobs = [];
    await jobDatabaseHelper.initDatabase();
    jobs = await jobDatabaseHelper.getJobs();

    return jobs;
  }
}
