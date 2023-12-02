import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jobhunt_mobile/blocs/home/app_blocs.dart';
import 'package:jobhunt_mobile/blocs/home/app_events.dart';
import 'package:jobhunt_mobile/repo/repositiories.dart';
import 'package:jobhunt_mobile/views/Auth/signup.dart';
import 'package:jobhunt_mobile/views/homepage.dart';

class AuthenticationFlowScreen extends StatelessWidget {
  const AuthenticationFlowScreen({super.key});
  static String id = 'main screen';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return BlocProvider(
              create: (context) => UserBloc(
                UserRepository(),
              )..add(LoadUserEvent()),
              child: HomePage(),
            );
          } else {
            return const SignupScreen();
          }
        },
      ),
    );
  }
}
