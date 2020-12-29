import 'package:drugStore/components/cart/ui/totals/order_grand_total.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:toast/toast.dart';

import '../../constants/colors.dart';
import '../../localization/app_translation.dart';
import '../../pages/home_page.dart';
import '../../partials/app_router.dart';
import '../../utils/state.dart';
import 'steps/cart_products_step.dart';
import 'steps/cart_shipping_info_step.dart';
import 'steps/cart_step.dart';

class CartStepsManager extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _CartStepsManagerState();
  }
}

class _CartStepsManagerState extends State<CartStepsManager> {
  int currentStep;
  final List<CartStep> steps = [
    new CartProductsStep(),
    new CartShippingInfoStep(),
  ];

  @override
  void initState() {
    super.initState();

    this.currentStep = 0;
  }

  @override
  Widget build(BuildContext context) {
    final translator = AppTranslations.of(context);

    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              physics: ClampingScrollPhysics(),
              child: steps[currentStep],
            ),
          ),
          _getControlsWidget(translator),
        ],
      ),
    );
  }

  Widget _getControlsWidget(AppTranslations translator) {
    return Container(
      decoration: BoxDecoration(
        border: Border.symmetric(
          vertical: BorderSide(
            width: 1,
            color: Color(0xffe4e8e4),
          ),
        ),
      ),
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      child: Row(
        children: [
          ScopedModelDescendant<StateModel>(
            builder: (BuildContext context, Widget child, StateModel state) =>
                RaisedButton(
              child: Text(state.orderUploading
                  ? translator.text('order_uploading')
                  : currentStep < this.steps.length - 1
                      ? translator.text('order_continue')
                      : translator.text('order_submit')),
              onPressed: state.orderUploading
                  ? null
                  : () => _onStepContinue(state, translator),
              textColor: Colors.white,
              disabledColor: AppColors.accentColor.withOpacity(0.6),
            ),
          ),
          SizedBox(
            width: 5,
          ),
          OutlineButton(
            child: Text(translator.text('order_cancel')),
            textColor: Theme.of(context).primaryColorDark,
            onPressed: _onStepCancel,
          ),
          Spacer(),
          OrderGrandTotalUi(),
        ],
      ),
    );
  }

  void _onStepContinue(StateModel state, AppTranslations translator) {
    final step = this.steps[currentStep];
    if (!step.finished(state)) {
      Toast.show(translator.text('continue_failed'), context);
      return;
    }
    step.save(state);

    setState(() {
      // step.icon = StepState.complete;

      if (currentStep == this.steps.length - 1) {
        state.postOrder().then((ok) {
          if (ok) {
            Toast.show(translator.text('order_submit_done'), context);
            currentStep = 0;
            Navigator.of(context)
                .pushReplacementNamed(AppRouter.home, arguments: PageId.Home);
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

  void _onStepCancel() {
    setState(() => currentStep = currentStep == 0 ? 0 : currentStep - 1);
  }
}
