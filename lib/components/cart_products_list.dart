import 'package:drugStore/models/order_product.dart';
import 'package:drugStore/utils/state.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import 'cart_products_list_item.dart';

class CartProductsList extends StatelessWidget {
  final StateModel state;
  final GlobalKey<FormState> formState = GlobalKey<FormState>();

  CartProductsList({@required this.state});

  Widget _buildCartEmpty(BuildContext context, ThemeData theme) {
    return Card(
      color: Colors.white70,
      child: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 25, vertical: 12.5),
          child: Column(
            children: [
              Icon(
                Icons.remove_shopping_cart,
                size: 33.3,
                color: theme.primaryColorDark,
              ),
              Text(
                'Empty',
                style: theme.accentTextTheme.bodyText1,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOrderTotalWidget(ThemeData theme) {
    return ScopedModelDescendant<StateModel>(
      builder: (BuildContext context, Widget child, StateModel model) {
        final order = model.order;
        return Card(
          color: Colors.white70,
          child: Align(
            alignment: Alignment.center,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 25, vertical: 12.5),
              child: Column(
                children: [
                  Text(
                    'Total',
                    style:
                    theme.textTheme.bodyText2.copyWith(color: Colors.red),
                  ),
                  Text(
                    '${order.total} \$',
                    style: theme.accentTextTheme.headline6,
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCartProductsList(BuildContext context,
      List<OrderProduct> products) {
    final ThemeData theme = Theme.of(context);

    if (products == null || products.length == 0) {
      return _buildCartEmpty(context, theme);
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      separatorBuilder: (BuildContext context, int index) => Divider(),
      itemBuilder: (BuildContext context, int index) =>
      index == products.length
          ? _buildOrderTotalWidget(theme)
          : CartProductsListItem(index: index, item: products[index]),
      itemCount: products.length + 1,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<StateModel>(
        builder: (BuildContext context, Widget child, StateModel model) =>
            _buildCartProductsList(context, model.order?.products));
  }
}
