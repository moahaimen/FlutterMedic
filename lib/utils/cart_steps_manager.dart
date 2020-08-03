import 'package:drugStore/components/cart_client_information.dart';
import 'package:drugStore/components/cart_products_list.dart';
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
    final products = step.content as CartProductsList;

    print("Empty ${products.promoCode.empty}");
    print("Valid ${products.promoCode.valid}");

    return order != null &&
        order.products != null &&
        order.products.length > 0 &&
        (products.promoCode.empty || products.promoCode.valid);
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
        (order.promoCode == null ||
            (order.promoCode.code != null &&
                order.promoCode.code.length == 8 &&
                order.promoCode.valid)) &&
        client.form != null &&
        client.form.currentState != null &&
        client.form.currentState.validate();
  }

  @override
  void save(StateModel state) {
    final client = this.step.content as CartClientInformation;
    client.form.currentState.save();

    final clientData = OrderClient.fromJson(client.data, state);
    state.setOrderClientFromInstance(clientData);
    print('client: ${state.order.client.name}');
  }
}

class CartStepsManager {
  final List<CartStep> steps;

  CartStepsManager({@required this.steps});
}
