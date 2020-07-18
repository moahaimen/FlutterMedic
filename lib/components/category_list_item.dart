import 'package:drugStore/partials/router.dart';
import 'package:flutter/material.dart';

import '../models/category.dart';

class CategoryListItem extends StatelessWidget {
  final Category category;

  CategoryListItem({@required this.category});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Card(
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: Image.network(
                this.category.icon.url,
                fit: BoxFit.fitWidth,
              ),
            ),
            Text(
              this.category.name,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
      onTap: () => Navigator.of(context).pushNamed(
        Router.products,
        arguments: {
          'category': this.category,
        },
      ),
    );
  }
}
