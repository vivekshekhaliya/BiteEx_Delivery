class OrderDetailsModel {
  bool? success;
  OrderDetailsData? data;
  String? message;

  OrderDetailsModel({this.success, this.data, this.message});

  factory OrderDetailsModel.fromJson(Map<String, dynamic> json) {
    return OrderDetailsModel(
      success: json['success'],
      data: json['data'] != null ? OrderDetailsData.fromJson(json['data']) : null,
      message: json['message'],
    );
  }
}

class OrderDetailsData {
  int? orderId;
  String? orderNumber;
  String? status;
  String? date;
  Customer? customer;
  Pickup? pickup;
  Drop? drop;
  List<OrderItem>? items;
  String? deliveryInstructions;
  dynamic deliveryEarnings;
  String? paymentMethod;
  dynamic totalAmount;

  OrderDetailsData({
    this.orderId,
    this.orderNumber,
    this.status,
    this.date,
    this.customer,
    this.pickup,
    this.drop,
    this.items,
    this.deliveryInstructions,
    this.deliveryEarnings,
    this.paymentMethod,
    this.totalAmount,
  });

  factory OrderDetailsData.fromJson(Map<String, dynamic> json) {
    return OrderDetailsData(
      orderId: json['order_id'],
      orderNumber: json['order_number'],
      status: json['status'],
      date: json['date'],
      customer: json['customer'] != null ? Customer.fromJson(json['customer']) : null,
      pickup: json['pickup'] != null ? Pickup.fromJson(json['pickup']) : null,
      drop: json['drop'] != null ? Drop.fromJson(json['drop']) : null,
      items: json['items'] != null
          ? (json['items'] as List).map((i) => OrderItem.fromJson(i)).toList()
          : null,
      deliveryInstructions: json['delivery_instructions'],
      deliveryEarnings: json['delivery_earnings'],
      paymentMethod: json['payment_method'],
      totalAmount: json['total_amount'],
    );
  }
}

class Customer {
  String? name;
  String? mobile;
  String? image;

  Customer({this.name, this.mobile, this.image});

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      name: json['name']?.toString(),
      mobile: json['mobile']?.toString(),
      image: json['image']?.toString(),
    );
  }
}

class Pickup {
  String? name;
  String? location;
  String? mobile;

  Pickup({this.name, this.location, this.mobile});

  factory Pickup.fromJson(Map<String, dynamic> json) {
    return Pickup(
      name: json['name']?.toString(),
      location: json['location']?.toString(),
      mobile: json['mobile']?.toString(),
    );
  }
}

class Drop {
  String? address;
  dynamic latitude;
  dynamic longitude;

  Drop({this.address, this.latitude, this.longitude});

  factory Drop.fromJson(Map<String, dynamic> json) {
    return Drop(
      address: json['address']?.toString() ?? json['drop_location']?.toString(),
      latitude: json['latitude'] ?? json['drop_latitude'] ?? json['drop_lat'] ?? json['lat'],
      longitude: json['longitude'] ?? json['drop_longitude'] ?? json['drop_lng'] ?? json['lng'],
    );
  }
}

class OrderItem {
  String? productName;
  String? image;
  int? quantity;
  dynamic price;
  dynamic total;
  bool? addOnCheese;
  bool? addOnJain;
  bool? addOnSwn;

  OrderItem({
    this.productName,
    this.image,
    this.quantity,
    this.price,
    this.total,
    this.addOnCheese,
    this.addOnJain,
    this.addOnSwn,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      productName: json['product_name']?.toString(),
      image: json['image']?.toString(),
      quantity: json['quantity'],
      price: json['price'],
      total: json['total'],
      addOnCheese: json['add_on_cheese'],
      addOnJain: json['add_on_jain'],
      addOnSwn: json['add_on_swn'],
    );
  }
}
