import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:jobhunt_mobile/model/jobModel.dart';
import 'package:jobhunt_mobile/repo/jobRepository.dart';
import 'package:jobhunt_mobile/services/dbHelper.dart';

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
    
    Future.delayed(Duration(milliseconds: 100));
    emit(LocalDbLoading());
    

    List<JobModel> jobs = await getJobs();
    print("########## Initializing Local DB ${jobs.length} ##########");

    if (jobs.length == 0) {
      final users = await _userRepository.getJobs();
      insertJob(users);
      jobs = await getJobs();
    }
    emit(LocalDbLoaded(jobs));
  }

  Future _searchJobs(String query, Emitter<LocalDbState> emit) async {
   ///Future.delayed(Duration(milliseconds: 100),() {
     emit(LocalDbLoading());
   //});
   Future.delayed(Duration(milliseconds: 100));
    
    await searchResult(query).then((value) {   
       emit(LocalDbLoaded(value));
    });
   
  }

  Future<List<JobModel>> searchResult(String query) async {
    List<JobModel> searchedJobs = await jobDatabaseHelper.searchJobs(query);
    return searchedJobs;
  }
}