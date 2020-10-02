import 'package:drugStore/models/order_management.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../ui/cart_products_list.dart';
import 'cart_step.dart';

class CartProductsStep extends CartStep {
  CartProductsStep(OrderManagement manager)
      : super(
            manager: manager,
            id: CartStepId.Products,
            title: 'cart_products_step',
            child: CartProductsList(manager));

  @override
  bool finished() {
    assert(this.manager != null);
    assert(this.manager.order != null);
    assert(this.manager.order.products != null);

    final order = this.manager.order;
    final child = this.child as CartProductsList;

    return order.products.length > 0 &&
        (child.promoCode.isEmpty() || child.promoCode.isValid());
  }

  @override
  void save() {
    final order = this.manager.order;
    print('items: ${order.products.length}');
  }

  @override
  IconData getState() {
    final order = this.manager.order;
    final products = order.products;

    if (products == null || products.length == 0) {
      return Icons.chevron_right;
    } else if (products.length > 0) {
      return Icons.check_circle;
    } else {
      return Icons.edit;
    }
  }
}
