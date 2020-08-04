import 'package:cached_network_image/cached_network_image.dart';
import 'package:drugStore/models/order_product.dart';
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
  State<CartProductsListItem> createState() =>
      _CartProductsListItemState(index: this.index, item: this.item);
}

class _CartProductsListItemState extends State<CartProductsListItem> {
  final int index;
  final OrderProduct item;

  _CartProductsListItemState({@required this.index, @required this.item});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      // leading: Card(
      //   borderOnForeground: true,
      //   child: CachedNetworkImage(
      //     imageUrl: item.product.image.url,
      //     errorWidget: (context, url, error) => Icon(Icons.error),
      //     width: 75.0,
      //     height: 75.0,
      //     fit: BoxFit.cover,
      //   ),
      // ),
      title: Row(
        children: [
          Expanded(
            child: Text(
              item.product.getTitle(context, length: 25),
              style: Theme.of(context).textTheme.headline5,
            ),
          ),
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () => widget.onDelete(index),
          ),
        ],
      ),
      subtitle: Row(
        children: [
          Expanded(
            child: Text(
              "${item.subTotal} \$",
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ),
          Container(
            width: 125.0,
            child: OrderItemQuantity(
              initQuantity: item.quantity,
              onQuantity: (int qty) => setState(() => _setQuantity(qty)),
            ),
          ),
        ],
      ),
    );
  }

  void _setQuantity(int quantity) {
    final model = ScopedModel.of<StateModel>(context);
    this.item.quantity = quantity;
    model.setOrderProductQuantity(this.item.product.id, this.item.quantity);
  }
}
