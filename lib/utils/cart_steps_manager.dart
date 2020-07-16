import 'package:drugStore/components/cart_client_information.dart';
import 'package:drugStore/components/cart_promo_code.dart';
import 'package:drugStore/models/order_client.dart';
import 'package:drugStore/utils/state.dart';
import 'package:flutter/material.dart';

enum CartStepId { Products, Client, PromoCode }

abstract class CartStep {
  ///
  /// Unique number for each step
  ///
  final CartStepId id;

  ///
  /// State
  ///
  StepState state;

  ///
  /// Step instance
  ///
  final Step step;

  ///
  /// Save the step data into the source
  ///
  void save(StateModel state);

  ///
  /// Check if the step is finished and We can move to the next
  ///
  bool finished(StateModel state);

  CartStep(this.id, this.step, {this.state = StepState.indexed});
}

class CartProductsStep extends CartStep {
  CartProductsStep({@required Step step}) : super(CartStepId.Products, step);

  @override
  bool finished(StateModel state) {
    final order = state.order;
    return order != null && order.products != null && order.products.length > 0;
  }

  @override
  void save(StateModel state) {
    print('items: ${state.order.products.length}');
  }
}

class CartClientStep extends CartStep {
  CartClientStep({@required Step step}) : super(CartStepId.Client, step);

  @override
  bool finished(StateModel state) {
    final order = state.order;
    final client = this.step.content as CartClientInformation;
    return order != null &&
        order.products != null &&
        order.products.length > 0 &&
        client.form.currentState.validate();
  }

  @override
  void save(StateModel state) {
    final client = this.step.content as CartClientInformation;
    client.form.currentState.save();

    final clientData = OrderClient.fromJson(client.data);
    state.setOrderClient(clientData);
    print('client: ${state.order.client.name}');
  }
}

class CartPromoCodeStep extends CartStep {
  CartPromoCodeStep({@required Step step}) : super(CartStepId.PromoCode, step);

  @override
  bool finished(StateModel state) {
    final order = state.order;
    final widget = this.step.content as CartPromoCode;
    return order != null &&
        order.products != null &&
        order.products.length > 0 &&
        order.client != null &&
        widget.data['code'].length == 8 &&
        widget.data['active'] == true;
  }

  @override
  void save(StateModel state) {
    final promoCode = this.step.content as CartPromoCode;

    promoCode.form.currentState.save();
    state.setOrderPromoCode(promoCode.data['code']);
    print('Promocode: ${state.order.promoCode}');
  }
}

class CartStepsManager {
  final List<CartStep> steps;

  CartStepsManager({@required this.steps});
}
