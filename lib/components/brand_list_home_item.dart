import 'package:cached_network_image/cached_network_image.dart';
import 'package:drugStore/partials/router.dart';
import 'package:flutter/material.dart';

import '../models/brand.dart';

class BrandListHomeItem extends StatelessWidget {
  final Brand brand;
  final double width;

  BrandListHomeItem({@required this.brand, @required this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      width: this.width,
      padding: EdgeInsets.symmetric(horizontal: 2, vertical: 5),
      child: GestureDetector(
        child: Card(
          child: Container(
            padding: EdgeInsets.only(top: .25),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: Border.all(
                    width: .5, color: Theme.of(context).primaryColorDark)),
            child: Column(
              children: [
                CachedNetworkImage(
                  imageUrl: this.brand.photoUrl,
                  errorWidget: (context, url, error) => Icon(Icons.error),
                  fit: BoxFit.fitWidth,
                  height: 120,
                ),
                Divider(
                  height: 2,
                  color: Theme.of(context).primaryColorDark,
                ),
                Expanded(
                  child: Text(
                    this.brand.getTitle(context),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
        onTap: () => Navigator.of(context).pushNamed(
          Router.search,
          arguments: {
            'brand': this.brand,
          },
        ),
      ),
    );
  }
}
