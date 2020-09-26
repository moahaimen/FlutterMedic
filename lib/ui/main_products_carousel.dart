import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:drugStore/localization/app_translation.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../models/product.dart';
import '../utils/state.dart';

class MainProductsCarousel extends StatefulWidget {
  @override
  _MainProductsCarouselState createState() => _MainProductsCarouselState();
}

class _MainProductsCarouselState extends State<MainProductsCarousel> {
  final double height = 200.0;

  @override
  Widget build(BuildContext context) {
    final model = ScopedModel.of<StateModel>(context);
    final themeData = Theme.of(context);
    final translator = AppTranslations.of(context);

    assert(model != null);
    assert(model.products != null);

    List<Product> data = model.featured;

    if (data == null || data.length == 0) {
      return Container(
        width: double.infinity,
        height: height,
        child: Card(
          child: Center(
            child: Text(translator.text("products_list_empty")),
          ),
        ),
      );
    } else {
      return SizedBox(
        height: height,
        child: Carousel(
          images: data
              .map(
                (p) =>
                CachedNetworkImage(
                  imageUrl: p.image.url,
                  errorWidget: (context, url, error) => Icon(Icons.error),
                  fit: BoxFit.fitWidth,
                ),
          )
              .toList(),
          dotSize: 4.0,
          dotSpacing: 15.0,
          dotColor: themeData.accentColor,
          indicatorBgPadding: 5.0,
          dotBgColor: Colors.transparent,
          borderRadius: true,
        ),
      );
    }
  }
}
