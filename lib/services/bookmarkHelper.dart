// job_database_helper.dart

import 'package:jobhunt_mobile/model/jobModel.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class BookmarkDbHelper {
  static final BookmarkDbHelper _instance = BookmarkDbHelper._internal();
  factory BookmarkDbHelper() => _instance;

  late Database _database;

  BookmarkDbHelper._internal();

  Future<void> initDatabase() async {
    _database = await openDatabase(
      join(await getDatabasesPath(), 'bookmark.db'),
      onCreate: (db, version) {
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
      print("########## Error inserting job: $e ##########");
    }
  }

  Future<void> clearJobs() async {
    await _database.delete('jobs');
    print("########## Cleared Jobs ##########");
  }

  Future<void> deleteJob(JobModel job) async {
    await _database.delete(
      'jobs',
      where: 'id = ?',
      whereArgs: [job.id],
    );
    print("########## Deleted Job ##########");
  }

  Future<List<JobModel>> getJobs() async {
    List<JobModel> jobs = [];
    final List<Map<String, dynamic>> maps = await _database.query('jobs');
    print("########## Getting Jobs ##########");

    for (int i = 0; i < maps.length; i++) {
      jobs.add(JobModel.fromJson(maps[i]));
    }

    return jobs;
  }
}
