import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:jobhunt_mobile/model/jobModel.dart';

class UserRepository {
  String userUrl = dotenv.env['JOB_API'].toString();

  Future<List<JobModel>> getJobs() async {
    try {
      print("########## Fetching Jobs ##########");
      print(userUrl);

      // Creating a Dio instance with a custom timeout
      Dio dio = Dio();
      dio.options.connectTimeout = Duration(seconds: 10000);  // Set the timeout in milliseconds
 // Set the timeout in milliseconds

      Response response = await dio.get(userUrl);
      print(response);
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
