import 'package:flutter/material.dart';

import 'product.dart';

class OrderProduct {
  static OrderProduct fromJson(Map<String, dynamic> data) {
    return new OrderProduct(
        product: Product.fromJson(data['product']), quantity: data['quantity']);
  }

  Product product;
  int quantity;

  OrderProduct({@required this.product, @required this.quantity});

  int get subTotal => this.quantity != null && this.product != null
      ? this.quantity * this.product.price
      : 0;
}
