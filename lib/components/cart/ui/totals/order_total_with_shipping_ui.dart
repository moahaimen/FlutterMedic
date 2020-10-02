import 'package:drugStore/components/cart/ui/totals/order_total_ui.dart';
import 'package:drugStore/constants/strings.dart';
import 'package:drugStore/localization/app_translation.dart';
import 'package:drugStore/models/order.dart';
import 'package:flutter/material.dart';

class OrderTotalWithShippingUi extends StatelessWidget {
  final Order order;

  OrderTotalWithShippingUi(this.order);

  @override
  Widget build(BuildContext context) {
    final translator = AppTranslations.of(context);
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          // Total
          Expanded(
            child:
                OrderTotalUi(order: order, promoCode: PromoCodeState.OnlyCalc),
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
                  Text("${order.fees.toString()} ${Strings.currency(context)}",
                      style: theme.accentTextTheme.headline6
                          .copyWith(color: theme.accentColor)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
