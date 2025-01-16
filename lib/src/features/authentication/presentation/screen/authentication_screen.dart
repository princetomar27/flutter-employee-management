import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/colors/app_colors.dart';
import '../../../../core/constants/navigation_constants.dart';
import '../../../../core/injector/injection_container.dart';
import '../../../../presentation/paddings.dart';
import '../../../home/presentation/screen/home_screen.dart';
import '../cubit/authentication_cubit.dart';

class AuthenticationScreen extends StatefulWidget {
  const AuthenticationScreen({super.key});

  @override
  _AuthenticationScreenState createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: BlocProvider(
        create: (context) => AuthenticationCubit(
          repository: sl(),
        ),
        child: BlocBuilder<AuthenticationCubit, AuthenticationState>(
          builder: (context, state) {
            final cubit = context.read<AuthenticationCubit>();
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: cubit.loginFormKey,
                child: Column(
                  children: [
                    padding72,
                    padding72,
                    const Center(
                      child: Text(
                        "Login",
                      ),
                    ),
                    padding20,
                    TextFormField(
                      decoration: const InputDecoration(
                        hintText: 'Email or Phone',
                        hintStyle: TextStyle(
                          color: AppColors.textPrimaryColor,
                        ),
                      ),
                      onChanged: cubit.updateUserName,
                    ),
                    padding16,
                    TextFormField(
                      obscureText: _obscureText,
                      decoration: InputDecoration(
                        hintText: 'Password',
                        hintStyle: const TextStyle(
                          color: AppColors.textPrimaryColor,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureText
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: AppColors.greyColor,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureText = !_obscureText;
                            });
                          },
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        return null;
                      },
                      onChanged: cubit.updatePassword,
                    ),
                    padding16,
                    ElevatedButton(
                      onPressed: () {
                        if (cubit.loginFormKey.currentState!.validate()) {
                          cubit.login(onLoginSuccess: () {
                            NavigationHelper.replaceWith(
                                context, const HomeScreen());
                          });
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.loginButtonColor,
                        minimumSize:
                            Size(MediaQuery.of(context).size.width * 0.8, 48),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: state is AuthenticationLoading
                          ? const Center(
                              child: CircularProgressIndicator(),
                            )
                          : const Text(
                              "Login",
                            ),
                    ),
                    const SizedBox(height: 24.0),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      alignment: Alignment.centerRight,
                      child: InkWell(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text("Forgot Password"),
                                content: SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      const Text("It'll be implemented later"),
                                      const SizedBox(height: 24.0),
                                      ElevatedButton(
                                        onPressed: () {
                                          NavigationHelper.goBack(context);
                                        },
                                        child: const Text("OKAY"),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        child: const Text(
                          "Forgot Password",
                          textAlign: TextAlign.end,
                          style: TextStyle(
                            color: AppColors.textSecondaryColor,
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
