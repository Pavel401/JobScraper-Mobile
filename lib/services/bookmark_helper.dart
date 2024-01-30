// job_database_helper.dart

import 'package:jobhunt_mobile/model/job_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class BookmarkDbHelper {
  static final BookmarkDbHelper _instance = BookmarkDbHelper._internal();
  factory BookmarkDbHelper() => _instance;

  late Database _database;

  BookmarkDbHelper._internal();

  Future<void> initDatabase() async {

  // ----  Open the database at a given path ----

    _database = await openDatabase(
      join(await getDatabasesPath(), 'bookmark.db'),
      onCreate: (db, version) {

      // --------- Create the required table in the local database if not exist will be created ---------

        return db.execute(
          '''
        CREATE TABLE IF NOT EXISTS jobs (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        location TEXT,
        createdAt INTEGER,
        company TEXT,
        applyUrl TEXT,
        ImageUrl TEXT
        )
          ''',
        );
      },
      version: 1,
    );
  }

  String insert =
      '''INSERT INTO jobs (title, location, createdAt, company, applyUrl, ImageUrl)
	VALUES (?, ?, ?, ?, ?, ?)''';

  // --------- Adding Job Card Bookmark Data in the local database ---------

  Future<void> insertJob(JobModel job) async {
    try {
      await _database.rawInsert(
        insert,
        [
          job.title,
          job.location,
          job.createdAt,
          job.company,
          job.applyUrl,
          job.imageUrl,
        ],
      );
    } catch (e) {
      print("------------ Error inserting job: $e ------------");
    }
  }

  Future<void> clearJobs() async {
    await _database.delete('jobs');
    print("------------ Cleared Jobs ------------");
  }

  Future<void> deleteJob(JobModel job) async {

   // --------- Removing Bookmark Data from the local database ---------
   
    await _database.delete(
      'jobs',
      where: 'id = ?',
      whereArgs: [job.id],
    );
    print("------------- Deleted Job -----------");
  }

  Future<List<JobModel>> getJobs() async {

    // --------- Getting Bookmark Data from the local database ---------

    List<JobModel> jobs = [];
    final List<Map<String, dynamic>> maps = await _database.query('jobs');
    print("------------ Getting Jobs ------------");

    for (int i = 0; i < maps.length; i++) {
      jobs.add(JobModel.fromJson(maps[i]));
    }

    return jobs;
  }
}