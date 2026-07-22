class RiderHistoryModel {
  bool? success;
  List<HistoryOrder>? data;
  String? message;

  RiderHistoryModel({this.success, this.data, this.message});

  RiderHistoryModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <HistoryOrder>[];
      json['data'].forEach((v) {
        data!.add(HistoryOrder.fromJson(v));
      });
    }
    message = json['message'];
  }
}

class HistoryOrder {
  int? orderId;
  String? orderNumber;
  String? status;
  String? pickupName;
  String? pickupLocation;
  String? dropLocation;
  String? date;
  dynamic deliveryEarnings;
  List<String>? productImages;

  HistoryOrder({
    this.orderId,
    this.orderNumber,
    this.status,
    this.pickupName,
    this.pickupLocation,
    this.dropLocation,
    this.date,
    this.deliveryEarnings,
    this.productImages,
  });

  factory HistoryOrder.fromJson(Map<String, dynamic> json) {
    return HistoryOrder(
      orderId: json['order_id'] ?? json['id'],
      orderNumber: json['order_number']?.toString() ?? json['order_id']?.toString() ?? json['id']?.toString(),
      status: json['status']?.toString(),
      pickupName: json['pickup_name']?.toString() ?? json['pickup_address']?.toString() ?? json['restaurant_name']?.toString(),
      pickupLocation: json['pickup_location']?.toString(),
      dropLocation: json['drop_location']?.toString() ?? json['drop_address']?.toString() ?? json['destination_name']?.toString(),
      date: json['date']?.toString() ?? json['created_at']?.toString(),
      deliveryEarnings: json['delivery_earnings'] ?? json['amount'] ?? json['total_amount'] ?? json['delivery_charge'] ?? 0,
      productImages: json['product_images'] != null
          ? List<String>.from(json['product_images'])
          : json['images'] != null
              ? List<String>.from(json['images'])
              : null,
    );
  }
}
