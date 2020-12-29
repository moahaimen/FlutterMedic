import 'package:drugStore/localization/app_translation.dart';
import 'package:drugStore/models/order/order.dart';
import 'package:flutter/material.dart';

enum PromoCodeState { None, OnlyCalc, ViewTotal }

class OrderTotalUi extends StatelessWidget {
  final Order order;
  final PromoCodeState promoCode;
  final String currency;

  OrderTotalUi(
      {@required this.order,
      @required this.promoCode,
      @required this.currency});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final translator = AppTranslations.of(context);

    return Container(
      color: Colors.white60,
      child:
          this.order.promoCode == null || this.promoCode == PromoCodeState.None
              ? _getTotal(theme, translator, currency)
              : _getTotalWithPromoCode(theme, translator, currency),
    );
  }

  Widget _getTotal(ThemeData theme, AppTranslations trans, String currency) {
    return Column(
      children: [
        Text(trans.text('total'),
            style: theme.accentTextTheme.bodyText2.copyWith(color: Colors.red)),
        Text("${order.total.toString()} $currency",
            style: theme.accentTextTheme.headline6
                .copyWith(color: theme.primaryColorDark))
      ],
    );
  }

  Widget _getTotalWithPromoCode(
    ThemeData theme,
    AppTranslations translator,
    String currency,
  ) {
    List<Widget> children = [];

    // Add text
    children.add(
      Text(translator.text('total'),
          style: theme.accentTextTheme.bodyText2
              .copyWith(color: theme.primaryColorDark)),
    );

    // Check if should add total without promoCode
    if (this.promoCode == PromoCodeState.ViewTotal) {
      children.add(
        Text("${order.total.toString()} $currency",
            style: theme.accentTextTheme.headline6.copyWith(
                fontStyle: FontStyle.italic,
                decoration: TextDecoration.lineThrough,
                color: theme.primaryColorDark)),
      );
    }

    // Add total with promoCode Text
    children.add(
      Text('${order.totalWithCode.toString()} $currency',
          style: theme.accentTextTheme.headline6.copyWith(color: Colors.red)),
    );

    return Column(children: children);
  }
}
