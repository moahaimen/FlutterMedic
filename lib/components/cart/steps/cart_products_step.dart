import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../utils/state.dart';
import '../ui/cart_products_list.dart';
import 'cart_step.dart';

class CartProductsStep extends CartStep {
  CartProductsStep()
      : super(
            id: CartStepId.Products,
            title: 'cart_products_step',
            child: CartProductsList());

  @override
  bool finished(StateModel state) {
    final order = state.order.order;
    final child = this.child as CartProductsList;

    print("Empty ${child.promoCode.isEmpty(state)}");
    print("Valid ${child.promoCode.isValid(state)}");

    return order != null &&
        order.products != null &&
        order.products.length > 0 &&
        (child.promoCode.isEmpty(state) || child.promoCode.isValid(state));
  }

  @override
  void save(StateModel state) {
    print('items: ${state.order.order.products.length}');
  }

  @override
  IconData getState(StateModel state) {
    final products = state.order.order.products;

    if (products == null || products.length == 0) {
      return Icons.chevron_right;
    } else if (products.length > 0) {
      return Icons.check_circle;
    } else {
      return Icons.edit;
    }
  }
}
