import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:jobhunt_mobile/main.dart';
import 'package:jobhunt_mobile/utility/color_util.dart';

class JobException implements Exception {

  String message,subMessage;
  JobException({this.message="Something Went Wrong!!", this.subMessage=''});

  String printStack() {
    return 'Job Exception: $message\n$subMessage';
  }

  Future<dynamic> showMessage() async{
    return showDialog(context: navigatorKey.currentState!.context, builder: (context) {
      return AlertDialog.adaptive(
      backgroundColor:message == 'Connection Error'?
       ColorUtil.yellowColor300
      : ColorUtil.errorColor300,
      content: showErrorToast());
     }); 
  }

  Widget showErrorToast(){
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: message == 'Connection Error' ? 
                Image.asset("assets/png/server_error.png",
                width: 70,
                height: 70,
                )
                 : Image.asset("assets/png/error.png",
                width: 70,
                height: 70,
                ),
              ),
              const SizedBox(height: 24),
              Text(message,
              style : TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: ColorUtil.errorColor
            )),
              const SizedBox(height: 16),
              Text(subMessage,
              textAlign: TextAlign.center,
              style : TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: ColorUtil.errorColor
              ))
            ],
          ),
        ),
        Positioned(
          right: 0,
          top: 0,
          child: GestureDetector(
            onTap: () {
              Navigator.pop(navigatorKey.currentState!.context);
            },
            child: CircleAvatar(
              backgroundColor: Colors.transparent,
              child: Icon(Icons.close),
            ),
          )
          )
      ],
    );
  }
}

Future handleDioException(dynamic exception) async {
  if (exception is DioException) {
    switch (exception.type) {
      case DioExceptionType.cancel:
        // Handle cancellation
        JobException(message:'Request was cancelled').showMessage();

        break;
      case DioExceptionType.connectionTimeout:
        // Handle connection timeout 
         JobException(message:'Connection timeout',
         subMessage: "Connection timeout. Please try Again later."
         ).showMessage();
       
        break;
      case DioExceptionType.sendTimeout:
        // Handle send timeout
        JobException(message:'Send timeout',
        subMessage: "It occurs when url is sent timeout. Please try Again later."
        ).showMessage();

        break;
      case DioExceptionType.receiveTimeout:
        // Handle receive timeout
         JobException(message:'Receive timeout',
          subMessage: "Timed Out. Please try Again"
         ).showMessage();
        break;
     
      case DioExceptionType.unknown:
        // Handle other Dio errors
         JobException(message:'Something Went Wrong',
         subMessage: "Error unknown. Please try Again"
         ).showMessage();
        break;
      case DioExceptionType.badCertificate:
        JobException(message:'Bad Certificate',
        subMessage: "Bad Certificate caused by an incorrect certificate."
        ).showMessage();
        break;
      case DioExceptionType.badResponse:
       JobException(message:'Bad Response',
        subMessage: "Bad Response couldn\'t be get response."
       ).showMessage();
         break;
      case DioExceptionType.connectionError:
        JobException(message:'Connection Error',
        subMessage: "Connection couldn\'t be established due to unavailable server.").showMessage();
    }
  } else {
    // Handle generic errors
    print('An unexpected error occurred: $exception');
  }
}