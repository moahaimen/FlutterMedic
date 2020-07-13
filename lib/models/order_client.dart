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
        note: data['note'],
        userId: data['user_id']);
  }

  String name;
  String email;
  String phone;
  String province;
  String address;
  String note;
  String userId;

  OrderClient({
    @required this.name,
    @required this.email,
    @required this.phone,
    @required this.province,
    @required this.address,
    this.note,
    this.userId,
  });
}
