import 'dart:convert';
import 'package:sbm_v18/features/auth/data/model/user_information_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserLocalData {
  static const _key = 'user_info';
  static const _tokenKey = 'auth_token';

  static Future<void> saveUserInfo(UserInformationModel userInfo) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(userInfo.toJson());
    await prefs.setString(_key, jsonString);
    await prefs.setString(_tokenKey, userInfo.token);
  }

  static Future<UserInformationModel?> getUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_key);
    if (jsonString == null) return null;
    try {
      final jsonMap = jsonDecode(jsonString);
      return UserInformationModel.fromJson(jsonMap);
    } catch (e) {
      return null;
    }
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  static Future<void> clearUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
    await prefs.remove(_tokenKey);
  }
}
