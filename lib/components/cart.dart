import 'package:drugStore/pages/home_page.dart';
import 'package:drugStore/partials/router.dart';
import 'package:drugStore/utils/cart_steps_manager.dart';
import 'package:drugStore/utils/state.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:toast/toast.dart';

import 'cart_client_information.dart';
import 'cart_products_list.dart';
import 'cart_promo_code.dart';

class Cart extends StatefulWidget {
  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  static int currentStep = 0;
  static CartStepsManager manager;

  @override
  void initState() {
    super.initState();
  }

  StepState _getProductsStepState(StateModel state) {
    if (currentStep == 0) {
      return StepState.editing;
    } else if (state.order.products.length > 0) {
      return StepState.complete;
    } else {
      return StepState.indexed;
    }
  }

  StepState _getClientStepState(StateModel state) {
    final c = state.order.client;
    if (currentStep == 1) {
      return StepState.editing;
    } else if (c != null &&
        c.name != null &&
        c.address != null &&
        c.province != null &&
        c.phone != null &&
        c.email != null) {
      return StepState.complete;
    } else {
      return StepState.indexed;
    }
  }

  StepState _getPromoCodeStepState(StateModel state) {
    if (currentStep == 2) {
      return StepState.editing;
    } else if (state.order.promoCode != null) {
      return StepState.complete;
    } else {
      return StepState.indexed;
    }
  }

  Widget _buildCartWidget(BuildContext context, StateModel state) {
    final List<CartStep> steps = [
      // Products step
      CartProductsStep(
        step: new Step(
          state: _getProductsStepState(state),
          title: Text('Products'),
          content: CartProductsList(state: state),
        ),
      ),
      // Client Information
      CartClientStep(
        step: new Step(
          state: _getClientStepState(state),
          title: Text('Client'),
          content: CartClientInformation(
            state: state,
            form: new GlobalKey<FormState>(),
          ),
        ),
      ),
      // Promo Code
      CartPromoCodeStep(
        step: new Step(
          state: _getPromoCodeStepState(state),
          title: Text('Promo Code'),
          content: CartPromoCode(
            state: state,
            form: new GlobalKey<FormState>(),
          ),
        ),
      ),
    ];

    manager = new CartStepsManager(steps: steps);

    return SingleChildScrollView(
      child: Stepper(
        currentStep: currentStep,
        type: StepperType.vertical,
        physics: ClampingScrollPhysics(),
        steps: steps.map((e) => e.step).toList(),
        onStepTapped: onStepTapped,
        onStepContinue: () => onStepContinue(state),
        onStepCancel: onStepCancel,
        controlsBuilder: buildStepperControls,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<StateModel>(
      builder: (BuildContext context, Widget child, StateModel model) {
        return Container(child: _buildCartWidget(context, model));
      },
    );
  }

  void onStepTapped(int step) {
    if (step < 0 || step >= manager.steps.length) {
      Toast.show('Unknown step number', context);
      return;
    }

    if (step > currentStep) {
      Toast.show('You cannot skip this step', context);
      return;
    }
    setState(() => currentStep = step);
  }

  void onStepContinue(StateModel state) {
    final step = manager.steps[currentStep];
    if (!step.finished(state)) {
      Toast.show('Cannot continue', context);
      return;
    }
    step.save(state);
    setState(() {
      step.state = StepState.complete;
      if (currentStep == manager.steps.length - 1) {
        state.postOrder().then((ok) {
          if (ok) {
            Toast.show('Order submitted succesfully', context);
            currentStep = 0;
            Navigator.of(context)
                .pushReplacementNamed(Router.home, arguments: PageId.Home);
            return;
          } else {
            Toast.show('Failed to submit the order', context);
          }
        });
      }
      if (currentStep < manager.steps.length - 1) {
        currentStep++;
      }
    });
  }

  void onStepCancel() {
    setState(() => currentStep = currentStep == 0 ? 0 : currentStep - 1);
  }

  Widget buildStepperControls(BuildContext context,
      {VoidCallback onStepContinue, VoidCallback onStepCancel}) {
    return Row(
      children: [
        ScopedModelDescendant<StateModel>(
          builder: (BuildContext context, Widget child, StateModel state) =>
              RaisedButton(
                child: Text(state.orderUploading ? 'Uploading...' : 'Continue'),
                onPressed: state.orderUploading ? null : onStepContinue,
              ),
        ),
        SizedBox(
          width: 5,
        ),
        OutlineButton(
          child: Text('Cancel'),
          textColor: Theme
              .of(context)
              .primaryColorDark,
          onPressed: onStepContinue,
        ),
      ],
    );
  }
}
