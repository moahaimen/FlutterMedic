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
            Text(
              this.category.title,
              style: TextStyle(
                  inherit: true, color: Theme.of(context).accentColor),
            ),
            SizedBox(
              height: 8.0,
            ),
            Text(
              this.category.name,
              style: TextStyle(
                  inherit: true,
                  fontWeight: FontWeight.w200,
                  color: Theme.of(context).primaryColor),
            ),
          ],
        ),
      ),
      onTap: () => Navigator.of(context).pushNamed(
        Router.products,
        arguments: {
          category: this.category,
        },
      ),
    );
  }
}
