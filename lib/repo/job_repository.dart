import 'package:dio/dio.dart' as di;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:jobhunt_mobile/error_handling/exception.dart';
import 'package:jobhunt_mobile/model/job_model.dart';

class UserRepository {
  String userUrl = dotenv.env['JOB_API'].toString();

  Future<List<JobModel>> getJobs() async {
    try {
      print("------------- Fetching Jobs ------------");
      print(userUrl);

      // Creating a Dio instance with a custom timeout
      di.Dio dio = di.Dio();
      dio.options.connectTimeout = Duration(seconds: 10000);  // Set the timeout in milliseconds


     di.Response response = await dio.get(userUrl);
      print(response);
      if (response.statusCode == 200) {
        List<dynamic> data = response.data as List<dynamic>;

        List<JobModel> jobs =
            data.map((item) => JobModel.fromJson(item)).toList();

        return jobs;
      } else {

       return [];
        
      }
    } on di.DioException catch (e) {
       handleDioException(e);
    } 
     return [];
  }
}
