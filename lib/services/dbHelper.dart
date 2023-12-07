import 'dart:async';

import 'package:jobhunt_mobile/model/jobModel.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class JobDatabaseHelper {
  static final JobDatabaseHelper _instance = JobDatabaseHelper._internal();

  factory JobDatabaseHelper() => _instance;

  JobDatabaseHelper._internal();

  late Database _database;

  Future<void> initDatabase() async {
    String path = join(await getDatabasesPath(), 'jobs_database.db');
    bool dbExist = await databaseExists(path);

    if (!dbExist) {
      Completer<void> completer = Completer<void>(); // Create Completer

      // If the database does not exist, create it
      _database = await openDatabase(
        path,
        onCreate: (db, version) {
          print('Creating the jobs table...');
          db.execute(
            '''
        CREATE TABLE jobs(
          id TEXT PRIMARY KEY,
          title TEXT,
          location TEXT,
          createdAt INTEGER,
          company TEXT,
          applyUrl TEXT,
          imageUrl TEXT
        )
        ''',
          );
        },
        version: 1,
      );

      completer.complete(); // Complete the Completer
      return completer.future; // Return the future of the Completer
    } else {
      // If the database already exists, open it
      _database = await openDatabase(path, version: 1);
      print('Opening the existing jobs database...');
    }
  }

  Future<void> saveJob(JobModel job) async {
    if (_database == null) {
      // Initialize the database if it's not already initialized
      await initDatabase();

      print('Database initialized');
    }

    // Fetch the list of existing jobs
    List<JobModel> existingJobs = await getSavedJobs();
    print('Previous Jobs: $existingJobs');

    // Add the new job to the list
    existingJobs.add(job);

    // Insert each job to the database
    for (JobModel existingJob in existingJobs) {
      print('Inserting job: ${existingJob.title}}');
      await _database.insert(
        'jobs',
        existingJob.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    // Fetch the updated list of saved jobs
    List<JobModel> updatedJobs = await getSavedJobs();
    print('Updated Jobs: $updatedJobs');

    print('Job saved successfully: ${job.title}');
  }

  Future<void> deleteJob(String title) async {
    final db = await _database;
    await db.delete(
      'jobs',
      where: 'title = ?',
      whereArgs: [title],
    );

    print('Job deleted successfully: $title');
  }

  Future<List<JobModel>> getSavedJobs() async {
    final List<Map<String, dynamic>> maps = await _database.query('jobs');

    print('Number of saved jobs: ${maps.length}');

    return List.generate(maps.length, (i) {
      return JobModel(
        id: maps[i]['id'],
        title: maps[i]['title'],
        location: maps[i]['location'],
        createdAt: maps[i]['createdAt'],
        company: maps[i]['company'],
        applyUrl: maps[i]['applyUrl'],
        imageUrl: maps[i]['imageUrl'],
      );
    });
  }
}
