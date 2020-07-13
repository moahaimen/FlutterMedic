import 'package:drugStore/models/order.dart';
import 'package:drugStore/models/order_product.dart';
import 'package:drugStore/utils/state.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class CartProductsList extends StatefulWidget {
  final Order order;
  final GlobalKey<FormState> formKey;

  CartProductsList({@required this.order, @required this.formKey});

  @override
  State<CartProductsList> createState() =>
      _CartProductsListState(order: order, formKey: this.formKey);
}

class _CartProductsListState extends State<CartProductsList> {
  final Order order;
  final GlobalKey<FormState> formKey;
  StateModel _model;

  _CartProductsListState({@required this.order, @required this.formKey});

  Widget _buildProductItems(
      BuildContext context, int position, OrderProduct product) {
    return ListTile(
      title: Text(product.product.name, style: TextStyle(color: Colors.blue)),
    );
  }

  Widget _buildCartProductsList(List<OrderProduct> products) {
    Widget item;
    if (products.length > 0) {
      item = SafeArea(
        child: ListView.builder(
          itemBuilder: (BuildContext context, int index) =>
              _buildProductItems(context, index, products[index]),
          itemCount: products.length,
        ),
      );
      // productCard = Center(child: Text(products.length.toString()));
    } else {
      item = Center(child: Text('YOUR CART IS EMPTY  :( '));
    }
    return item;
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<StateModel>(
        builder: (BuildContext context, Widget child, StateModel model) {
      return _buildCartProductsList(model.order.products);
    });
  }

  void _setItemQuantity(OrderProduct e, int quantity) {
    final item = this
        .order
        .products
        .firstWhere((element) => element.product.id == e.product.id);

    if (item == null) {
      throw Exception("Item Not Found");
    }
    setState(() {
      item.quantity = quantity;
      _model.setOrderProduct(e.product.id, e.quantity);
    });
  }
}
