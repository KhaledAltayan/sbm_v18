import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sbm_v18/core/network/failure.dart';
import 'package:sbm_v18/features/auth/data/data_source/auth_remote_data_source.dart';
import 'package:sbm_v18/features/auth/data/model/user_information_model.dart';
import 'package:sbm_v18/features/auth/presentation/manager/auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRemoteDataSource remote=AuthRemoteDataSource();

  AuthCubit() : super(const AuthState());

  Future<void> register({
  required String firstName,
  required String lastName,
  required String email,
  required String password,
  required String confirmPassword,
  required String gender,
  required String birthday,
  required String fcmToken,
  String? phoneNumber,
  String? address,
  String? imagePath, // <- still a String
}) async {
  emit(state.copyWith(isLoading: AuthIsLoading.registering));

  MultipartFile? imageFile;
  if (imagePath != null && imagePath.isNotEmpty) {
    imageFile = await MultipartFile.fromFile(imagePath); // ✅ convert to MultipartFile
  }

  final result = await remote.register(
    firstName: firstName,
    lastName: lastName,
    email: email,
    password: password,
    confirmPassword: confirmPassword,
    gender: gender,
    birthday: birthday,
    fcmToken: fcmToken,
    phoneNumber: phoneNumber,
    address: address,
    image: imageFile, // ✅ pass MultipartFile? now
  );
    result.fold(
      (Failure failure) {
        emit(state.copyWith(
          failure: failure,
          isLoading: AuthIsLoading.none,
          isFailure: AuthIsFailure.registrationFailed,
        ));
      },
      (UserInformationModel userInfo) {
        emit(state.copyWith(
          userInfo: userInfo,
          isLoading: AuthIsLoading.none,
          isSuccess: AuthIsSuccess.registered,
        ));
      },
    );
  }

  Future<void> login({
    required String email,
    required String password,
    required String fcmToken,
  }) async {
    emit(state.copyWith(isLoading: AuthIsLoading.loggingIn));

    final result = await remote.login(
      email: email,
      password: password,
      fcmToken: fcmToken,
    );

    result.fold(
      (Failure failure) {
        emit(state.copyWith(
          failure: failure,
          isLoading: AuthIsLoading.none,
          isFailure: AuthIsFailure.loginFailed,
        ));
      },
      (UserInformationModel userInfo) {
        emit(state.copyWith(
          userInfo: userInfo,
          isLoading: AuthIsLoading.none,
          isSuccess: AuthIsSuccess.loggedIn,
        ));
      },
    );
  }

  // void resetStatus() {
  //   emit(state.copyWith(
  //     isLoading: AuthIsLoading.none,
  //     isSuccess: AuthIsSuccess.none,
  //     isFailure: AuthIsFailure.none,
  //   ));
  // }
}
