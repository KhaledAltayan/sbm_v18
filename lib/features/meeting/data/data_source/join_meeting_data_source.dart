import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:sbm_v18/core/helpers/user_local_data.dart';
import 'package:sbm_v18/core/network/api_urls.dart';
import 'package:sbm_v18/core/network/failure.dart';

class MeetingRemoteDataSource1 {
  final Dio dio = Dio();

  MeetingRemoteDataSource1() {
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

  Future<Either<Failure, String>> requestToJoin({
    required String roomId,
  }) async {
    try {
      final token = await UserLocalData.getToken();

      if (token == null) {
        return Left(Failure(message: "Unauthorized"));
      }

      final response = await dio.post(
        ApiUrls.askToJoin,
        data: {"room_id": roomId},
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            "Accept": "application/json",
          },
        ),
      );

      if (response.statusCode == 200 &&
          response.data['status'] == 'request_to_Join') {
        return Right("Request sent successfully");
      } else {
        return Left(
          Failure(message: "Unexpected response: ${response.data['status']}"),
        );
      }
    } on DioException catch (e) {
      final message = e.response?.data['message'] ?? e.message;
      return Left(Failure(message: message));
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }
}
