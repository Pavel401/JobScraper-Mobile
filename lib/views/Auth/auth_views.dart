import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jobhunt_mobile/blocs/auth/authentication_Event.dart';
import 'package:jobhunt_mobile/blocs/auth/authentication_bloc.dart';
import 'package:jobhunt_mobile/blocs/auth/authentication_state.dart';

class SignupScreen extends StatefulWidget {
  static String id = 'login_screen';

  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  // Text Controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // Flag to toggle between sign-up and sign-in modes
  bool isSignUpMode = true;
  bool isRecruiter = false;

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
        title: Text(
          isSignUpMode ? 'Sign Up' : 'Sign In',
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
              obscureText: true,
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Text('Are you a recruiter?'),
                Switch(
                  value: isRecruiter,
                  onChanged: (value) {
                    setState(() {
                      isRecruiter = value;
                    });
                  },
                ),
              ],
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
                    },
                  );
                }
              },
              builder: (context, state) {
                return SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (isSignUpMode) {
                        BlocProvider.of<AuthenticationBloc>(context).add(
                          SignUpUser(
                            emailController.text.trim(),
                            passwordController.text.trim(),
                            isRecruiter,
                          ),
                        );
                      } else {
                        BlocProvider.of<AuthenticationBloc>(context).add(
                          SignInUser(
                            emailController.text.trim(),
                            passwordController.text.trim(),
                          ),
                        );
                      }
                    },
                    child: Text(
                      state is AuthenticationLoadingState
                          ? '.......'
                          : isSignUpMode
                              ? 'Sign Up'
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
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Switch to '),
                Switch(
                  value: isSignUpMode,
                  onChanged: (value) {
                    setState(() {
                      isSignUpMode = value;
                    });
                  },
                ),
                const Text('Sign Up'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
