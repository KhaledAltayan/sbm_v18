import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sbm_v18/core/helpers/user_local_data.dart';
import 'package:sbm_v18/core/style/app_color.dart';
import 'package:sbm_v18/features/auth/presentation/manager/auth_cubit.dart';
import 'package:sbm_v18/features/auth/presentation/manager/auth_state.dart';
import 'package:sbm_v18/features/auth/presentation/pages/register_page.dart';
import 'package:sbm_v18/features/home/navigation_page.dart';
import 'package:sbm_v18/features/profile/profile_page.dart';
import 'package:firebase_messaging/firebase_messaging.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  String? _fcmToken;

  @override
  void initState() {
    super.initState();
    _initializeFcmToken();
  }

  Future<void> _initializeFcmToken() async {
    try {
      final fcm = FirebaseMessaging.instance;

      // Request permission if on iOS (optional)
      await fcm.requestPermission();

      final token = await fcm.getToken();
      if (token != null) {
        setState(() {
          _fcmToken = token;
        });
      }
      print('FCM Token on login: $_fcmToken');
    } catch (e) {
      debugPrint('Error fetching FCM token: $e');
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      if (_fcmToken == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('FCM token is not ready yet, please wait'),
          ),
        );
        return;
      }

      final authCubit = context.read<AuthCubit>();

      authCubit.login(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        fcmToken: _fcmToken!,
      );
    }
  }

  void _goToSignUp() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context2) =>  BlocProvider.value(
        value: BlocProvider.of<AuthCubit>(context),
        child: RegisterPage())),
    );
  }

  @override
  Widget build(BuildContext context) {
    final blueColor = Colors.blue.shade700;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Login"),
        backgroundColor: blueColor,
        elevation: 0,
        centerTitle: true,
      ),
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) async {
          if (state.isSuccess == AuthIsSuccess.loggedIn) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Login successful')),
            );

            if (state.userInfo != null) {
              await UserLocalData.saveUserInfo(state.userInfo!);
            }

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context2) => BlocProvider.value(
                  value: BlocProvider.of<AuthCubit>(context),
                  child: NavigationPage(),
                ),
              ),
            );
          }

          if (state.isFailure == AuthIsFailure.loginFailed) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.failure?.message ?? "Login failed")),
            );
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: SingleChildScrollView(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 20),
                  Icon(Icons.lock_outline, color: blueColor, size: 72),
                  const SizedBox(height: 16),
                  Text(
                    'Welcome Back',
                    style: TextStyle(
                      color: blueColor,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Please login to your account',
                    style: TextStyle(
                      color: blueColor.withOpacity(0.7),
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            prefixIcon: const Icon(Icons.email),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: blueColor,
                                width: 2,
                              ),
                            ),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          validator: (val) => val == null || val.isEmpty
                              ? 'Please enter your email'
                              : null,
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: _passwordController,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            prefixIcon: const Icon(Icons.lock),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: blueColor,
                                width: 2,
                              ),
                            ),
                          ),
                          obscureText: true,
                          validator: (val) => val == null || val.isEmpty
                              ? 'Please enter your password'
                              : null,
                        ),
                        const SizedBox(height: 32),
                        state.isLoading == AuthIsLoading.loggingIn
                            ? CircularProgressIndicator(color: blueColor)
                            : SizedBox(
                                width: double.infinity,
                                height: 50,
                                child: ElevatedButton(
                                  onPressed: _submit,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: blueColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    elevation: 3,
                                    textStyle: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  child: Text(
                                    "Login",
                                    style: TextStyle(color: AppColor.white),
                                  ),
                                ),
                              ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account? "),
                      GestureDetector(
                        onTap: _goToSignUp,
                        child: Text(
                          'Sign Up',
                          style: TextStyle(
                            color: blueColor,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}