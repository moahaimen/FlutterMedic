import 'package:drugStore/localization/app_translation.dart';
import 'package:drugStore/utils/state.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import 'order_total_widget.dart';

class OrderSummaryWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final state = ScopedModel.of<StateModel>(context);

    final translator = AppTranslations.of(context);
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          // Total
          Expanded(
              child: OrderTotalWidget(
            order: state.order,
            withPromo: false,
          )),
          // Total + Shipping fees
          Expanded(
            child: Card(
              borderOnForeground: true,
              child: Column(
                children: [
                  Text(translator.text("total_with_fees"),
                      style: theme.accentTextTheme.bodyText2
                          .copyWith(color: theme.primaryColorDark)),
                  Text("${state.order.totalWithFees.toString()} \$",
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
