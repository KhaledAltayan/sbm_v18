import 'package:sbm_v18/core/network/failure.dart';
import 'package:sbm_v18/features/auth/data/model/user_information_model.dart';

class AuthState {
  final UserInformationModel? userInfo;
  final Failure? failure;

  final AuthIsLoading isLoading;
  final AuthIsSuccess isSuccess;
  final AuthIsFailure isFailure;

  const AuthState({
    this.userInfo,
    this.failure,
    this.isLoading = AuthIsLoading.none,
    this.isSuccess = AuthIsSuccess.none,
    this.isFailure = AuthIsFailure.none,
  });

  AuthState copyWith({
    UserInformationModel? userInfo,
    Failure? failure,
    AuthIsLoading? isLoading,
    AuthIsSuccess? isSuccess,
    AuthIsFailure? isFailure,
  }) {
    return AuthState(
      userInfo: userInfo ?? this.userInfo,
      failure: failure,
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      isFailure: isFailure ?? this.isFailure,
    );
  }
}

enum AuthIsLoading {
  none,
  registering,
  loggingIn,
  loadingUser,
}

enum AuthIsSuccess {
  none,
  registered,
  loggedIn,
  fetchedUser,
}

enum AuthIsFailure {
  none,
  registrationFailed,
  loginFailed,
  fetchUserFailed,
}
