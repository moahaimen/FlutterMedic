import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../models/product.dart';
import '../utils/state.dart';

class MyCarousel extends StatefulWidget {
  @override
  _CarouselState createState() => _CarouselState();
}

class _CarouselState extends State<MyCarousel> {
  @override
  Widget build(BuildContext context) {
    final model = ScopedModel.of<StateModel>(context);
    final themeData = Theme.of(context);
    final List<Product> products = model.products;

    if (model.productsLoading) {
      return Container(
        width: double.infinity,
        height: 200,
        child: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation(themeData.accentColor),
          ),
        ),
      );
    }

    if (model.products == null || model.products.length == 0) {
      return Container(
        width: double.infinity,
        height: 200,
        child: Card(
          child: Center(
            child: Text(
              "Products List is Empty",
            ),
          ),
        ),
      );
    }

    return SizedBox(
        height: 200.0,
        width: 350.0,
        child: Carousel(
          images: products
              .map((p) =>
              Image.network(
                p.image.url,
                fit: BoxFit.fitWidth,
              ))
              .toList(),
          dotSize: 4.0,
          dotSpacing: 15.0,
          dotColor: Theme
              .of(context)
              .accentColor,
          indicatorBgPadding: 5.0,
          dotBgColor: Colors.transparent,
          borderRadius: true,
          moveIndicatorFromBottom: 180.0,
          noRadiusForIndicator: true,
        ));
  }
}
