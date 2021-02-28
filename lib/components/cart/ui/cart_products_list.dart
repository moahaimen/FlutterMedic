import 'dart:io';

import 'package:drugStore/components/cart/ui/totals/order_total_ui.dart';
import 'package:drugStore/localization/app_translation.dart';
import 'package:drugStore/models/order/order_product.dart';
import 'package:drugStore/utils/state.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import 'cart_products_list_item.dart';
import 'cart_promo_code.dart';

class CartProductsList extends StatelessWidget {
  final CartPromoCode promoCode;

  CartProductsList() : promoCode = new CartPromoCode();

  Widget _getCartEmpty(BuildContext context, ThemeData theme) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 25, vertical: 25),
      alignment: Alignment.center,
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
    );
  }

  Widget _buildOrderTotalWidget() {
    return ScopedModelDescendant<StateModel>(
      builder: (BuildContext context, Widget child, StateModel model) {
        final order = model.order;
        return OrderTotalUi(
          order: order,
          promoCode: PromoCodeState.ViewTotal,
          currency: AppTranslations.of(context).text(model.currency),
        );
      },
    );
  }

  Widget _getProductsList(
    BuildContext context,
    List<OrderProduct> products,
    void Function(int id) onDelete,
  ) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double targetWidth = deviceWidth > 550.0 ? 500.0 : deviceWidth * .985;
    final double paddingWidth =
        Platform.isAndroid ? deviceWidth - targetWidth : 0;

    final ThemeData theme = Theme.of(context);

    if (products == null || products.length == 0) {
      return _getCartEmpty(context, theme);
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: paddingWidth),
      child: ListView.separated(
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
            return CartProductsListItem(
              index: index,
              item: products[index],
              onDelete: onDelete,
            );
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<StateModel>(
      builder: (context, child, model) => _getProductsList(
          context, model.order.products.toList(), model.removeProductFromOrder),
    );
  }
}
