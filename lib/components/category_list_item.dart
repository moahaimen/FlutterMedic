import 'package:cached_network_image/cached_network_image.dart';
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
        padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 4),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: CachedNetworkImage(
                imageUrl: this.category.icon.url,
                errorWidget: (context, url, error) => Icon(Icons.error),
                alignment: Alignment.center,
                // fit: BoxFit.contain,
                width: 90,
                height: 90,
              ),
            ),
            Text(
              this.category.getTitle(context),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
      onTap: () => Navigator.of(context)
          .pushNamed(Router.search, arguments: {'category': this.category}),
    );
  }
}
