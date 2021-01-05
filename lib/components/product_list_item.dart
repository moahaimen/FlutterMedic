import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:drugStore/localization/app_translation.dart';
import 'package:drugStore/models/attachment.dart';
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
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
          side: BorderSide(
            color: Theme.of(context).canvasColor,
            width: .5,
          ),
        ),
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Container(
          child: Column(
            children: [
              Expanded(
                child: ProductListItemImage(
                  attachment: product.image,
                  available: product.available,
                ),
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

class ProductListItemImage extends StatelessWidget {
  final bool available;
  final Attachment attachment;

  const ProductListItemImage(
      {@required this.available, @required this.attachment});

  @override
  Widget build(BuildContext context) {
    final image = CachedNetworkImage(
      imageUrl: this.attachment.url,
      errorWidget: (context, url, error) => Icon(Icons.error),
      alignment: Alignment.center,
      fit: BoxFit.fill,
      width: 200,
    );

    return available
        ? image
        : Badge(
            shape: BadgeShape.square,
            borderRadius: 18,
            position: BadgePosition.topRight(top: 5, right: 10),
            padding: EdgeInsets.all(2),
            badgeContent: Text(
              AppTranslations.of(context).text('not_available'),
              style: TextStyle(color: Colors.white, fontSize: 10),
            ),
            child: image,
          );
  }
}
