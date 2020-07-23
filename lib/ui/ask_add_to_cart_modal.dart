import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:toast/toast.dart';

import '../components/order_item_quantity.dart';
import '../models/order_product.dart';
import '../models/product.dart';
import '../utils/state.dart';

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
  final OrderProduct _orderProduct;

  _AskAddToCartModalState(Product product)
      : this._orderProduct = OrderProduct(product: product, quantity: 1);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "You asked to add product ${this._orderProduct.product
                .name} into your cart!",
            style: TextStyle(
                color: Theme
                    .of(context)
                    .primaryColorDark,
                fontSize: 20,
                fontWeight: FontWeight.w600),
          ),
          Text(
            "Please set number of peices you want, then press OK.",
            style: TextStyle(
                color: Theme
                    .of(context)
                    .primaryColorDark,
                fontSize: 16,
                fontWeight: FontWeight.w300),
          ),
          Container(
            width: 200.0,
            child: Chip(
              labelPadding: EdgeInsets.symmetric(horizontal: 22, vertical: 4),
              label: Text("${this._orderProduct.product.price} \$/Piece"),
            ),
          ),
          Container(
            width: 200.0,
            child: OrderItemQuantity(
              initQuantity: _orderProduct.quantity,
              onQuantity: (int qty) =>
                  setState(() => this._setProductQuantity(qty)),
            ),
          ),
          Container(
            width: 200.0,
            child: OutlineButton.icon(
              onPressed: this._orderProduct.quantity > 0 ? this._ok : null,
              icon: Icon(Icons.add_shopping_cart),
              label: Text("Add to Cart"),
            ),
          ),
        ],
      ),
    );
  }

  void _ok() async {
    await ScopedModel.of<StateModel>(context)
        .addProductToOrder(this._orderProduct);
    Toast.show(
      'Item added suucessfully',
      context,
    );
    Navigator.of(context).pop();
  }

  void _setProductQuantity(int quantity) {
    setState(() {
      this._orderProduct.quantity = quantity;
    });
  }
}
