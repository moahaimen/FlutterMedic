import 'package:flutter/material.dart';

import '../products_list_view.dart';
import 'categories_horizontal_list.dart';
import 'categorized_products_title.dart';

class CategorizedProductsComponent extends StatefulWidget {
  @override
  _CategorizedProductsComponentState createState() =>
      _CategorizedProductsComponentState();
}

class _CategorizedProductsComponentState
    extends State<CategorizedProductsComponent> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CategorizedProductsTitle(),
          SizedBox(height: 10),
          Container(
              height: 30,
              color: Colors.white,
              child: CategoriesHorizontalList()),
          SizedBox(height: 10),
          Container(
            color: Color(0xffefefef),
            child: ProductsListView(mode: ProductsListViewMode.CATEGORIES),
          ),
        ],
      ),
    );
  }
}
