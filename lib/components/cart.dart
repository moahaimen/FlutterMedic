import 'package:drugStore/components/cart_promo_code.dart';
import 'package:drugStore/partials/router.dart';
import 'package:drugStore/utils/state.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:toast/toast.dart';

import 'cart_client_information.dart';
import 'cart_products_list.dart';

class Cart extends StatefulWidget {
  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  static int currentStep = 0;

  StateModel _model;

  StepState _productsStepState = StepState.disabled;
  final GlobalKey<FormState> _productsFormKey = new GlobalKey<FormState>();

  StepState _clientStepState = StepState.disabled;
  final GlobalKey<FormState> _clientFormKey = new GlobalKey<FormState>();

  StepState _codeStepState = StepState.disabled;
  final GlobalKey<FormState> _promoCodeFormKey = new GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    _model = ScopedModel.of<StateModel>(context);
    _moveToProductsStep();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Step> steps = [
      Step(
          isActive: true,
          state: _productsStepState,
          title: Text(
            "Products",
            style: Theme
                .of(context)
                .textTheme
                .headline3
                .copyWith(color: Colors.black),
          ),
          content: CartProductsList(formKey: _productsFormKey)),
      Step(
          isActive: true,
          state: _clientStepState,
          title: Text("Client Information",
              style: Theme
                  .of(context)
                  .textTheme
                  .headline3
                  .copyWith(color: Colors.black)),
          content: CartClientInformation(
            formKey: _clientFormKey,
            model: this._model,
          )),
      Step(
          state: _codeStepState,
          isActive: true,
          title: Text("Promo Code",
              style: Theme
                  .of(context)
                  .textTheme
                  .headline3
                  .copyWith(color: Colors.black)),
          content: CartPromoCode(formKey: _promoCodeFormKey)),
    ];

    return ScopedModelDescendant<StateModel>(
        builder: (BuildContext context, Widget child, StateModel model) =>
            _cartContentBuilder(context, steps, model));
  }

  Widget _controlsBuilder(BuildContext context,
      {VoidCallback onStepContinue, VoidCallback onStepCancel}) {
    return Row(
      children: <Widget>[
        RaisedButton(
          onPressed: onStepContinue,
          child: Text('Continue'),
        ),
        SizedBox(
          width: 12,
        ),
        RaisedButton(
          onPressed: onStepCancel,
          child: Text('Cancel'),
          color: Colors.white,
          textColor: Colors.black,
        ),
      ],
    );
  }

  Widget _cartContentBuilder(BuildContext context, List<Step> steps,
      StateModel state) {
    return new Container(
      height: MediaQuery
          .of(context)
          .size
          .height * .9,
      color: Colors.white,
      child: new ListView(
        shrinkWrap: true,
        children: <Widget>[
          new Stepper(
            steps: steps,
            controlsBuilder: _controlsBuilder,
            type: StepperType.vertical,
            currentStep: currentStep,
            onStepContinue: () {
              if (currentStep == 0) {
                if (!_canMoveToClientStep()) {
                  return;
                }
                _moveToClientStep();
              } else if (currentStep == 1) {
                if (!_canMoveToClientStep() || !_canMoveToPromoCodeStep()) {
                  return;
                }
                _moveToPromoCodeStep();
              } else if (currentStep == 2) {
                if (!_canPostOrder()) {
                  Toast.show('Cannot post order', context);
                  return;
                }
                state.postOrder().then((ok) {
                  if (ok) {
                    Toast.show('Order submitted succesffully!', context);
                    Navigator.pushReplacementNamed(context, Router.home);
                  } else {
                    Toast.show(
                      'Failed to submit the order',
                      context,
                      backgroundColor: Colors.redAccent,
                      textColor: Colors.white70,
                    );
                  }
                });
              }
            },
            onStepCancel: () {
              setState(() {
                if (currentStep > 0) {
                  currentStep = currentStep - 1;
                } else {
                  currentStep = 0;
                }
              });
            },
            onStepTapped: (int step) {
              Toast.show(
                  'You can\'t tap on the step, press Next button', context);
            },
          ),
        ],
      ),
    );
  }

  bool _canPostOrder() {
    final order = _model.order;
    return order != null &&
        order.products != null &&
        order.products.length > 0 &&
        order.client != null;
  }

  bool _canMoveToClientStep() {
    final order = _model.order;
    return order != null && order.products != null && order.products.length > 0;
  }

  bool _canMoveToPromoCodeStep() {
    final order = _model.order;
    return order != null &&
        order.products != null &&
        order.products.length > 0 &&
        _clientFormKey.currentState.validate();
  }

  void _moveToProductsStep() {
    setState(() {
      currentStep = 0;
      _productsStepState = StepState.editing;

      _clientStepState = StepState.disabled;
      _codeStepState = StepState.disabled;
    });
  }

  void _moveToClientStep() {
    setState(() {
      currentStep = 1;
      _clientStepState = StepState.editing;

      print(_model.order.products.length);

      _productsStepState = StepState.complete;
      _codeStepState = StepState.disabled;
    });
  }

  void _moveToPromoCodeStep() {
    setState(() {
      _clientFormKey.currentState.save();
      print(_model.order.client);
      print(_model.order.client.name);

      currentStep = 2;
      _codeStepState = StepState.editing;

      _productsStepState = StepState.complete;
      _clientStepState = StepState.complete;
    });
  }
}
