import 'package:drugStore/localization/app_translation.dart';
import 'package:drugStore/models/product.dart';
import 'package:drugStore/utils/state.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import 'product_current_price.dart';
import 'product_price_discount.dart';

class ProductPriceComponent extends StatelessWidget {
  final Product product;

  const ProductPriceComponent(this.product);

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<StateModel>(
      builder: (context, child, model) {
        final translator = AppTranslations.of(context);
        final currency = translator.text(model.currency);

        return Center(
          child: product.isDiscount
              ? ProductPriceDiscount(
                  product,
                  currency,
                )
              : ProductCurrentPrice(
                  product,
                  currency,
                ),
        );
      },
    );
  }
}
