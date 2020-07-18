import 'package:flutter/material.dart';

import '../utils/state.dart';
import 'order_client.dart';
import 'order_product.dart';

class Order {
  static Order fromJson(Map<String, dynamic> data, StateModel model) {
    final productsJson = data['products'] as List<dynamic>;
    final products = productsJson.map((e) => OrderProduct.fromJson(e, model))
        .toList();

    final OrderClient client = OrderClient.fromJson(data['client']);

    return new Order(
        promoCode: data['promo_code'], client: client, products: products);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'promo_code': this.promoCode,
      'client': this.client.toJson(),
      'products': this.products.map((e) => e.toJson()).toList(),
    };

    return data;
  }

  String promoCode;
  OrderClient client;
  List<OrderProduct> products;

  Order({
    @required this.client,
    @required this.products,
    this.promoCode,
  });

  int get total =>
      products != null && products.length > 0
          ? products
          .map((e) => e.subTotal)
          .reduce((value, element) => value + element)
          : 0;

  int totalWithCode(Map<String, dynamic> data) {
    final type = num.parse(data['type']);
    final discount = num.parse(data['discount']);
    final total = this.total;

    if (type == 0) {
      return (total * ((100 - discount) / 100)).round();
    } else {
      return total - discount;
    }
  }
}
