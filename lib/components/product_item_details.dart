import 'package:badges/badges.dart';
import 'package:drugStore/constants/strings.dart';
import 'package:drugStore/localization/app_translation.dart';
import 'package:drugStore/partials/router.dart';
import 'package:drugStore/ui/add_to_cart_button.dart';
import 'package:drugStore/utils/state.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:share/share.dart';

import '../models/product.dart';

class ProductItemDetails extends StatefulWidget {
  final Product product;

  ProductItemDetails({@required this.product});

  @override
  State<StatefulWidget> createState() =>
      _ProductItemDetailsState(product: product);
}

class _ProductItemDetailsState extends State<ProductItemDetails> {
  final Product product;

  _ProductItemDetailsState({@required this.product});

  @override
  Widget build(BuildContext context) {
    final translator = AppTranslations.of(context);

    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: <Widget>[
        SliverAppBar(
          stretch: true,
          floating: true,
          snap: false,
          pinned: true,
          onStretchTrigger: () {
            // Function callback for stretch
            return;
          },
          expandedHeight: 360.0,
          flexibleSpace: FlexibleSpaceBar(
            stretchModes: <StretchMode>[
              StretchMode.zoomBackground,
              StretchMode.blurBackground,
              StretchMode.fadeTitle,
            ],
            background: _buildAttachmentsList(),
          ),
          actions: [
            IconButton(
              padding: EdgeInsets.all(5),
              icon: Icon(
                Icons.share,
                size: 30,
              ),
              onPressed: () => _shareProduct(translator),
            ),
            ScopedModelDescendant<StateModel>(
              builder: (BuildContext context, Widget child, StateModel model) =>
                  Badge(
                    badgeColor: Colors.lightGreen,
                    position: BadgePosition(bottom: 5, left: 5),
                    shape: BadgeShape.circle,
                    borderRadius: 5,
                    child: IconButton(
                        color: Theme
                            .of(context)
                            .accentColor,
                        icon: Icon(Icons.shopping_cart, size: 30),
                        onPressed: () =>
                            Navigator.of(context).pushNamed(Router.cart)),
                    badgeContent: Text(
                      model.orderItemsCount,
                      style: TextStyle(fontSize: 8),
                    ),
                  ),
            )
          ],
        ),
        SliverList(
          delegate: SliverChildListDelegate([
            _buildSliverListItem(
                translator.text('product_name'), product.getName(context)),
            _buildSliverListItem(translator.text('product_description'),
                product.getDescription(context)),
            _buildSliverListItem(translator.text('product_brand'),
                product.brand.getName(context)),
            _buildSliverListItem(translator.text('product_category'),
                product.category.getName(context)),
            _buildSliverListItem(
                translator.text('product_price'), product.price.toString()),
            _buildAddToCartButton(),
          ]),
        ),
      ],
    );
  }

  Widget _buildAddToCartButton() {
    return Container(
      margin: EdgeInsets.zero,
      padding: EdgeInsets.symmetric(horizontal: 18.0, vertical: 10.0),
      color: Colors.white,
      child: ListTile(
        title: AddToCartButton(
          id: this.product.id,
        ),
      ),
    );
  }

  Widget _buildAttachmentsList() {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      physics: PageScrollPhysics(),
      itemCount: this.product.attachments.length,
      itemBuilder: (BuildContext context, int index) =>
          Container(
            color: Colors.white,
            width: MediaQuery
                .of(context)
                .size
                .width,
            child: Image.network(this.product.attachments[index].url,
                fit: BoxFit.contain),
          ),
    );
  }

  Widget _buildSliverListItem(String title, String content) {
    return Card(
      shadowColor: Colors.white30,
      margin: EdgeInsets.zero,
      color: Colors.white,
      child: ListTile(
        leading: Icon(
          Icons.clear_all,
          size: 25.0,
          color: Theme.of(context).primaryColorDark,
        ),
        title: Text(content),
        subtitle: Text(title,
            style: TextStyle(
                color: Theme
                    .of(context)
                    .accentColor, fontSize: 15.0)),
      ),
    );
  }

  void _shareProduct(AppTranslations translator) {
    final RenderBox box = context.findRenderObject();
    Share.share(
        "${translator.text('share_product_message')} ${product.getName(
            context)} ${Strings.downloadUrl}",
        subject: Strings.applicationTitle,
        sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
  }
}
