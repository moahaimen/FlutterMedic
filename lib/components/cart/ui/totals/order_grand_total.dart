import 'package:drugStore/constants/strings.dart';
import 'package:drugStore/localization/app_translation.dart';
import 'package:drugStore/utils/state.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class OrderGrandTotalUi extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final state = ScopedModel.of<StateModel>(context);

    final translator = AppTranslations.of(context);
    final theme = Theme.of(context);

    return Container(
      color: Colors.white60,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(translator.text("total_grand_total"),
              style: theme.accentTextTheme.bodyText2
                  .copyWith(color: theme.accentColor.withOpacity(.65))),
          Text(
              "${state.order.totalWithFees.toString()} ${Strings.currency(context)}",
              style: theme.accentTextTheme.headline6
                  .copyWith(color: theme.accentColor)),
        ],
      ),
    );
  }
}
