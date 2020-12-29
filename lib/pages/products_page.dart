import 'package:drugStore/partials/app_router.dart';
import 'package:drugStore/partials/toolbar.dart';
import 'package:drugStore/utils/push_notifications_manager.dart';
import 'package:flutter/material.dart';

import '../components/products_list_view.dart';
import '../partials/drawer.dart';

class ProductsPage extends StatelessWidget {
  final Map<String, dynamic> filter;

  ProductsPage({this.filter = const {}});

  @override
  Widget build(BuildContext context) {
    // Initializing PCM
    PushNotificationsManager.initialize(context);

    return Scaffold(
      drawer: DrawerBuilder.build(context, AppRouter.products),
      appBar: Toolbar.get(title: AppRouter.products, context: context),
      body: Container(
        child: ProductsListView(
          filter: this.filter,
          physics: AlwaysScrollableScrollPhysics(),
        ),
      ),
    );
  }
}
