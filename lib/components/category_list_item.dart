import 'package:drugStore/partials/router.dart';
import 'package:flutter/material.dart';

import '../models/category.dart';

class CategoryListItem extends StatelessWidget {
  final Category category;

  CategoryListItem({@required this.category});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: Image.network(
                this.category.icon.url,
                width: 50,
                height: 50,
              ),
            ),
            Text(
              this.category.title,
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
