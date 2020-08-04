import 'package:drugStore/models/order_client.dart';
import 'package:drugStore/utils/state.dart';
import 'package:flutter/material.dart';

import '../ui/cart_client_information.dart';
import 'cart_step.dart';

class CartShippingInfoStep extends CartStep {
  CartShippingInfoStep()
      : super(
            id: CartStepId.Client,
            title: 'cart_client_step',
            child: CartClientInformation());

  @override
  bool finished(StateModel state) {
    final order = state.order;
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
  void save(StateModel state) {
    final child = this.child as CartClientInformation;

    child.form.currentState.save();

    final clientData = OrderClient.fromJson(child.data, state);
    state.setOrderClientFromInstance(clientData);
    print('client: ${state.order.client.name}');
  }

  @override
  IconData getState(StateModel state) {
    final client = state.order.client;

    if (client == null) {
      return Icons.chevron_right;
    } else if (client.completed) {
      return Icons.check_circle;
    } else {
      return Icons.edit;
    }
  }
}
