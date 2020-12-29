import 'package:drugStore/models/product.dart';
import 'package:flutter/material.dart';

class ProductCurrentPrice extends StatelessWidget {
  final Product product;
  final String currency;

  const ProductCurrentPrice(this.product, this.currency);

  @override
  Widget build(BuildContext context) {
    return Text("${product.price.toString()} $currency",
        maxLines: 1,
        textAlign: TextAlign.start,
        style:
            Theme.of(context).textTheme.bodyText2.copyWith(color: Colors.red));
  }
}
