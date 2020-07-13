import 'package:flutter/material.dart';

import 'order_client.dart';
import 'order_product.dart';

class Order {
  static Order fromJson(Map<String, dynamic> data) {
    final products = (data['products'] as List<dynamic>)
        .map((e) => OrderProduct.fromJson(e));

    final OrderClient client = OrderClient.fromJson(data['client']);

    return new Order(
        promoCode: data['promo_code'], client: client, products: products);
  }

  String promoCode;
  OrderClient client;
  List<OrderProduct> products;

  Order({
    @required this.client,
    @required this.products,
    this.promoCode,
  });
}
