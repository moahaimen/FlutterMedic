import 'package:drugStore/partials/router.dart';
import 'package:flutter/material.dart';

import '../models/brand.dart';

class BrandListItem extends StatelessWidget {
  final Brand brand;

  BrandListItem({@required this.brand});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Card(
        child: Column(
          children: [
            Expanded(
              child: Image.network(
                this.brand.photoUrl,
                fit: BoxFit.fitWidth,
              ),
            ),
            Text(this.brand.name),
          ],
        ),
      ),
      onTap: () => Navigator.of(context).pushNamed(
        Router.products,
        arguments: {
          'brand': this.brand,
        },
      ),
    );
  }
}
