// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'dart:convert';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
  int? id;
  String? name;
  String? mobile;
  String? image;

  User({
    this.id,
    this.name,
    this.mobile,
    this.image,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> dataMap = (json['data'] != null && json['data'] is Map<String, dynamic>)
        ? json['data'] as Map<String, dynamic>
        : json;

    return User(
      id: dataMap["id"],
      name: dataMap["name"],
      mobile: dataMap["mobile"],
      image: dataMap["image"],
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "mobile": mobile,
    "image": image,
  };
}
