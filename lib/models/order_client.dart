import 'package:drugStore/models/order_management.dart';
import 'package:drugStore/models/province.dart';
import 'package:flutter/material.dart';

class OrderClient {
  static OrderClient get empty {
    return OrderClient(name: null, phone: null, province: null, address: null);
  }

  static Future<OrderClient> fromJson(
      Map<String, dynamic> data, OrderManagement manager) async {
    return new OrderClient(
        name: data['name'],
        phone: data['phone'],
        province: manager.getClientProvince(data['province']),
        address: data['address'],
        notes: data['notes'],
        userId: data['user_id']);
  }

  Map<String, dynamic> toJson(bool isPost) {
    final Map<String, dynamic> data = {
      'name': this.name,
      'phone': this.phone,
      'province': this.province == null || this.province.id == null
          ? null
          : isPost ? this.province.enName : this.province.id,
      'address': this.address,
      'notes': this.notes,
      'userId': this.userId,
    };

    return data;
  }

  String name;
  String phone;
  Province province;
  String address;
  String notes;
  String userId;

  OrderClient({
    @required this.name,
    @required this.phone,
    @required this.province,
    @required this.address,
    this.notes,
    this.userId,
  });

  bool get completed {
    return this.name != null &&
        this.address != null &&
        this.province != null &&
        this.phone != null;
  }
}
