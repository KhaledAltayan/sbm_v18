import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sbm_v18/features/auth/presentation/manager/auth_cubit.dart';
import 'package:sbm_v18/features/auth/presentation/manager/auth_state.dart';



class RegisterPage extends StatefulWidget {
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _genderController = TextEditingController();
  final _birthdayController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _addressController = TextEditingController();
  final _fcmToken = "dummy_fcm_token"; // replace with your FCM token retrieval

  File? _pickedImage;

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _pickedImage = File(pickedFile.path);
      });
    }
  }

  void _submit() {
    if (_formKey.currentState?.validate() != true) return;

    final authCubit = context.read<AuthCubit>();

    authCubit.register(
      firstName: _firstNameController.text.trim(),
      lastName: _lastNameController.text.trim(),
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
      confirmPassword: _confirmPasswordController.text.trim(),
      gender: _genderController.text.trim(),
      birthday: _birthdayController.text.trim(),
      fcmToken: _fcmToken,
      phoneNumber: _phoneNumberController.text.trim().isEmpty
          ? null
          : _phoneNumberController.text.trim(),
      address:
          _addressController.text.trim().isEmpty ? null : _addressController.text.trim(),
      imagePath: _pickedImage?.path,
    );
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _genderController.dispose();
    _birthdayController.dispose();
    _phoneNumberController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state.isSuccess == AuthIsSuccess.registered) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Registration successful!')),
            );
          } else if (state.isFailure == AuthIsFailure.registrationFailed) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.failure?.message ?? 'Registration failed')),
            );
          }
        },
        builder: (context, state) {
          if (state.isLoading == AuthIsLoading.registering) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  GestureDetector(
                    onTap: _pickImage,
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: _pickedImage != null
                          ? FileImage(_pickedImage!)
                          : null,
                      child: _pickedImage == null
                          ? const Icon(Icons.add_a_photo, size: 40)
                          : null,
                    ),
                  ),
                  const SizedBox(height: 16),

                  TextFormField(
                    controller: _firstNameController,
                    decoration: const InputDecoration(labelText: 'First Name'),
                    validator: (v) => v!.isEmpty ? 'Enter first name' : null,
                  ),
                  TextFormField(
                    controller: _lastNameController,
                    decoration: const InputDecoration(labelText: 'Last Name'),
                    validator: (v) => v!.isEmpty ? 'Enter last name' : null,
                  ),
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(labelText: 'Email'),
                    keyboardType: TextInputType.emailAddress,
                    validator: (v) =>
                        v!.contains('@') ? null : 'Enter a valid email',
                  ),
                  TextFormField(
                    controller: _passwordController,
                    decoration: const InputDecoration(labelText: 'Password'),
                    obscureText: true,
                    validator: (v) => v!.length < 6
                        ? 'Password must be at least 6 characters'
                        : null,
                  ),
                  TextFormField(
                    controller: _confirmPasswordController,
                    decoration:
                        const InputDecoration(labelText: 'Confirm Password'),
                    obscureText: true,
                    validator: (v) => v != _passwordController.text
                        ? 'Passwords do not match'
                        : null,
                  ),
                  TextFormField(
                    controller: _genderController,
                    decoration: const InputDecoration(labelText: 'Gender'),
                    validator: (v) => v!.isEmpty ? 'Enter gender' : null,
                  ),
                  TextFormField(
                    controller: _birthdayController,
                    decoration: const InputDecoration(labelText: 'Birthday (YYYY-MM-DD)'),
                    validator: (v) => v!.isEmpty ? 'Enter birthday' : null,
                  ),
                  TextFormField(
                    controller: _phoneNumberController,
                    decoration: const InputDecoration(labelText: 'Phone Number (optional)'),
                    keyboardType: TextInputType.phone,
                  ),
                  TextFormField(
                    controller: _addressController,
                    decoration: const InputDecoration(labelText: 'Address (optional)'),
                  ),

                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _submit,
                    child: const Text('Register'),
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
