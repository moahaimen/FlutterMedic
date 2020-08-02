import 'package:drugStore/models/order.dart';
import 'package:flutter/material.dart';

class OrderTotalWidget extends StatelessWidget {
  final Order order;

  const OrderTotalWidget({@required this.order});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: order.promoCode == null
          ? _buildTotalOnlyWidget(Theme.of(context))
          : _buildTotalWithPromoCodeWidget(Theme.of(context)),
    );
  }

  Widget _buildTotalOnlyWidget(ThemeData theme) {
    return Container(
      color: Colors.white70,
      child: Column(
        children: [
          Text("Total",
              style:
                  theme.accentTextTheme.bodyText2.copyWith(color: Colors.red)),
          Text("${order.total.toString()} \$",
              style: theme.accentTextTheme.headline6)
        ],
      ),
    );
  }

  Widget _buildTotalWithPromoCodeWidget(ThemeData theme) {
    return Column(
      children: [
        Text("Total", style: theme.accentTextTheme.bodyText2),
        Text(
          "${order.total.toString()} \$",
          style: theme.accentTextTheme.headline6.copyWith(
            fontStyle: FontStyle.italic,
            decoration: TextDecoration.lineThrough,
          ),
        ),
        Text(
          '${order.totalWithCode.toString()} \$',
          style: theme.accentTextTheme.headline6.copyWith(color: Colors.red),
        ),
      ],
    );
  }
}
