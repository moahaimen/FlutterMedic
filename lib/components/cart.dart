import 'package:drugStore/localization/app_translation.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:toast/toast.dart';

import '../pages/home_page.dart';
import '../partials/router.dart';
import '../utils/cart_steps_manager.dart';
import '../utils/state.dart';
import 'cart_client_information.dart';
import 'cart_products_list.dart';

class Cart extends StatefulWidget {
  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  static int currentStep = 0;
  static CartStepsManager manager;

  AppTranslations translator;

  @override
  void initState() {
    super.initState();
    currentStep = 0;
  }

  StepState _getProductsStepState(StateModel state) {
    if (currentStep == 0) {
      return StepState.editing;
    } else if (state.order.products.length > 0 &&
        state.order.promoCode != null) {
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
        c.phone != null) {
      return StepState.complete;
    } else {
      return StepState.indexed;
    }
  }

  Widget _buildCartWidget(BuildContext context, StateModel state) {
    final List<CartStep> steps = [
      // Products and Promo code step
      CartProductsStep(
        step: new Step(
          state: _getProductsStepState(state),
          title: Text(translator.text('cart_products_step')),
          content: CartProductsList(state: state),
        ),
      ),
      // Client Information
      CartClientStep(
        step: new Step(
          state: _getClientStepState(state),
          title: Text(translator.text('cart_client_step')),
          content: CartClientInformation(
            state: state,
          ),
        ),
      ),
    ];

    manager = new CartStepsManager(steps: steps);

    return SingleChildScrollView(
      child: Container(
        color: Colors.white,
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    translator = AppTranslations.of(context);

    return ScopedModelDescendant<StateModel>(
      builder: (BuildContext context, Widget child, StateModel model) {
        if (model.orderRestoring || model.provincesLoading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return Directionality(
          textDirection: translator.locale.languageCode == "en"
              ? TextDirection.ltr
              : TextDirection.rtl,
          child: Container(child: _buildCartWidget(context, model)),
        );
      },
    );
  }

  void onStepTapped(int step) {
    if (step < 0 || step >= manager.steps.length) {
      Toast.show(translator.text('cart_step_unknown'), context);
      return;
    }

    if (step > currentStep) {
      Toast.show(translator.text('press_continue_button'), context);
      return;
    }
    setState(() => currentStep = step);
  }

  void onStepContinue(StateModel state) {
    final step = manager.steps[currentStep];
    if (!step.finished(state)) {
      Toast.show(translator.text('continue_failed'), context);
      return;
    }
    step.save(state);
    setState(() {
      step.state = StepState.complete;

      if (currentStep == manager.steps.length - 1) {
        state.postOrder().then((ok) {
          if (ok) {
            Toast.show(translator.text('order_submit_done'), context);
            currentStep = 0;
            Navigator.of(context)
                .pushReplacementNamed(Router.home, arguments: PageId.Home);
            return;
          } else {
            Toast.show(translator.text('order_submit_failed'), context);
          }
        });
      } else {
        currentStep++;
      }
    });
  }

  void onStepCancel() {
    setState(() => currentStep = currentStep == 0 ? 0 : currentStep - 1);
  }

  Widget buildStepperControls(BuildContext context,
      {VoidCallback onStepContinue, VoidCallback onStepCancel}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          ScopedModelDescendant<StateModel>(
            builder: (BuildContext context, Widget child, StateModel state) =>
                RaisedButton(
                  child: Text(state.orderUploading
                      ? translator.text('order_uploading')
                      : currentStep < manager.steps.length - 1
                      ? translator.text('order_continue')
                      : translator.text('order_submit')),
                  onPressed: state.orderUploading ? null : onStepContinue,
                  textColor: Colors.white,
                  disabledColor: Colors.lightGreen.withOpacity(0.6),
                ),
          ),
          SizedBox(
            width: 5,
          ),
          OutlineButton(
            child: Text(translator.text('order_cancel')),
            textColor: Theme
                .of(context)
                .primaryColorDark,
            onPressed: onStepCancel,
          ),
        ],
      ),
    );
  }
}
