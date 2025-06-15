import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:sbm_v18/core/network/api_urls.dart';

class ApiService {

  
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: ApiUrls.responseUser, // ضع رابط الـ API الخاص بك
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer ${ApiUrls.token}',
        // 'Authorization': 'Bearer your_token_here', // أضف التوكن إذا كنت تحتاج تسجيل دخول
      },
    ),
  );



   addLogger() {
    _dio.interceptors.add(
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

  Future<void> acceptInvitation(String invitationId) async {
    addLogger();
    try {
      final response = await _dio.post('invitations/$invitationId/accept');
      print('تم قبول الدعوة: ${response.data}');
    } catch (e) {
      print('فشل في قبول الدعوة: $e');
    }
  }

  Future<void> rejectInvitation(String invitationId) async {
    addLogger();
    try {
      final response = await _dio.post('invitations/$invitationId/reject');
      print('تم رفض الدعوة: ${response.data}');
    } catch (e) {
      print('فشل في رفض الدعوة: $e');
    }
  }
}
