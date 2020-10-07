import 'package:drugStore/partials/toolbar.dart';
import 'package:drugStore/utils/push_notifications_manager.dart';
import 'package:flutter/material.dart';

import '../components/products_list_view.dart';
import '../partials/drawer.dart';
import '../partials/router.dart';

class ProductsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Initializing PCM
    PushNotificationsManager.initialize(context);

    return Scaffold(
      drawer: DrawerBuilder.build(context, Router.products),
      appBar: Toolbar.get(title: Router.products, context: context),
      body: ProductsListView(mode: ProductsListViewMode.PAGE),
    );
  }
}
