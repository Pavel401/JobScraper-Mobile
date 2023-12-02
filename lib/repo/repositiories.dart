import 'package:dio/dio.dart';
import 'package:jobhunt_mobile/model/jobModel.dart';

class UserRepository {
  String userUrl =
      'https://jobs-scraper-production.up.railway.app/getallJobsFromSQL';

  Future<List<JobModel>> getJobs() async {
    try {
      Response response = await Dio().get(userUrl);

      if (response.statusCode == 200) {
        List<dynamic> data = response.data as List<dynamic>;

        List<JobModel> jobs =
            data.map((item) => JobModel.fromJson(item)).toList();

        return jobs;
      } else {
        throw Exception(response.statusMessage);
      }
    } catch (e) {
      throw Exception('Failed to fetch jobs');
    }
  }
}
