import 'package:carousel_slider/carousel_slider.dart';
import 'package:drugStore/partials/router.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../models/product.dart';
import '../utils/state.dart';

class Carousel extends StatefulWidget {
  @override
  _CarouselState createState() => _CarouselState();
}

class _CarouselState extends State<Carousel>
    with AutomaticKeepAliveClientMixin<Carousel> {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
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

    return Column(
      children: <Widget>[
        CarouselSlider(
          options: CarouselOptions(
              enlargeCenterPage: true,
              autoPlay: true,
              height: 250.0,
              viewportFraction: 0.75),
          items: products.map((product) {
            return Builder(
              builder: (BuildContext context) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      ScopedModel.of<StateModel>(context)
                          .setSelectedProduct(product.id);
                      Navigator.of(context).pushNamed(Router.productDetails);
                    },
                    child: Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: GestureDetector(
                        child: SizedBox(
                          width: double.infinity,
                          height: 200,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image.network(
                              product.image.url,
//                              loadingBuilder: (BuildContext context,
//                                  Widget child, ImageChunkEvent e) {
//                                return Center(
//                                  child: Container(
//                                    width: double.infinity,
//                                    height: double.infinity,
//                                    color: themeData.primaryColor,
//                                    child: Center(
//                                      child: CircularProgressIndicator(
//                                        valueColor: AlwaysStoppedAnimation(
//                                            themeData.accentColor),
//                                      ),
//                                    ),
//                                  ),
//                                );
//                              },
                              height: 300.0,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          }).toList(),
        ),
      ],
    );
  }
}
