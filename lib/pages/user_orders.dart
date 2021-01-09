import 'package:drugStore/components/user_orders/user_orders_list.dart';
import 'package:drugStore/partials/app_router.dart';
import 'package:drugStore/partials/drawer.dart';
import 'package:drugStore/partials/toolbar.dart';
import 'package:flutter/material.dart';

class UserOrdersPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerBuilder.build(context, AppRouter.userOrders),
      appBar: Toolbar.get(title: AppRouter.userOrders, context: context),
      body: Container(
        child: UserOrdersList(),
      ),
    );
  }
}
