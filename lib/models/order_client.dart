import 'package:flutter/material.dart';

class OrderClient {
  static OrderClient get empty {
    return OrderClient(
        name: null, email: null, phone: null, province: null, address: null);
  }

  static OrderClient fromJson(Map<String, dynamic> data) {
    return new OrderClient(
        name: data['name'],
        email: data['email'],
        phone: data['phone'],
        province: data['province'],
        address: data['address'],
        notes: data['note'],
        userId: data['user_id']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'name': this.name,
      'email': this.email,
      'phone': this.phone,
      'province': this.province,
      'address': this.address,
      'note': this.notes,
      'userId': this.userId,
    };

    return data;
  }

  String name;
  String email;
  String phone;
  String province;
  String address;
  String notes;
  String userId;

  OrderClient({
    @required this.name,
    @required this.email,
    @required this.phone,
    @required this.province,
    @required this.address,
    this.notes,
    this.userId,
  });
}
