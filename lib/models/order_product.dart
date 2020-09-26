import 'package:flutter/material.dart';

import '../utils/state.dart';
import 'product.dart';

class OrderProduct {
  static OrderProduct fromJson(Map<String, dynamic> data, StateModel model) {
    return new OrderProduct(
      product:
      model.products.data.firstWhere((e) => e.id == data['product_id']),
      quantity: data['quantity'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'product_id': this.product.id,
      'quantity': this.quantity,
    };

    return data;
  }

  int quantity;
  final Product product;

  OrderProduct({@required this.product, @required this.quantity});

  int get subTotal {
    if (this.quantity == null && this.product == null) {
      return 0;
    }
    return this.quantity * this.product.price;
  }
}
