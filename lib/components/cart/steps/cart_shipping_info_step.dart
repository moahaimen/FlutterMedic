import 'package:drugStore/models/order_client.dart';
import 'package:drugStore/models/order_management.dart';
import 'package:flutter/material.dart';

import '../ui/cart_client_information.dart';
import 'cart_step.dart';

class CartShippingInfoStep extends CartStep {
  CartShippingInfoStep(OrderManagement manager)
      : super(
            manager: manager,
            id: CartStepId.Client,
            title: 'cart_client_step',
            child: CartClientInformation(manager));

  @override
  bool finished() {
    final order = this.manager.order;
    final child = this.child as CartClientInformation;

    return order != null &&
        order.products != null &&
        order.products.length > 0 &&
        (order.promoCode == null ||
            (order.promoCode.code != null &&
                order.promoCode.code.length == 8 &&
                order.promoCode.valid)) &&
        child.form != null &&
        child.form.currentState != null &&
        child.form.currentState.validate();
  }

  @override
  void save() {
    final order = this.manager;
    final child = this.child as CartClientInformation;

    OrderClient.fromJson(child.data, this.manager).then((client) {
      child.form.currentState.save();
      order.setOrderClient(client);
      print('client: ${order.client.name}');
    });
  }

  @override
  IconData getState() {
    final order = this.manager.order;
    final client = order.client;

    if (client == null) {
      return Icons.chevron_right;
    } else if (client.completed) {
      return Icons.check_circle;
    } else {
      return Icons.edit;
    }
  }
}
