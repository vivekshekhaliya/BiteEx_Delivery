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
  double? latitude;
  double? longitude;

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
    this.latitude,
    this.longitude,
  });

  factory AvailableOrder.fromJson(Map<String, dynamic> json) {
    double? lat;
    double? lng;

    // Try parsing latitude and longitude from JSON keys
    final rawLat = json['latitude'] ?? json['drop_latitude'] ?? json['drop_lat'] ?? json['lat'];
    final rawLng = json['longitude'] ?? json['drop_longitude'] ?? json['drop_lng'] ?? json['lng'];

    if (rawLat != null) {
      lat = double.tryParse(rawLat.toString());
    }
    if (rawLng != null) {
      lng = double.tryParse(rawLng.toString());
    }

    // Try parsing coordinates from dropLocation string if it is formatted as "lat,lng"
    final dropLoc = json['drop_location']?.toString();
    if ((lat == null || lng == null) && dropLoc != null) {
      final parts = dropLoc.split(',');
      if (parts.length == 2) {
        final parsedLat = double.tryParse(parts[0].trim());
        final parsedLng = double.tryParse(parts[1].trim());
        if (parsedLat != null && parsedLng != null) {
          lat = parsedLat;
          lng = parsedLng;
        }
      }
    }

    return AvailableOrder(
      orderId: json['order_id'],
      orderNumber: json['order_number'],
      pickupName: json['pickup_name'],
      pickupLocation: json['pickup_location'],
      dropLocation: dropLoc,
      deliveryEarnings: json['delivery_earnings'],
      date: json['date'],
      status: json['status'],
      productImages: json['product_images'] != null
          ? List<String>.from(json['product_images'])
          : null,
      latitude: lat,
      longitude: lng,
    );
  }
}
