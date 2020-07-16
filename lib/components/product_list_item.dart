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
        child: Column(
          children: [
            Expanded(
              child: Image.network(
                this.product.image.url,
                fit: BoxFit.fill,
                scale: .75,
              ),
            ),
            Text(this.product.title),
            Text(this.product.price.toString()),
            AddToCartButton(
              id: this.product.id,
            ),
          ],
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
