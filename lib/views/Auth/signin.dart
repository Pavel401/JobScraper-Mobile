import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jobhunt_mobile/blocs/auth/authentication_Event.dart';
import 'package:jobhunt_mobile/blocs/auth/authentication_bloc.dart';
import 'package:jobhunt_mobile/blocs/auth/authentication_state.dart';
import 'package:jobhunt_mobile/blocs/home/app_blocs.dart';
import 'package:jobhunt_mobile/blocs/home/app_events.dart';
import 'package:jobhunt_mobile/repo/repositiories.dart';
import 'package:jobhunt_mobile/views/homepage.dart';

class SignInScreen extends StatefulWidget {
  static String id = 'login_screen';

  const SignInScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  // Text Controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Login to Your Account',
          style: TextStyle(
            color: Colors.deepPurple,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const Text('Email address'),
            const SizedBox(height: 10),
            TextFormField(
              controller: emailController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter your email',
              ),
            ),
            const SizedBox(height: 10),
            const Text('Password'),
            TextFormField(
              controller: passwordController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter your password',
              ),
              obscureText: false,
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () {},
              child: const Text(
                'Forgot password?',
                style: TextStyle(
                  color: Colors.deepPurple,
                ),
              ),
            ),
            const SizedBox(height: 20),
            BlocConsumer<AuthenticationBloc, AuthenticationState>(
              listener: (context, state) {
                if (state is AuthenticationSuccessState) {
                  print('success');
                } else if (state is AuthenticationFailureState) {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return const AlertDialog(
                          content: Text('error'),
                        );
                      });
                }
              },
              builder: (context, state) {
                return SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      BlocProvider.of<AuthenticationBloc>(context).add(
                        SignInUser(
                          emailController.text.trim(),
                          passwordController.text.trim(),
                        ),
                      );
                    },
                    child: Text(
                      state is AuthenticationLoadingState
                          ? '.......'
                          : 'Sign In',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            //     const Text("Dont have an account? "),
            //     GestureDetector(
            //       onTap: () {},
            //       child: const Text(
            //         'Login',
            //         style: TextStyle(
            //           color: Colors.deepPurple,
            //         ),
            //       ),
            //     )
            //   ],
            // ),
          ],
        ),
      ),
    );
  }
}
