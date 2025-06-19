import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sbm_v18/core/helpers/user_local_data.dart';
import 'package:sbm_v18/core/style/app_color.dart';
import 'package:sbm_v18/features/auth/presentation/manager/auth_cubit.dart';
import 'package:sbm_v18/features/auth/presentation/manager/auth_state.dart';
import 'package:sbm_v18/features/auth/presentation/pages/login_page.dart';
import 'package:sbm_v18/features/home/navigation_page.dart';
import 'package:sbm_v18/features/profile/profile_page.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

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
  final _phoneNumberController = TextEditingController();
  final _addressController = TextEditingController();

  String? _selectedGender;
  DateTime? _selectedBirthday;

  String? _fcmToken;

  File? _pickedImage;
  final ImagePicker _picker = ImagePicker();

  final Color _blueColor = Colors.blue.shade700;

  @override
  void initState() {
    super.initState();
    _getFCMToken();
  }

  Future<void> _getFCMToken() async {
    try {
      final fcm = FirebaseMessaging.instance;

      await fcm.requestPermission();

      final token = await fcm.getToken();
      setState(() {
        _fcmToken = token;
      });

      print('FCM Token: $_fcmToken'); // debug
    } catch (e) {
      print('Error fetching FCM token: $e');
    }
  }

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() {
        _pickedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _pickBirthday() async {
    final now = DateTime.now();
    final initialDate =
        _selectedBirthday ?? DateTime(now.year - 20, now.month, now.day);

    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1900),
      lastDate: now,
    );

    if (picked != null) {
      setState(() {
        _selectedBirthday = picked;
      });
    }
  }

  String? _validateBirthday() {
    if (_selectedBirthday == null) {
      return 'Please select your birthday';
    }
    return null;
  }

  void _submit() {
    if (_formKey.currentState?.validate() != true) return;

    if (_fcmToken == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('FCM token not available yet, please wait'),
        ),
      );
      return;
    }

    final authCubit = context.read<AuthCubit>();

    authCubit.register(
      firstName: _firstNameController.text.trim(),
      lastName: _lastNameController.text.trim(),
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
      confirmPassword: _confirmPasswordController.text.trim(),
      gender: _selectedGender ?? '',
      birthday:
          _selectedBirthday != null
              ? _selectedBirthday!.toIso8601String().split('T')[0]
              : '',
      fcmToken: _fcmToken!,
      phoneNumber:
          _phoneNumberController.text.trim().isEmpty
              ? null
              : _phoneNumberController.text.trim(),
      address:
          _addressController.text.trim().isEmpty
              ? null
              : _addressController.text.trim(),
      imagePath: _pickedImage?.path,
    );
  }

  void _goToSignIn() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder:
            (context2) => BlocProvider.value(
              value: BlocProvider.of<AuthCubit>(context),
              child: LoginPage(),
            ),
      ),
    ); // Assuming SignIn is previous page
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _phoneNumberController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final inputDecoration = InputDecoration(
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: _blueColor.withOpacity(0.6)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: _blueColor, width: 2),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Register'),
        backgroundColor: _blueColor,
        centerTitle: true,
      ),
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) async {
          if (state.isSuccess == AuthIsSuccess.registered) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Registration successful!')),
            );

            if (state.userInfo != null) {
              await UserLocalData.saveUserInfo(state.userInfo!);
            }

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder:
                    (context2) => BlocProvider.value(
                      value: BlocProvider.of<AuthCubit>(context),
                      child: const NavigationPage(),
                    ),
              ),
            );
          } else if (state.isFailure == AuthIsFailure.registrationFailed) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.failure?.message ?? 'Registration failed'),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state.isLoading == AuthIsLoading.registering) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  GestureDetector(
                    onTap: _pickImage,
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: _blueColor.withOpacity(0.1),
                      backgroundImage:
                          _pickedImage != null
                              ? FileImage(_pickedImage!)
                              : null,
                      child:
                          _pickedImage == null
                              ? Icon(
                                Icons.add_a_photo,
                                color: _blueColor,
                                size: 40,
                              )
                              : null,
                    ),
                  ),
                  const SizedBox(height: 24),

                  TextFormField(
                    controller: _firstNameController,
                    decoration: inputDecoration.copyWith(
                      labelText: 'First Name',
                    ),
                    validator:
                        (v) =>
                            v == null || v.isEmpty ? 'Enter first name' : null,
                  ),
                  const SizedBox(height: 16),

                  TextFormField(
                    controller: _lastNameController,
                    decoration: inputDecoration.copyWith(
                      labelText: 'Last Name',
                    ),
                    validator:
                        (v) =>
                            v == null || v.isEmpty ? 'Enter last name' : null,
                  ),
                  const SizedBox(height: 16),

                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: inputDecoration.copyWith(labelText: 'Email'),
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'Enter email';
                      if (!v.contains('@')) return 'Enter a valid email';
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: inputDecoration.copyWith(labelText: 'Password'),
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'Enter password';
                      if (v.length < 6)
                        return 'Password must be at least 6 characters';
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  TextFormField(
                    controller: _confirmPasswordController,
                    obscureText: true,
                    decoration: inputDecoration.copyWith(
                      labelText: 'Confirm Password',
                    ),
                    validator: (v) {
                      if (v == null || v.isEmpty)
                        return 'Confirm your password';
                      if (v != _passwordController.text)
                        return 'Passwords do not match';
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Gender dropdown
                  DropdownButtonFormField<String>(
                    decoration: inputDecoration.copyWith(labelText: 'Gender'),
                    value: _selectedGender,
                    items: const [
                      DropdownMenuItem(value: 'male', child: Text('Male')),
                      DropdownMenuItem(value: 'female', child: Text('Female')),
                    ],
                    onChanged: (val) {
                      setState(() {
                        _selectedGender = val;
                      });
                    },
                    validator:
                        (v) =>
                            v == null || v.isEmpty
                                ? 'Please select gender'
                                : null,
                  ),
                  const SizedBox(height: 16),

                  // Birthday picker field
                  GestureDetector(
                    onTap: _pickBirthday,
                    child: AbsorbPointer(
                      child: TextFormField(
                        decoration: inputDecoration.copyWith(
                          labelText: 'Birthday',
                          hintText: 'YYYY-MM-DD',
                          suffixIcon: Icon(
                            Icons.calendar_today,
                            color: _blueColor,
                          ),
                        ),
                        controller: TextEditingController(
                          text:
                              _selectedBirthday != null
                                  ? "${_selectedBirthday!.year.toString().padLeft(4, '0')}-${_selectedBirthday!.month.toString().padLeft(2, '0')}-${_selectedBirthday!.day.toString().padLeft(2, '0')}"
                                  : '',
                        ),
                        validator: (v) => _validateBirthday(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  TextFormField(
                    controller: _phoneNumberController,
                    keyboardType: TextInputType.phone,
                    decoration: inputDecoration.copyWith(
                      labelText: 'Phone Number (optional)',
                    ),
                  ),
                  const SizedBox(height: 16),

                  TextFormField(
                    controller: _addressController,
                    decoration: inputDecoration.copyWith(
                      labelText: 'Address (optional)',
                    ),
                  ),
                  const SizedBox(height: 32),

                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _blueColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        textStyle: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      child: Text(
                        'Register',
                        style: TextStyle(color: AppColor.white),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Already have an account? '),
                      GestureDetector(
                        onTap: _goToSignIn,
                        child: Text(
                          'Sign In',
                          style: TextStyle(
                            color: _blueColor,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
