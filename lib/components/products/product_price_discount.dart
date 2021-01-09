import 'package:drugStore/models/product.dart';
import 'package:flutter/material.dart';

import 'product_current_price.dart';
import 'product_previous_price.dart';

class ProductPriceDiscount extends StatelessWidget {
  final Product product;
  final String currency;

  const ProductPriceDiscount(this.product, this.currency);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: ProductPreviousPrice(product, currency),
        ),
        SizedBox(width: 4),
        Expanded(
          child: ProductCurrentPrice(product, currency),
        ),
      ],
    );
  }
}
