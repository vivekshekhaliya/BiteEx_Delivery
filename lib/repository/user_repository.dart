import 'package:dio/dio.dart';

import '../data/network/api_client.dart';
import '../res/constants/app_url.dart';

class UserRepository {
  /// GET USER REQUEST
  static Future<Map<String, dynamic>> getUser() async {
    try {
      Response response = await ApiClient.dio.get(AppUrl.getUserUrl);

      return response.data;
    } on DioException catch (e) {
      throw ApiClient.handleError(e);
    }
  }

  /// EDIT PROFILE REQUEST
  static Future<Map<String, dynamic>> editProfile({
    String? imagePath,
    String? name,
  }) async {
    try {
      final Map<String, dynamic> map = {};

      if (imagePath != null && imagePath.isNotEmpty) {
        map["image"] = await MultipartFile.fromFile(
          imagePath,
          filename: imagePath.split('/').last,
        );
      }

      if (name != null && name.isNotEmpty) {
        map["name"] = name;
      }

      FormData formData = FormData.fromMap(map);

      Response response = await ApiClient.dio.post(
        AppUrl.editProfileUrl,
        data: formData,
        options: Options(contentType: "multipart/form-data"),
      );

      return response.data;
    } on DioException catch (e) {
      throw ApiClient.handleError(e);
    }
  }

  /// DELETE PROFILE REQUEST
  static Future<Map<String, dynamic>> deleteProfile() async {
    try {
      Response response = await ApiClient.dio.get(AppUrl.deleteProfileUrl);

      return response.data;
    } on DioException catch (e) {
      throw ApiClient.handleError(e);
    }
  }
}
