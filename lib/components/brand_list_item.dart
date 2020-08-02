import 'package:cached_network_image/cached_network_image.dart';
import 'package:drugStore/partials/router.dart';
import 'package:flutter/material.dart';

import '../models/brand.dart';

class BrandListItem extends StatelessWidget {
  final Brand brand;

  BrandListItem({@required this.brand});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.5, vertical: 2.5),
      child: GestureDetector(
        child: Card(
          child: Column(
            children: [
              Expanded(
                child: CachedNetworkImage(
                  imageUrl: this.brand.photoUrl,
                  errorWidget: (context, url, error) => Icon(Icons.error),
                  fit: BoxFit.contain,
                  width: 125,
                ),
              ),
              Text(this.brand.getTitle(context)),
            ],
          ),
        ),
        onTap: () => Navigator.of(context).pushNamed(
          Router.products,
          arguments: {
            'brand': this.brand,
          },
        ),
      ),
    );
  }
}
