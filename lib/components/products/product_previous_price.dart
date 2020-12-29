import 'package:drugStore/models/product.dart';
import 'package:flutter/material.dart';

class ProductPreviousPrice extends StatelessWidget {
  final Product product;
  final String currency;

  const ProductPreviousPrice(this.product, this.currency);

  @override
  Widget build(BuildContext context) {
    return Text("${product.previousPrice.toString()} $currency",
        maxLines: 1,
        textAlign: TextAlign.end,
        style: Theme.of(context)
            .textTheme
            .bodyText2
            .copyWith(decoration: TextDecoration.lineThrough));
  }
}
