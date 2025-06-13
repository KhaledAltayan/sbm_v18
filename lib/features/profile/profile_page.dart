import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sbm_v18/features/auth/presentation/manager/auth_cubit.dart';
import 'package:sbm_v18/features/auth/presentation/manager/auth_state.dart';
import 'package:sbm_v18/features/onboarding/onboarding_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state.isSuccess == AuthIsSuccess.loggedOut) {
          // Navigate to login or onboarding after logout
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => BlocProvider(
            create: (context) => AuthCubit(),
            child: OnboardingPage()),));
        }

        if (state.isFailure == AuthIsFailure.logoutFailed) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.failure?.message ?? 'Logout failed')),
          );
        }
      },
      builder: (context, state) {
        final user = state.userInfo;

        if (user == null) {
          return const Center(child: CircularProgressIndicator());
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('Profile'),
            actions: [
              IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () {
                  context.read<AuthCubit>().logout();
                },
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(user.image.image),
                ),
                const SizedBox(height: 16),
                Text(
                  "Full Name: ${user.user.firstName} ${user.user.lastName}",
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 8),
                Text(
                  "Email: ${user.user.email}",
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 8),
                Text(
                  "Gender: ${user.user.gender}",
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 8),
                Text(
                  "Birthday: ${user.user.birthday}",
                  style: const TextStyle(fontSize: 16),
                ),
                Text(
                  "Phone: ${user.user.phoneNumber}",
                  style: const TextStyle(fontSize: 16),
                ),
                Text(
                  "Address: ${user.user.address}",
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () {
                    context.read<AuthCubit>().logout();
                  },
                  icon: const Icon(Icons.logout),
                  label: const Text("Logout"),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
