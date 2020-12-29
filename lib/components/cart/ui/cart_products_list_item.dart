import 'package:cached_network_image/cached_network_image.dart';
import 'package:drugStore/localization/app_translation.dart';
import 'package:drugStore/models/order/order_product.dart';
import 'package:drugStore/utils/state.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import 'order_item_quantity.dart';

class CartProductsListItem extends StatefulWidget {
  final int index;
  final OrderProduct item;
  final void Function(int id) onDelete;

  CartProductsListItem(
      {@required this.index, @required this.item, @required this.onDelete});

  @override
  State<CartProductsListItem> createState() => _CartProductsListItemState();
}

class _CartProductsListItemState extends State<CartProductsListItem> {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<StateModel>(
      builder: (context, child, model) {
        final translator = AppTranslations.of(context);
        final currency = translator.text(model.currency);

        return ListTile(
          leading: Card(
            borderOnForeground: true,
            child: CachedNetworkImage(
              imageUrl: widget.item.product.image.url,
              errorWidget: (context, url, error) => Icon(Icons.error),
              width: 75.0,
              height: 75.0,
              fit: BoxFit.cover,
            ),
          ),
          title: Row(
            children: [
              Expanded(
                child: Text(
                  widget.item.product.getTitle(context, length: 25),
                  style: Theme
                      .of(context)
                      .textTheme
                      .headline5,
                ),
              ),
              IconButton(
                icon: Icon(Icons.close),
                onPressed: () => widget.onDelete(widget.item.product.id),
              ),
            ],
          ),
          subtitle: Row(
            children: [
              Expanded(
                child: Text(
                  "${widget.item.subTotal} $currency",
                  style: Theme
                      .of(context)
                      .textTheme
                      .bodyText1,
                ),
              ),
              Container(
                width: 125.0,
                child: OrderItemQuantity(
                  initQuantity: widget.item.quantity,
                  onQuantity: (int qty) => setState(() => _setQuantity(qty)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _setQuantity(int quantity) {
    final model = ScopedModel.of<StateModel>(context);
    widget.item.quantity = quantity;
    model.setOrderProductQuantity(widget.item.product.id, widget.item.quantity);
  }
}
