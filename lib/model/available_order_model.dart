class AvailableOrdersResponse {
  bool? success;
  List<AvailableOrder>? data;
  String? message;

  AvailableOrdersResponse({this.success, this.data, this.message});

  factory AvailableOrdersResponse.fromJson(Map<String, dynamic> json) {
    return AvailableOrdersResponse(
      success: json['success'],
      data: json['data'] != null
          ? (json['data'] as List).map((i) => AvailableOrder.fromJson(i)).toList()
          : null,
      message: json['message'],
    );
  }
}

class AvailableOrder {
  int? orderId;
  String? orderNumber;
  String? pickupName;
  String? pickupLocation;
  String? dropLocation;
  dynamic deliveryEarnings;
  String? date;
  String? status;
  List<String>? productImages;

  AvailableOrder({
    this.orderId,
    this.orderNumber,
    this.pickupName,
    this.pickupLocation,
    this.dropLocation,
    this.deliveryEarnings,
    this.date,
    this.status,
    this.productImages,
  });

  factory AvailableOrder.fromJson(Map<String, dynamic> json) {
    return AvailableOrder(
      orderId: json['order_id'],
      orderNumber: json['order_number'],
      pickupName: json['pickup_name'],
      pickupLocation: json['pickup_location'],
      dropLocation: json['drop_location'],
      deliveryEarnings: json['delivery_earnings'],
      date: json['date'],
      status: json['status'],
      productImages: json['product_images'] != null
          ? List<String>.from(json['product_images'])
          : null,
    );
  }
}
