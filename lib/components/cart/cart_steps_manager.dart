import 'package:drugStore/components/cart/ui/totals/order_grand_total.dart';
import 'package:drugStore/models/order_management.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:toast/toast.dart';

import '../../constants/colors.dart';
import '../../localization/app_translation.dart';
import '../../pages/home_page.dart';
import '../../partials/router.dart';
import '../../utils/state.dart';
import 'steps/cart_products_step.dart';
import 'steps/cart_shipping_info_step.dart';
import 'steps/cart_step.dart';

class CartStepsManager extends StatefulWidget {
  final OrderManagement manager;

  CartStepsManager(this.manager);

  @override
  State<StatefulWidget> createState() {
    return new _CartStepsManagerState(this.manager);
  }
}

class _CartStepsManagerState extends State<CartStepsManager> {
  int currentStep;
  final List<CartStep> steps;

  _CartStepsManagerState(OrderManagement manager)
      : steps = [
          new CartProductsStep(manager),
          new CartShippingInfoStep(manager),
        ];

  @override
  void initState() {
    super.initState();

    if (!ScopedModel.of<StateModel>(context).ready) {
      Navigator.of(context).pushReplacementNamed(Router.index);
    }

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
            builder: (BuildContext context, Widget child, StateModel state) {
              switch (state.order.status) {
                case OrderStatus.Null:
                case OrderStatus.Restoring:
                case OrderStatus.Storing:
                case OrderStatus.Ready:
                  return RaisedButton(
                    child: Text(currentStep < this.steps.length - 1
                        ? translator.text('order_continue')
                        : translator.text('order_submit')),
                    onPressed: () => _onStepContinue(translator),
                    textColor: Colors.white,
                    disabledColor: AppColors.accentColor.withOpacity(0.6),
                  );
                case OrderStatus.Submitting:
                  return RaisedButton(
                    child: Text(translator.text('order_uploading')),
                    onPressed: null,
                    textColor: Colors.white,
                    disabledColor: AppColors.accentColor.withOpacity(0.6),
                  );
              }
              return null;
            },
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

  void _onStepContinue(AppTranslations translator) {
    final step = this.steps[currentStep];
    if (!step.finished()) {
      Toast.show(translator.text('continue_failed'), context);
      return;
    }
    step.save();

    setState(() {
      // step.icon = StepState.complete;

      if (currentStep == this.steps.length - 1) {
        this.widget.manager.submit(context).then((ok) {
          if (ok) {
            currentStep = 0;
            Toast.show(translator.text('order_submit_done'), context);
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

  void _onStepCancel() {
    setState(() => currentStep = currentStep == 0 ? 0 : currentStep - 1);
  }
}
