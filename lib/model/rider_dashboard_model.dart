import 'available_order_model.dart';

class RiderDashboardModel {
  bool? success;
  RiderDashboardData? data;
  String? message;

  RiderDashboardModel({this.success, this.data, this.message});

  RiderDashboardModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null
        ? RiderDashboardData.fromJson(json['data'])
        : null;
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
  bool? isSalaried;
  bool? isOnline;
  dynamic totalEarnings;
  int? totalDeliveredOrders;
  AvailableOrder? currentDelivery;

  RiderDashboardData({
    this.riderName,
    this.isSalaried,
    this.isOnline,
    this.totalEarnings,
    this.totalDeliveredOrders,
    this.currentDelivery,
  });

  RiderDashboardData.fromJson(Map<String, dynamic> json) {
    riderName = json['rider_name'];
    isSalaried = json['is_salaried'];
    isOnline = json['is_online'];
    totalEarnings = json['total_earnings'];
    totalDeliveredOrders = json['total_delivered_orders'];
    currentDelivery = json['current_delivery'] != null
        ? AvailableOrder.fromJson(json['current_delivery'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['rider_name'] = riderName;
    data['is_salaried'] = isSalaried;
    data['is_online'] = isOnline;
    data['total_earnings'] = totalEarnings;
    data['total_delivered_orders'] = totalDeliveredOrders;
    // data['current_delivery'] = currentDelivery; // Optionally add toJson for AvailableOrder if needed
    return data;
  }
}
