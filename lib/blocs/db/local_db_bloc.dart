import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:jobhunt_mobile/model/job_model.dart';
import 'package:jobhunt_mobile/repo/job_repository.dart';
import 'package:jobhunt_mobile/services/db_helper.dart';

part 'local_db_event.dart';
part 'local_db_state.dart';

class JobCRUDBloc extends Bloc<LocalDbEvent, LocalDbState> {
  final UserRepository _userRepository;

  JobCRUDBloc(this._userRepository) : super(LocalDbInitial()) {
    on<LocalDbEvent>((event, emit) async {
      if (event is InsertJob) {
        insertJob(event.job);
      } else if (event is ResetJobs) {
        await _resetJobs(emit);
      } else if (event is InitLocalDb) {
        await _initLocalDb(emit);
      } else if (event is SearchJobs) {
        await _searchJobs(event.query, emit);
      }
    });
  }

  LocalDBHelper jobDatabaseHelper = LocalDBHelper();

  void insertJob(List<JobModel> job) {
    print("########## Inserting Jobs ##########");
    jobDatabaseHelper.initDatabase().then((value) {
      job.forEach((element) {
        print("########## Inserting Job: ${element.imageUrl} ##########");
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

  Future _resetJobs(Emitter<LocalDbState> emit) async {
    emit(LocalDbLoading());
    await jobDatabaseHelper.clearJobs();
    final users = await _userRepository.getJobs();
    insertJob(users);
    List<JobModel> jobs = await getJobs();
    emit(LocalDbLoaded(jobs));
  }

  Future _initLocalDb(Emitter<LocalDbState> emit) async {
    
    // ------------ Awaiting emit to prepare ---------------
    Future.delayed(Duration(milliseconds: 100));
    emit(LocalDbLoading());
    

    List<JobModel> jobs = await getJobs();
    // ------------ Initializing Local DB getting Jobs ---------------

    if (jobs.length == 0) {
      final users = await _userRepository.getJobs();
      insertJob(users);
      jobs = await getJobs();
    }
    emit(LocalDbLoaded(jobs));
  }

  Future _searchJobs(String query, Emitter<LocalDbState> emit) async {
  
   emit(LocalDbLoading());
   Future.delayed(Duration(milliseconds: 100));
    
    await searchResult(query).then((value) {   
       emit(LocalDbLoaded(value));
    });
   
  }


  Future<List<JobModel>> searchResult(String query) async {
    // ------------ Search Results from Local Db ---------------
    List<JobModel> searchedJobs = await jobDatabaseHelper.searchJobs(query);
    return searchedJobs;
  }
}