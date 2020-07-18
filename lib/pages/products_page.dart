import 'package:drugStore/partials/toolbar.dart';
import 'package:flutter/material.dart';

import '../components/products_list_view.dart';
import '../partials/drawer.dart';
import '../partials/router.dart';

class ProductsPage extends StatelessWidget {
  final Map<String, dynamic> filter;

  ProductsPage({this.filter = const {}});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerBuilder.build(context, Router.products),
      appBar: Toolbar.get(title: Router.products, context: context),
      body: Container(
        child: ProductsListView(
          filter: this.filter,
        ),
      ),
    );
  }
}
