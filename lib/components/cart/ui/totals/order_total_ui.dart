import 'package:drugStore/models/order.dart';
import 'package:flutter/material.dart';

enum PromoCodeState { None, OnlyCalc, ViewTotal }

class OrderTotalUi extends StatelessWidget {
  final Order order;
  final PromoCodeState promoCode;

  OrderTotalUi({@required this.order, @required this.promoCode});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      color: Colors.white60,
      child:
          this.order.promoCode == null || this.promoCode == PromoCodeState.None
              ? _getTotal(theme)
              : _getTotalWithPromoCode(theme),
    );
  }

  Widget _getTotal(ThemeData theme) {
    return Column(
      children: [
        Text("Total",
            style: theme.accentTextTheme.bodyText2.copyWith(color: Colors.red)),
        Text("${order.total.toString()} \$",
            style: theme.accentTextTheme.headline6
                .copyWith(color: theme.primaryColorDark))
      ],
    );
  }

  Widget _getTotalWithPromoCode(ThemeData theme) {
    List<Widget> children = [];

    // Add text
    children.add(
      Text("Total",
          style: theme.accentTextTheme.bodyText2
              .copyWith(color: theme.primaryColorDark)),
    );

    // Check if should add total without promoCode
    if (this.promoCode == PromoCodeState.ViewTotal) {
      children.add(
        Text("${order.total.toString()} \$",
            style: theme.accentTextTheme.headline6.copyWith(
                fontStyle: FontStyle.italic,
                decoration: TextDecoration.lineThrough,
                color: theme.primaryColorDark)),
      );
    }

    // Add total with promoCode Text
    children.add(
      Text('${order.totalWithCode.toString()} \$',
          style: theme.accentTextTheme.headline6.copyWith(color: Colors.red)),
    );

    return Column(children: children);
  }
}
