import 'package:drugStore/models/order/order.dart';
import 'package:drugStore/utils/http.dart';
import 'package:drugStore/utils/state.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import 'user_order_list_item.dart';
import 'user_orders_list_empty.dart';

class UserOrdersList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final state = ScopedModel.of<StateModel>(context);
    return FutureBuilder<Result<List<Order>>>(
      future: state.fetchUserOrders(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
          case ConnectionState.active:
            return Center(
              child: CircularProgressIndicator(),
            );
          case ConnectionState.done:
            print(snapshot.data);
            return RefreshIndicator(
              onRefresh: () {
                return state.fetchUserOrders();
              },
              child: _buildOrdersWidget(context, snapshot.data),
            );
          default:
            return null;
        }
      },
    );
  }

  Widget _buildOrdersWidget(BuildContext context, Result<List<Order>> result) {
    if (result == null || result.error != null) {
      print(result.error);
      return Center(
        child: Column(
          children: [
            Icon(Icons.error_outline),
            Text("Error"),
          ],
        ),
      );
    }

    final orders = result.result;
    if (orders.length == 0) {
      return UserOrdersListEmpty();
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12),
      child: AnimatedList(
        initialItemCount: orders.length,
        itemBuilder: (context, index, animation) => Padding(
          padding: const EdgeInsets.all(2.0),
          child: ScaleTransition(
              child: SizedBox(
                child: UserOrderListItem(order: orders[index]),
              ),
              scale: animation),
        ),
      ),
    );
  }
}
