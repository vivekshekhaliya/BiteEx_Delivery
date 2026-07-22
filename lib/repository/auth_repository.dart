import 'package:dio/dio.dart';

import '../data/network/api_client.dart';
import '../res/constants/app_url.dart';

class AuthRepository {
  /// SIGN-IN REQUEST
  static Future<Map<String, dynamic>> signIn({
    required String number,
    String? fcmToken,
  }) async {
    try {
      Response response = await ApiClient.dio.post(
        AppUrl.signInUrl,
        data: FormData.fromMap({
          "mobile": number,
          if (fcmToken != null) "device_token": fcmToken,
        }),
      );

      return response.data;
    } on DioException catch (e) {
      throw ApiClient.handleError(e);
    }
  }

  /// VERIFY REQUEST
  static Future<Map<String, dynamic>> verification({
    required String number,
    required String otp,
  }) async {
    try {
      Response response = await ApiClient.dio.post(
        AppUrl.verifyUrl,
        data: FormData.fromMap({
          "mobile": number,
          "otp": otp,
        }),
      );

      return response.data;
    } on DioException catch (e) {
      throw ApiClient.handleError(e);
    }
  }
}
