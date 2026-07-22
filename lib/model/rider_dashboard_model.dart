import 'available_order_model.dart';

class RiderDashboardModel {
  bool? success;
  RiderDashboardData? data;
  String? message;

  RiderDashboardModel({this.success, this.data, this.message});

  RiderDashboardModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null ? RiderDashboardData.fromJson(json['data']) : null;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['message'] = message;
    return data;
  }
}

class RiderDashboardData {
  String? riderName;
  dynamic totalEarnings;
  int? totalDeliveredOrders;
  AvailableOrder? currentDelivery;

  RiderDashboardData({
    this.riderName,
    this.totalEarnings,
    this.totalDeliveredOrders,
    this.currentDelivery,
  });

  RiderDashboardData.fromJson(Map<String, dynamic> json) {
    riderName = json['rider_name'];
    totalEarnings = json['total_earnings'];
    totalDeliveredOrders = json['total_delivered_orders'];
    currentDelivery = json['current_delivery'] != null ? AvailableOrder.fromJson(json['current_delivery']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['rider_name'] = riderName;
    data['total_earnings'] = totalEarnings;
    data['total_delivered_orders'] = totalDeliveredOrders;
    // data['current_delivery'] = currentDelivery; // Optionally add toJson for AvailableOrder if needed
    return data;
  }
}
