import 'package:drugStore/localization/app_translation.dart';
import 'package:drugStore/models/order_product.dart';
import 'package:drugStore/ui/order_total_widget.dart';
import 'package:drugStore/utils/state.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import 'cart_products_list_item.dart';
import 'cart_promo_code.dart';

class CartProductsList extends StatelessWidget {
  final StateModel state;
  final CartPromoCode promoCode;

  CartProductsList({@required this.state})
      : promoCode = new CartPromoCode(state: state);

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
                AppTranslations.of(context).text('cart_empty'),
                style: theme.accentTextTheme.bodyText1
                    .copyWith(color: theme.primaryColorDark),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOrderTotalWidget() {
    return ScopedModelDescendant<StateModel>(
      builder: (BuildContext context, Widget child, StateModel model) {
        final order = model.order;
        return OrderTotalWidget(
          order: order,
          withPromo: true,
        );
      },
    );
  }

  Widget _buildCartProductsList(
      BuildContext context, List<OrderProduct> products) {
    final ThemeData theme = Theme.of(context);

    if (products == null || products.length == 0) {
      return _buildCartEmpty(context, theme);
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      separatorBuilder: (BuildContext context, int index) => Divider(),
      itemCount: products.length + 2,
      itemBuilder: (BuildContext context, int index) {
        if (index == products.length + 1) {
          return _buildOrderTotalWidget();
        } else if (index == products.length) {
          return promoCode;
        } else {
          return CartProductsListItem(index: index, item: products[index]);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<StateModel>(
        builder: (BuildContext context, Widget child, StateModel model) =>
            _buildCartProductsList(context, model.order?.products));
  }
}
