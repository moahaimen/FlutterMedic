import 'package:drugStore/localization/app_translation.dart';
import 'package:drugStore/models/order/order_product.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:toast/toast.dart';

import '../components/cart/ui/order_item_quantity.dart';
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
  final OrderProduct item;

  _AskAddToCartModalState(Product product)
      : this.item = OrderProduct(product, 1);

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<StateModel>(
      builder: (context, child, model) {
        final translator = AppTranslations.of(context);

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "${translator.text('ask_add_to_cart_message')} ${this.item.product.enName}",
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
                  labelPadding:
                      EdgeInsets.symmetric(horizontal: 22, vertical: 4),
                  label: Text(
                      "${this.item.product.price} ${translator.text(model.currency)}"),
                ),
              ),
              Container(
                width: 200.0,
                child: OrderItemQuantity(
                  initQuantity: item.quantity,
                  onQuantity: (int qty) => this._setProductQuantity(qty),
                ),
              ),
              Container(
                width: 200.0,
                child: OutlineButton.icon(
                  onPressed: this.item.quantity > 0
                      ? () => _addProductToOrder(model, translator)
                      : null,
                  icon: Icon(Icons.add_shopping_cart),
                  label: Text(translator.text('add_to_cart')),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _addProductToOrder(StateModel model, AppTranslations translator) async {
    await model.addProductToOrder(this.item);
    Toast.show(translator.text('cart_item_add_done_message'), context);
    Navigator.of(context).pop();
  }

  void _setProductQuantity(int quantity) {
    setState(() {
      this.item.quantity = quantity;
    });
  }
}
