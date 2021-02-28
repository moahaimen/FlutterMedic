import 'dart:io';

import 'package:drugStore/components/cart/ui/totals/order_total_ui.dart';
import 'package:drugStore/localization/app_translation.dart';
import 'package:drugStore/models/order/order.dart';
import 'package:drugStore/utils/state.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import 'user_order_products_item.dart';

class UserOrderDetails extends StatelessWidget {
  final Order order;

  const UserOrderDetails({@required this.order});

  @override
  Widget build(BuildContext context) {
    final translator = AppTranslations.of(context);

    final double deviceWidth = MediaQuery.of(context).size.width;
    final double targetWidth = deviceWidth > 550.0 ? 500.0 : deviceWidth * .985;
    final double paddingWidth =
        Platform.isAndroid ? deviceWidth - targetWidth : 0;

    return ScopedModelDescendant<StateModel>(
      builder: (context, child, model) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: paddingWidth, vertical: 20),
          child: ListView.separated(
            separatorBuilder: (BuildContext context, int index) => Divider(),
            itemCount: order.products.length + 2,
            itemBuilder: (BuildContext context, int index) {
              if (index == order.products.length + 1) {
                return OrderTotalUi(
                  order: order,
                  promoCode: PromoCodeState.ViewTotal,
                  currency: translator.text(model.currency),
                );
              } else if (index == order.products.length) {
                return Container(
                  padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(translator.text('promo_code')),
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.black12,
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(15)),
                        padding:
                            EdgeInsets.symmetric(vertical: 2, horizontal: 10),
                        child: TextField(
                          textDirection: TextDirection.ltr,
                          decoration: InputDecoration(
                            hintText: translator.text('promo_code'),
                            enabled: false,
                            border: InputBorder.none,
                          ),
                          textAlign: TextAlign.center,
                          textAlignVertical: TextAlignVertical.center,
                          textInputAction: TextInputAction.done,
                          readOnly: true,
                          enabled: false,
                          controller: TextEditingController(
                            text: order.promoCode?.code ?? 'No Code Provided',
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                return UserOrderProductsItem(
                  item: this.order.products[index],
                  currency: model.currency,
                );
              }
            },
          ),
        );
      },
    );
  }
}
