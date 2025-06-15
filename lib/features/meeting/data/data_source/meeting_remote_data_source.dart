import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:sbm_v18/core/network/api_urls.dart';
import 'package:sbm_v18/core/network/failure.dart';
import 'package:sbm_v18/features/meeting/data/model/meeting_information_model.dart';

class MeetingRemoteDataSource {
  final token = ApiUrls.token;

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

  Future<Either<Failure, List<MeetingInformationModel>>> getMeetings() async {
    addLogger();
    try {
      final response = await dio.get(
        // 'http://192.168.135.245:8000/api/meeting/get-meeting',
        ApiUrls.getMeetings,
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        final meetings = List<MeetingInformationModel>.from(
          data['meetings'].map((x) => MeetingInformationModel.fromJson(x)),
        );
        return Right(meetings);
      } else {
        return Left(Failure(message: response.data['message']));
      }
    } catch (e) {
      return Left(Failure.handleError(e));
    }
  }

  Future<Either<Failure, MeetingInformationModel>> createMeeting({
    required String title,
    required DateTime startTime,
    bool askToJoin = false,
  }) async {
    try {
      final response = await dio.post(
        ApiUrls.createMeeting,
        data: {
          "title": title,
          "start_time": startTime.toIso8601String(),
          "ask_to_join": askToJoin,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        return right(
          MeetingInformationModel.fromJson(response.data["meeting"]),
        );
      } else {
        return left(Failure(message: response.data['message']));
      }
    } catch (e) {
      return left(Failure.handleError(e));
    }
  }

  Future<Either<Failure, String>> uploadRecording({
    required int meetingId,
    required String filePath,
  }) async {
    addLogger();
    try {
      final formData = FormData.fromMap({
        'meeting_id': meetingId,
        'file': await MultipartFile.fromFile(filePath, filename: 'record.wav'),
      });

      final response = await dio.post(
        ApiUrls.recordMeeting,
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        return right(response.data['data']['recording_url']);
      } else {
        return left(Failure(message: response.data['message']));
      }
    } catch (e) {
      return left(Failure.handleError(e));
    }
  }

  Future<Either<Failure, List<MeetingInformationModel>>> searchMeetingsByDate(
    String date,
  ) async {
    addLogger();
    try {
      final response = await dio.get(
        '${ApiUrls.searchMeetings}?date=$date',
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        final meetings = List<MeetingInformationModel>.from(
          data['meetings'].map((x) => MeetingInformationModel.fromJson(x)),
        );
        return Right(meetings);
      } else {
        return Left(Failure(message: response.data['message']));
      }
    } catch (e) {
      return Left(Failure.handleError(e));
    }
  }
}
