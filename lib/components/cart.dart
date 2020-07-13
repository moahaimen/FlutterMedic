import 'package:drugStore/components/cart_promo_code.dart';
import 'package:drugStore/models/order.dart';
import 'package:drugStore/models/order_client.dart';
import 'package:drugStore/partials/router.dart';
import 'package:drugStore/utils/alert.dart';
import 'package:drugStore/utils/state.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import 'cart_client_information.dart';
import 'cart_products_list.dart';

class Cart extends StatefulWidget {
  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  static int currStep = 0;

  final GlobalKey<FormState> _productsFormKey = new GlobalKey<FormState>();

  final OrderClient _client = OrderClient.empty;
  final GlobalKey<FormState> _clientFormKey = new GlobalKey<FormState>();

  final GlobalKey<FormState> _promoCodeFormKey = new GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    StateModel model = ScopedModel.of<StateModel>(context);

    List<Step> steps = [
      Step(
          title: Text("Products"),
          content:
              CartProductsList(order: model.order, formKey: _productsFormKey)),
      Step(
          title: Text("Client Information"),
          content:
              CartClientInformation(formKey: _clientFormKey, client: _client)),
      Step(
          title: Text("Promo Code"),
          content: CartPromoCode(
            formKey: _promoCodeFormKey,
            confirmPromoCode: (String promoCode) =>
                _confirmPromoCode(model, promoCode),
          )),
    ];

    return ScopedModelDescendant<StateModel>(
      builder: (BuildContext context, Widget child, StateModel model) =>
          new Container(
//        color: Colors.white,
        child: new ListView(
          children: <Widget>[
            new Stepper(
              steps: steps,
              type: StepperType.vertical,
              currentStep: currStep,
              onStepContinue: () {
                setState(() {
                  if (currStep == 0) {
                    if (model.order?.products == null ||
                        model.order?.products?.length == 0) {
                      currStep = 0;
                      return;
                    }
                    currStep = 1;
                  } else if (currStep == 1) {
                    if (model.order?.products == null ||
                        model.order?.products?.length == 0) {
                      currStep = 0;
                      return;
                    }

                    if (model.order?.products == null ||
                        !_clientFormKey.currentState.validate()) {
                      currStep = 1;
                      return;
                    }
                    _clientFormKey.currentState.save();
                    _confirmOrderClient(model, _client);
                    currStep = 2;
                  } else if (currStep == 2) {
                    model.uploadOrder().then((value) {
                      if (value) {
                        Alert.alertMessage(
                            context,
                            "Done., Your order submitted succesfully",
                            "Order Upload");
                        Navigator.of(context).pushReplacementNamed(Router.home);
                      } else {
                        Alert.alertMessage(context,
                            "Sorry., Somthing went wrong!.", "Order Upload");
                      }
                    });
                  }
                });
              },
              onStepCancel: () {
                setState(() {
                  if (currStep > 0) {
                    currStep = currStep - 1;
                  } else {
                    currStep = 0;
                  }
                });
              },
              onStepTapped: (step) {
                // print You can't
              },
            ),
          ],
          shrinkWrap: true,
          reverse: true,
        ),
      ),
    );
  }

  void _confirmOrderProducts(StateModel model, Order order) {
    model.setOrderProducts(order.products);
  }

  void _confirmOrderClient(StateModel model, OrderClient client) {
    model.setOrderClient(client);
  }

  void _confirmPromoCode(StateModel model, String promoCode) {
    model.setOrderPromoCode(promoCode);
  }
}
