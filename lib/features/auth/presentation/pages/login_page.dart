import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sbm_v18/core/helpers/user_local_data.dart';
import 'package:sbm_v18/features/auth/presentation/manager/auth_cubit.dart';
import 'package:sbm_v18/features/auth/presentation/manager/auth_state.dart';
import 'package:sbm_v18/features/meeting/presentation/pages/meeting_page5.dart';
import 'package:sbm_v18/features/profile/profile_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _fcmTokenController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _fcmTokenController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      final authCubit = context.read<AuthCubit>();

      authCubit.login(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        fcmToken: _fcmTokenController.text.trim(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: BlocConsumer<AuthCubit, AuthState>(
        // listener: (context, state) {
        //   if (state.isSuccess == AuthIsSuccess.loggedIn) {
        //     ScaffoldMessenger.of(context).showSnackBar(
        //       const SnackBar(content: Text('Login successful')),
        //     );
        //     // Navigate to home or dashboard
        //   }

        //   if (state.isFailure == AuthIsFailure.loginFailed) {
        //     ScaffoldMessenger.of(context).showSnackBar(
        //       SnackBar(content: Text(state.failure?.message ?? "Login failed")),
        //     );
        //   }
        // },
        listener: (context, state) async {
          if (state.isSuccess == AuthIsSuccess.loggedIn) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('Login successful')));

            // ✅ Save user info in shared preferences
            if (state.userInfo != null) {
              await UserLocalData.saveUserInfo(state.userInfo!);
            }

            // ✅ Navigate to Home
              Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context2) => BlocProvider.value(
                value:BlocProvider.of<AuthCubit>(context), 
                child: ProfilePage())),
            );
          }

          if (state.isFailure == AuthIsFailure.loginFailed) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.failure?.message ?? "Login failed")),
            );
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(labelText: 'Email'),
                    keyboardType: TextInputType.emailAddress,
                    validator:
                        (val) =>
                            val == null || val.isEmpty ? 'Enter email' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _passwordController,
                    decoration: const InputDecoration(labelText: 'Password'),
                    obscureText: true,
                    validator:
                        (val) =>
                            val == null || val.isEmpty
                                ? 'Enter password'
                                : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _fcmTokenController,
                    decoration: const InputDecoration(labelText: 'FCM Token'),
                    validator:
                        (val) =>
                            val == null || val.isEmpty
                                ? 'Enter FCM token'
                                : null,
                  ),
                  const SizedBox(height: 24),
                  state.isLoading == AuthIsLoading.loggingIn
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                        onPressed: _submit,
                        child: const Text("Login"),
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
