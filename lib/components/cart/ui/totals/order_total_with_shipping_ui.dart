import 'package:drugStore/components/cart/ui/totals/order_total_ui.dart';
import 'package:drugStore/localization/app_translation.dart';
import 'package:drugStore/utils/state.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class OrderTotalWithShippingUi extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final translator = AppTranslations.of(context);
    final theme = Theme.of(context);

    return ScopedModelDescendant<StateModel>(
      builder: (context, child, model) => Container(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            // Total
            Expanded(
              child: OrderTotalUi(
                order: model.order,
                promoCode: PromoCodeState.OnlyCalc,
                currency: translator.text(model.currency),
              ),
            ),
            // Total + Shipping fees
            Expanded(
              child: Container(
                color: Colors.white60,
                child: Column(
                  children: [
                    Text(translator.text("fees"),
                        style: theme.accentTextTheme.bodyText2
                            .copyWith(color: theme.primaryColorDark)),
                    Text(
                        "${model.order.fees.toString()} ${translator.text(
                            model.currency)}",
                        style: theme.accentTextTheme.headline6
                            .copyWith(color: theme.accentColor)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
