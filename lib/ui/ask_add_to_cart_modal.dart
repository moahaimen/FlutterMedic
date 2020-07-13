import 'package:drugStore/components/order_item_quantity.dart';
import 'package:drugStore/models/order.dart';
import 'package:drugStore/models/order_product.dart';
import 'package:drugStore/utils/state.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../models/product.dart';

class AskAddToCartModal extends StatefulWidget {
  static void show(BuildContext context, Product product) {
    showModalBottomSheet(
      isDismissible: false,
      backgroundColor: Colors.white,
      context: context,
      builder: (BuildContext context) => AskAddToCartModal(product: product),
    );
  }

  final Product product;

  AskAddToCartModal({@required this.product});

  @override
  State<AskAddToCartModal> createState() =>
      _AskAddToCartModalState(this.product);
}

class _AskAddToCartModalState extends State<AskAddToCartModal> {
  final Product product;
  final OrderProduct _orderProduct =
      new OrderProduct(product: null, quantity: null);

  _AskAddToCartModalState(this.product);

  @override
  void initState() {
    super.initState();

    this._orderProduct.quantity = 1;
    this._orderProduct.product = this.product;
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 18.0),
      children: [
        ListTile(
          title: Text(
            "You asked to add product ${this.product.name} into your cart!",
            style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Theme.of(context).primaryColor),
          ),
          subtitle: Text(
            "Please set number of peices you want, then press OK.",
            style: TextStyle(
                fontWeight: FontWeight.w300,
                color: Theme.of(context).accentColor),
          ),
        ),
        SizedBox(
          height: 12.0,
        ),
        Center(
          child: Chip(
            label: Text("Price: ${this.product.price.toString()} \$/per piece"),
          ),
        ),
        SizedBox(
          height: 12.0,
        ),
        OrderItemQuantity(
          initQuantity: 1,
          onQuantity: (int qty) {
            print(qty);
            setState(() {
              this._setProductQuantity(qty);
            });
          },
        ),
        ListTile(
          title: RaisedButton(
            color: Theme.of(context).primaryColorDark,
            textColor: Colors.white,
            child: Text("Ok"),
            onPressed: this._orderProduct.quantity != null &&
                    this._orderProduct.quantity >= 1
                ? this._ok
                : null,
          ),
        ),
      ],
    );
  }

  void _ok() {
    ScopedModel.of<StateModel>(context).addOrderProductItem(this._orderProduct);
    Navigator.of(context).pop();
  }

  void _setProductQuantity(int quantity) {
    setState(() {
      this._orderProduct.quantity = quantity;
    });
  }
}
