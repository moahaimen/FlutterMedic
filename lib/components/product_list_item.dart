import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:drugStore/localization/app_translation.dart';
import 'package:drugStore/ui/add_to_cart_button.dart';
import 'package:drugStore/ui/ask_add_to_cart_modal.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:toast/toast.dart';

import '../models/product.dart';
import '../partials/app_router.dart';
import '../utils/state.dart';
import 'products/product_price_component.dart';

class ProductListItem extends StatefulWidget {
  final Product product;

  ProductListItem({this.product});

  @override
  State<ProductListItem> createState() =>
      ProductListItemState(product: product);
}

class ProductListItemState extends State<ProductListItem> {
  final Product product;

  ProductListItemState({this.product});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: new ValueKey(product.id),
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Container(
          child: Column(
            children: [
              Expanded(
                child: productImageWrapper,
              ),
              Text(product.getTitle(context)),
              ProductPriceComponent(product),
              AddToCartButton(id: product.id),
            ],
          ),
        ),
        borderOnForeground: true,
      ),
      onTap: _gotoProductDetails,
      onLongPressUp: _askAddToCart,
    );
  }

  Widget get productImageContent => CachedNetworkImage(
      imageUrl: product?.image?.url ?? '',
      errorWidget: (context, url, error) => Icon(Icons.error),
      alignment: Alignment.center,
      fit: BoxFit.fill,
      width: 200);

  Widget get productImageWrapper => product.available
      ? productImageContent
      : Badge(
          shape: BadgeShape.square,
          borderRadius: 18,
          position: BadgePosition.topLeft(top: 2, left: 2),
          padding: EdgeInsets.all(2),
          badgeContent: Text(
            AppTranslations.of(context).text('not_available'),
            style: TextStyle(color: Colors.white, fontSize: 10),
          ),
          child: productImageContent,
        );

  void _gotoProductDetails() {
    ScopedModel.of<StateModel>(context).setSelectedProduct(product.id);
    Navigator.of(context).pushNamed(AppRouter.productDetails);
  }

  void _askAddToCart() {
    if (!product.available) {
      Toast.show(AppTranslations.of(context).text('not_available'), context);
      return;
    }
    AskAddToCartModal.show(context, product);
  }
}
