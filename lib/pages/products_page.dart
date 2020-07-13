import 'package:drugStore/partials/app_bar.dart';
import 'package:flutter/material.dart';

import '../components/products_list_view.dart';
import '../partials/drawer.dart';
import '../partials/router.dart';

class ProductsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerBuilder.build(context, Router.products),
      appBar: Toolbar.get(title: Router.products),
      body: Container(
        child: ProductsListView(),
      ),
    );
  }
}
