import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:sbm_v18/core/helpers/user_local_data.dart';
import 'package:sbm_v18/core/network/api_urls.dart';
import 'package:sbm_v18/core/network/failure.dart';
import 'package:sbm_v18/features/meeting/data/model/meeting_information_model.dart';
import 'package:sbm_v18/features/meeting/data/model/voice_separation_model.dart';

class MeetingRemoteDataSource {
  // final token = ApiUrls.token;

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
      final token = await UserLocalData.getToken();
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
      final token = await UserLocalData.getToken();
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
      final token = await UserLocalData.getToken();
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
      final token = await UserLocalData.getToken();
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

  Future<Either<Failure, String>> askToJoin({required String roomId}) async {
    addLogger();
    try {
      final token = await UserLocalData.getToken();
      final response = await dio.post(
        ApiUrls.askToJoin,
        data: {'room_id': roomId},
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        final status = response.data['status'];
        return Right(status); // "request_to_Join" or "accepted"
      } else {
        return Left(
          Failure(message: response.data['message'] ?? 'Unknown error'),
        );
      }
    } catch (e) {
      return Left(Failure.handleError(e));
    }
  }

  Future<Either<Failure, String>> respondToCreatorInvitation({
    required int invitationId,
    required String action, // 'accept' or 'reject'
  }) async {
    addLogger();

    try {
      final token = await UserLocalData.getToken();
      final response = await dio.post(
        ApiUrls.respondToCreatorInvitation,
        data: {'invitation_id': invitationId, 'action': action},
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        final status = response.data['status'];
        final roomUrl = response.data['room_url'] ?? '';
        return Right(
          status == 'accepted' ? roomUrl : 'rejected',
        ); // You can customize this return value
      } else {
        return Left(
          Failure(message: response.data['message'] ?? 'Unknown error'),
        );
      }
    } catch (e) {
      return Left(Failure.handleError(e));
    }
  }

  Future<Either<Failure, String>> inviteUserByCreator({
    required int userId,
    required int meetingId,
  }) async {
    addLogger();
    try {
      final token = await UserLocalData.getToken();
      final response = await dio.post(
        ApiUrls.inviteByCreator,
        data: {'user_id': userId, 'meeting_id': meetingId},
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        final message = response.data['message'] ?? 'User invited';
        return Right(message);
      } else {
        return Left(
          Failure(message: response.data['message'] ?? 'Failed to invite user'),
        );
      }
    } catch (e) {
      return Left(Failure.handleError(e));
    }
  }

  Future<Either<Failure, String>> transcribeMeeting({
    required int meetingId,
  }) async {
    addLogger();
    try {
      final token = await UserLocalData.getToken();
      final response = await dio.post(
        ApiUrls.transcribeMeeting,
        data: {'meeting_id': meetingId},
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        final String transcriptionText = response.data['text'];
        return Right(transcriptionText);
      } else {
        return Left(
          Failure(message: response.data['message'] ?? 'Transcription failed'),
        );
      }
    } catch (e) {
      return Left(Failure.handleError(e));
    }
  }

  Future<Either<Failure, String>> summarizeMeeting({
    required String query,
    required String document,
  }) async {
    addLogger();
    try {
      final token = await UserLocalData.getToken();
      final response = await dio.post(
        ApiUrls.summarizeMeeting,
        data: {'query': query, 'document': document},
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200 && response.data['summary'] != null) {
        return Right(response.data['summary']);
      } else {
        return Left(
          Failure(message: response.data['message'] ?? 'Summarization failed'),
        );
      }
    } catch (e) {
      return Left(Failure.handleError(e));
    }
  }

  Future<Either<Failure, List<VoiceSeparationModel>>> voiceSeparation({
    required int meetingId,
  }) async {
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

      if (response.statusCode == 200 && response.data['transcript'] is List) {
        final transcript = response.data['transcript'] as List;
        final result =
            transcript
                .map((item) => VoiceSeparationModel.fromJson(item))
                .toList();
        return Right(result);
      } else {
        if (kDebugMode) {
          debugPrint('VoiceSeparation API error: ${response.data}');
        }
        return Left(
          Failure(message: response.data['message'] ?? 'Unknown error'),
        );
      }
    } catch (e) {
      return Left(Failure.handleError(e));
    }
  }

  Future<Either<Failure, String>> respondToInvitation({
    required int invitationId,
    required String action,
  }) async {
    addLogger(); // optional debug/logger

    try {
      final token = await UserLocalData.getToken();

      final response = await dio.post(
        ApiUrls.respondToInvitation,
        data: {'invitation_id': invitationId, 'action': action},
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        final roomUrl = response.data['room_url'];
        return Right(
          roomUrl,
        ); // you may choose to return `status` instead if needed
      } else {
        return Left(
          Failure(message: response.data['message'] ?? 'فشل الرد على الدعوة'),
        );
      }
    } catch (e) {
      return Left(Failure.handleError(e));
    }
  }
}
