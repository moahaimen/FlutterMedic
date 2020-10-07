import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:drugStore/constants/strings.dart';
import 'package:drugStore/localization/app_translation.dart';
import 'package:drugStore/ui/add_to_cart_button.dart';
import 'package:drugStore/ui/ask_add_to_cart_modal.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:toast/toast.dart';

import '../models/product.dart';
import '../partials/router.dart';
import '../utils/state.dart';

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
              buildProductPrice,
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

  Widget get buildProductPrice => product.isDiscount
      ? Center(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: Text(
                  "${product.oldPrice.toString()} ${Strings.currency(context)}",
                  maxLines: 1,
                  textAlign: TextAlign.end,
                  style: Theme.of(context).textTheme.bodyText2.copyWith(
                        // fontStyle: FontStyle.italic,
                        decoration: TextDecoration.lineThrough,
                      ),
                ),
              ),
              SizedBox(
                width: 4,
              ),
              Expanded(
                child: Text(
                  "${product.price.toString()} ${Strings.currency(context)}",
                  maxLines: 1,
                  textAlign: TextAlign.start,
                  style: Theme.of(context)
                      .textTheme
                      .bodyText2
                      .copyWith(color: Colors.red),
                ),
              ),
            ],
          ),
        )
      : Text(
          "${product.price.toString()} ${Strings.currency(context)}",
          style:
              Theme.of(context).textTheme.bodyText2.copyWith(color: Colors.red),
        );

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
    Navigator.of(context).pushNamed(Router.productDetails);
  }

  void _askAddToCart() {
    if (!product.available) {
      Toast.show(AppTranslations.of(context).text('not_available'), context);
      return;
    }
    AskAddToCartModal.show(context, product);
  }
}
