import 'package:cat_to_do_list/core/app_router.dart';
import 'package:cat_to_do_list/core/utils/widgets/custom_app_bar.dart';
import 'package:cat_to_do_list/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:cat_to_do_list/features/auth/presentation/cubit/auth_state.dart';
import 'package:cat_to_do_list/features/auth/widgets/custom_text_field.dart';
import 'package:cat_to_do_list/features/auth/widgets/user_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../widgets/custom_button.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  String _email = '';
  String _password = '';
  String password2 = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthFailure) {
            UserAlertDialog.show(
              context: context,
              title: 'Registration Failed',
              content: state.message,
              buttonText: 'OK',
              onPressed: () {
                GoRouter.of(context).pop();
              },
            );
          } else if (state is AuthSuccess) {
            UserAlertDialog.show(
              context: context,
              title: 'Success',
              content: 'Registered successfully! \nLogin now!',
              buttonText: 'OK',
              onPressed: () {
                GoRouter.of(context).push(AppRouter.kLoginView);
              },
            );
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomAppBar(),
                const SizedBox(height: 150),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      const Text(
                        'Register !',
                        style: TextStyle(fontSize: 24, color: Colors.white),
                      ),
                      const SizedBox(height: 20),
                      CustomTextFormField(
                        onChanged: (data) {
                          _email = data;
                        },
                        hintText: 'Email',
                      ),
                      const SizedBox(height: 20),
                      CustomTextFormField(
                        onChanged: (data) {
                          _password = data;
                        },
                        hintText: 'Password',
                        obscureText: true,
                      ),
                      const SizedBox(height: 20),
                      CustomTextFormField(
                        onChanged: (data) {
                          password2 = data;
                        },
                        hintText: 'Confirm Password',
                        obscureText: true,
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: CustomButton(
                    text: state is AuthLoading ? 'LOADING...' : 'REGISTER',
                    textColor: Colors.white,
                    backgroundColor: Colors.green,
                    onPressed: () {
                      if (_email.isEmpty ||
                          _password.isEmpty ||
                          password2.isEmpty) {
                        UserAlertDialog.show(
                          context: context,
                          title: 'Error',
                          content: 'All fields are required.',
                          buttonText: 'OK',
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        );
                      }
                      if (_password != password2) {
                        UserAlertDialog.show(
                          context: context,
                          title: 'Password Mismatch',
                          content: 'Passwords do not match.',
                          buttonText: 'OK',
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        );
                      }
                      context.read<AuthCubit>().signUp(_email, _password);
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
