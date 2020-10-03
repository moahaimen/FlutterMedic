import 'package:drugStore/partials/toolbar.dart';
import 'package:drugStore/utils/push_notifications_manager.dart';
import 'package:drugStore/utils/state.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../components/products_list_view.dart';
import '../partials/drawer.dart';
import '../partials/router.dart';

class ProductsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (!ScopedModel.of<StateModel>(context).ready) {}

    // Initializing PCM
    PushNotificationsManager.initialize(context);

    return Scaffold(
      drawer: DrawerBuilder.build(context, Router.products),
      appBar: Toolbar.get(title: Router.products, context: context),
      body: SingleChildScrollView(
        child: ProductsListView(
          physics: AlwaysScrollableScrollPhysics(),
        ),
      ),
    );
  }
}
