import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:sbm_v18/core/helpers/user_local_data.dart';
import 'package:sbm_v18/core/network/api_urls.dart';
import 'package:sbm_v18/core/network/failure.dart';
import 'package:sbm_v18/features/meeting/data/model/voice_separation_model.dart';

class VoiceSeparationRemoteDataSource {
  final Dio dio = Dio();

  addLogger() {
    dio.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: true,
        maxWidth: 90,
        enabled: kDebugMode,
        filter: (options, args) {
          // don't print requests with uris containing '/posts'
          if (options.path.contains('/posts')) {
            return false;
          }
          // don't print responses with unit8 list data
          return !args.isResponse || !args.hasUint8ListData;
        },
      ),
    );
  }

  Future<Either<Failure, List<VoiceSeparationModel>>> voiceSeparation(
    String meetingId,
  ) async {
    addLogger();
    try {
      final token = await UserLocalData.getToken();
      final response = await dio.post(
        ApiUrls.voiceSeparation,
        data: {'meeting_id': meetingId},
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        final transcript = response.data['transcript'] as List;
        final result =
            transcript
                .map((item) => VoiceSeparationModel.fromJson(item))
                .toList();
        return Right(result);
      } else {
        return Left(
          Failure(message: response.data['message'] ?? 'Unknown error'),
        );
      }
    } catch (e) {
      return Left(Failure.handleError(e));
    }
  }
}
