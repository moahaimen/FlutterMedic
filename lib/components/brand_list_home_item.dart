import 'package:drugStore/partials/router.dart';
import 'package:flutter/material.dart';

import '../models/brand.dart';

class BrandListHomeItem extends StatelessWidget {
  final Brand brand;

  BrandListHomeItem({@required this.brand});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      width: 132,
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
                Image.network(
                  this.brand.photoUrl,
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
          Router.products,
          arguments: {
            'brand': this.brand,
          },
        ),
      ),
    );
  }
}
