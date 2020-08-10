import 'package:cached_network_image/cached_network_image.dart';
import 'package:drugStore/constants/strings.dart';
import 'package:drugStore/ui/add_to_cart_button.dart';
import 'package:drugStore/ui/ask_add_to_cart_modal.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../models/product.dart';
import '../partials/router.dart';
import '../utils/state.dart';

class ProductListItem extends StatefulWidget {
  final Product product;

  ProductListItem({this.product});

  @override
  State<ProductListItem> createState() =>
      ProductListItemState(product: this.product);
}

class ProductListItemState extends State<ProductListItem> {
  final Product product;

  ProductListItemState({this.product});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: new ValueKey(this.product.id),
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Container(
          child: Column(
            children: [
              Expanded(
                child: CachedNetworkImage(
                  imageUrl: this.product?.image?.url,
                  errorWidget: (context, url, error) => Icon(Icons.error),
                  alignment: Alignment.center,
                  fit: BoxFit.fill,
                  width: 200,
                ),
              ),
              Text(this.product.getTitle(context)),
              Text(
                "${this.product.price.toString()} ${Strings.currency(context)}",
                style: Theme.of(context)
                    .textTheme
                    .bodyText2
                    .copyWith(color: Colors.red),
              ),
              AddToCartButton(id: this.product.id),
            ],
          ),
        ),
        borderOnForeground: true,
      ),
      onTap: _gotoProductDetails,
      onLongPressUp: _askAddToCart,
    );
  }

  void _gotoProductDetails() {
    ScopedModel.of<StateModel>(context).setSelectedProduct(this.product.id);
    Navigator.of(context).pushNamed(Router.productDetails);
  }

  void _askAddToCart() {
    AskAddToCartModal.show(context, this.product);
  }
}
