import 'package:sbm_v18/core/network/failure.dart';
import 'package:sbm_v18/features/auth/data/model/user_information_model.dart';

class AuthState {
  final UserInformationModel? userInfo;
  final UserInformationModel? searchedUser;
  final Failure? failure;

  final AuthIsLoading isLoading;
  final AuthIsSuccess isSuccess;
  final AuthIsFailure isFailure;

  const AuthState({
    this.userInfo,
    this.searchedUser,
    this.failure,
    this.isLoading = AuthIsLoading.none,
    this.isSuccess = AuthIsSuccess.none,
    this.isFailure = AuthIsFailure.none,
  });

  AuthState copyWith({
    UserInformationModel? userInfo,
    UserInformationModel? searchedUser,
    Failure? failure,
    AuthIsLoading? isLoading,
    AuthIsSuccess? isSuccess,
    AuthIsFailure? isFailure,
  }) {
    return AuthState(
      userInfo: userInfo ,
      searchedUser:searchedUser ,
      failure: failure,
      isLoading: isLoading ?? AuthIsLoading.none,
      isSuccess: isSuccess ?? AuthIsSuccess.none,
      isFailure: isFailure ?? AuthIsFailure.none,
    );
  }
}

enum AuthIsLoading { none, registering, loggingIn, loggingOut, searchingUser }
enum AuthIsSuccess { registered, loggedIn, loggedOut, searchSuccess ,none}
enum AuthIsFailure { registrationFailed, loginFailed, logoutFailed, searchFailed , none}
