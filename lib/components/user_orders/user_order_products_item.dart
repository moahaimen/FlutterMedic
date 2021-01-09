import 'package:cached_network_image/cached_network_image.dart';
import 'package:drugStore/models/order/order_product.dart';
import 'package:flutter/material.dart';

class UserOrderProductsItem extends StatelessWidget {
  final OrderProduct item;
  final String currency;

  const UserOrderProductsItem({@required this.item, @required this.currency});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Card(
        borderOnForeground: true,
        child: CachedNetworkImage(
          imageUrl: this.item.product.image.url,
          errorWidget: (context, url, error) => Icon(Icons.error),
          width: 75.0,
          height: 75.0,
          fit: BoxFit.cover,
        ),
      ),
      title: Text(
        this.item.product.getTitle(context, length: 25),
        style: Theme.of(context).textTheme.headline5,
      ),
      subtitle: Row(
        children: [
          Expanded(
            child: Text(
              "${this.item.subTotal.toStringAsFixed(2)} $currency",
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ),
          Container(
            width: 100.0,
            child: Text(
              this.item.quantity.toString(),
              style: Theme.of(context).textTheme.headline5,
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}
