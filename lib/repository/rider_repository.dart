import 'package:dio/dio.dart';

import '../data/network/api_client.dart';
import '../res/constants/app_url.dart';

class RiderRepository {
  /// GET RIDER DASHBOARD REQUEST
  static Future<Map<String, dynamic>> getRiderDashboard() async {
    try {
      Response response = await ApiClient.dio.get(AppUrl.riderDashboardUrl);
      return response.data;
    } on DioException catch (e) {
      throw ApiClient.handleError(e);
    }
  }

  /// GET AVAILABLE ORDERS REQUEST
  static Future<Map<String, dynamic>> getAvailableOrders() async {
    try {
      Response response = await ApiClient.dio.get(AppUrl.riderAvailableOrdersUrl);
      return response.data;
    } on DioException catch (e) {
      throw ApiClient.handleError(e);
    }
  }

  /// GET ORDER DETAILS REQUEST
  static Future<Map<String, dynamic>> getOrderDetails(int id) async {
    try {
      Response response = await ApiClient.dio.get(AppUrl.riderOrderDetailsUrl(id));
      return response.data;
    } on DioException catch (e) {
      throw ApiClient.handleError(e);
    }
  }

  /// GET RIDER HISTORY REQUEST
  static Future<Map<String, dynamic>> getRiderHistory() async {
    try {
      Response response = await ApiClient.dio.get(AppUrl.riderHistoryUrl);
      return response.data;
    } on DioException catch (e) {
      throw ApiClient.handleError(e);
    }
  }

  /// ACCEPT ORDER REQUEST
  static Future<Map<String, dynamic>> acceptOrder(int id) async {
    try {
      Response response = await ApiClient.dio.post(AppUrl.acceptOrderUrl(id));
      return response.data;
    } on DioException catch (e) {
      throw ApiClient.handleError(e);
    }
  }

  /// REJECT ORDER REQUEST
  static Future<Map<String, dynamic>> rejectOrder(int id) async {
    try {
      Response response = await ApiClient.dio.post(AppUrl.rejectOrderUrl(id));
      return response.data;
    } on DioException catch (e) {
      throw ApiClient.handleError(e);
    }
  }

  /// START DELIVERY REQUEST
  static Future<Map<String, dynamic>> startDelivery(int id) async {
    try {
      Response response = await ApiClient.dio.post(AppUrl.startDeliveryUrl(id));
      return response.data;
    } on DioException catch (e) {
      throw ApiClient.handleError(e);
    }
  }

  /// COMPLETE DELIVERY REQUEST
  static Future<Map<String, dynamic>> completeDelivery(int id, {required String otp}) async {
    try {
      Response response = await ApiClient.dio.post(
        AppUrl.completeDeliveryUrl(id),
        data: {
          "otp": otp,
        },
      );
      return response.data;
    } on DioException catch (e) {
      throw ApiClient.handleError(e);
    }
  }

  /// UPDATE RIDER LOCATION REQUEST
  static Future<Map<String, dynamic>> updateLocation({
    required double latitude,
    required double longitude,
    int? orderId,
  }) async {
    try {
      Response response = await ApiClient.dio.post(
        AppUrl.updateLocationUrl,
        data: {
          "latitude": latitude,
          "longitude": longitude,
          "order_id": orderId,
        },
      );
      return response.data;
    } on DioException catch (e) {
      throw ApiClient.handleError(e);
    }
  }

  /// UPDATE RIDER ONLINE/OFFLINE STATUS REQUEST
  static Future<Map<String, dynamic>> updateStatus(String status) async {
    try {
      Response response = await ApiClient.dio.post(
        AppUrl.updateStatusUrl,
        data: {
          "status": status,
        },
      );
      return response.data;
    } on DioException catch (e) {
      throw ApiClient.handleError(e);
    }
  }
}
