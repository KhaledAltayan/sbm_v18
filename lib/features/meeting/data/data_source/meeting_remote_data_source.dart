import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:sbm_v18/core/network/api_urls.dart';
import 'package:sbm_v18/core/network/failure.dart';
import 'package:sbm_v18/features/meeting/data/model/meeting_model.dart';

class MeetingRemoteDataSource {


final token = ApiUrls.token;

  final Dio dio = Dio();

  addLogger() {
    dio.interceptors.add(PrettyDioLogger(
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
        }));
  }


   Future<Either<Failure, MeetingModel>> createMeet({
    required String name,
    required String description,
    required String location,
    required String priority,
    required String autoChangeStatus,
    required String startTime,
    required String deadlineTime,
    required DateTime startDate,
    required DateTime deadlineDate,
  }) async {
    addLogger();
    try {
      const String url = "http://10.0.2.2:8000/api/event/create-event";
      final headers = {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      };

      final data = FormData.fromMap({
        'name': name,
        'description': description,
        'priority': priority,
        'location': location,
        'auto_change_status': autoChangeStatus,
        'start_time': startTime,
        'deadline_time': deadlineTime,
        'start_date': startDate.toIso8601String(),
        'deadline_date': deadlineDate.toIso8601String(),
      });

      final response =
          await dio.post(url, data: data, options: Options(headers: headers));

      if (response.statusCode == 201) {
        final event = MeetingModel.fromJson(response.data['data']['event']);
        return right(event);
      } else {
        return left(Failure(
          statusCode: response.statusCode,
          message: response.data['message'] ?? "Failed to create event",
        ));
      }
    } catch (e) {
      return left(Failure.handleError(e));
    }
  }

  
}