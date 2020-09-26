import 'package:drugStore/localization/app_translation.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:toast/toast.dart';

import '../components/cart/ui/order_item_quantity.dart';
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
    final translator = AppTranslations.of(context);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "${translator.text('ask_add_to_cart_message')} ${this._orderProduct.product.enName}",
            style: TextStyle(
                color: Theme.of(context).primaryColorDark,
                fontSize: 20,
                fontWeight: FontWeight.w600),
          ),
          Text(
            translator.text('set_num_of_pieces'),
            style: TextStyle(
                color: Theme.of(context).primaryColorDark,
                fontSize: 16,
                fontWeight: FontWeight.w300),
          ),
          Container(
            width: 200.0,
            child: Chip(
              labelPadding: EdgeInsets.symmetric(horizontal: 22, vertical: 4),
              label: Text(
                  "${this._orderProduct.product.price} ${translator.text('bucks_per_peice')}"),
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
              label: Text(translator.text('add_to_cart')),
            ),
          ),
        ],
      ),
    );
  }

  void _ok() async {
    await ScopedModel.of<StateModel>(context).addOrderItem(this._orderProduct);
    Toast.show(
      AppTranslations.of(context).text('cart_item_add_done_message'),
      context,
    );
    Navigator.of(context).pop();
  }

  void _setProductQuantity(int quantity) {
    setState(() => this._orderProduct.quantity = quantity);
  }
}
