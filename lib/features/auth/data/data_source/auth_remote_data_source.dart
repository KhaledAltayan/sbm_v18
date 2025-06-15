import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:sbm_v18/core/network/api_urls.dart';
import 'package:sbm_v18/core/network/failure.dart';
import 'package:sbm_v18/features/auth/data/model/user_information_model.dart';

class AuthRemoteDataSource {
final token = ApiUrls.token;//

  final Dio dio = Dio();

  AuthRemoteDataSource() {
    _addLogger();
  }

  void _addLogger() {
    dio.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        error: true,
        compact: true,
        maxWidth: 90,
        enabled: kDebugMode,
      ),
    );
  }

  Future<Either<Failure, UserInformationModel>> register({
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
    MultipartFile? image,
  }) async {
    try {
      final formData = FormData.fromMap({
        "first_name": firstName,
        "last_name": lastName,
        "email": email,
        "password": password,
        "password_confirmation": confirmPassword,
        "gender": gender,
        "birthday": birthday,
        "fcm_token": fcmToken,
        if (phoneNumber != null) "phone_number": phoneNumber,
        if (address != null) "address": address,
        if (image != null) "image": image,
      });

      final response = await dio.post(
        ApiUrls.register,
        data: formData,
        options: Options(headers: {'Accept': 'application/json'}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final userInfo = UserInformationModel.fromJson(response.data['data']);
        return right(userInfo);
      } else {
        return left(
          Failure(
            statusCode: response.statusCode,
            message: response.data['message'] ?? 'Registration failed.',
          ),
        );
      }
    } catch (e) {
      return left(Failure.handleError(e));
    }
  }

  Future<Either<Failure, UserInformationModel>> login({
    required String email,
    required String password,
    required String fcmToken,
  }) async {
    try {
      final response = await dio.post(
        ApiUrls.login,
        data: FormData.fromMap({
          "email": email,
          "password": password,
          "fcm_token": fcmToken,
        }),
        options: Options(headers: {'Accept': 'application/json'}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final userInfo = UserInformationModel.fromJson(response.data['data']);
        return right(userInfo);
      } else {
        return left(
          Failure(
            statusCode: response.statusCode,
            message: response.data['message'] ?? 'Login failed.',
          ),
        );
      }
    } catch (e) {
      return left(Failure.handleError(e));
    }
  }

  Future<Either<Failure, String>> logout({required String token}) async {
    try {
      final response = await dio.post(
        ApiUrls.logout,
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        return right(response.data['message'] ?? 'Logout successful.');
      } else {
        return left(
          Failure(
            statusCode: response.statusCode,
            message: response.data['message'] ?? 'Logout failed.',
          ),
        );
      }
    } catch (e) {
      return left(Failure.handleError(e));
    }
  }

  Future<Either<Failure, UserInformationModel>> searchUserByEmail({
    required String email,
    // required String token,
  }) async {
    _addLogger();
    try {
      final response = await dio.get(
        ApiUrls.searchUserByEmail,
        // "${ApiUrls.searchUserByEmail}?email=$email",
        queryParameters: {'email': email},
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        final user = UserInformationModel.fromJson(response.data['data']);
        return right(user);
      } else {
        return left(
          Failure(
            statusCode: response.statusCode,
            message: response.data['message'] ?? 'Search failed.',
          ),
        );
      }
    } catch (e) {
      return left(Failure.handleError(e));
    }
  }
}
