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

  Widget _buildCartWidget(BuildContext context, StateModel state) {
    final List<CartStep> steps = [
      // Products step
      CartProductsStep(
        step: new Step(
          title: Text('Products'),
          content: CartProductsList(state: state),
        ),
      ),
      // Client Information
      CartClientStep(
        step: new Step(
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
        RaisedButton(
          child: Text('Continue'),
          onPressed: onStepContinue,
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
