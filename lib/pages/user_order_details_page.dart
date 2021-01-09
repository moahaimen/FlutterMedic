import 'package:drugStore/components/user_orders/user_order_details.dart';
import 'package:drugStore/models/order/order.dart';
import 'package:drugStore/partials/app_router.dart';
import 'package:drugStore/partials/drawer.dart';
import 'package:drugStore/partials/toolbar.dart';
import 'package:flutter/material.dart';

class UserOrderDetailsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Order order = ModalRoute.of(context).settings.arguments as Order;

    return Scaffold(
      drawer: DrawerBuilder.build(context, AppRouter.userOrderDetails),
      appBar: Toolbar.get(title: AppRouter.userOrderDetails, context: context),
      body: UserOrderDetails(order: order),
    );
  }
}
