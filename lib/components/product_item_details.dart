import 'package:badges/badges.dart';
import 'package:drugStore/partials/router.dart';
import 'package:drugStore/ui/add_to_cart_button.dart';
import 'package:drugStore/utils/state.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

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
          expandedHeight: 380.0,
          flexibleSpace: FlexibleSpaceBar(
            stretchModes: <StretchMode>[
              StretchMode.zoomBackground,
              StretchMode.blurBackground,
              StretchMode.fadeTitle,
            ],
            background: _buildAttachmentsList(),
          ),
          actions: [
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
                        icon: Icon(Icons.shopping_cart),
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
            _buildSliverListItem('name', this.product.name),
            _buildSliverListItem('description', this.product.description),
            _buildSliverListItem('brand', this.product.brand.name),
            _buildSliverListItem('category', this.product.category.name),
            _buildSliverListItem('price', this.product.price.toString()),
            _buildAddToCartButton(),
          ]),
        ),
      ],
    );
  }

  Widget _buildAddToCartButton() {
//    return Container(
//      margin: EdgeInsets.zero,
//      padding: EdgeInsets.symmetric(horizontal: 18.0, vertical: 10.0),
//      color: Colors.white,
//      child: ListTile(
//        title: RaisedButton.icon(
//          onPressed: () => AskAddToCartModal.show(context, this.product),
//          icon: Icon(Icons.add_shopping_cart),
//          label: Text("Add to cart"),
//          color: Theme.of(context).accentColor,
//          padding: EdgeInsets.symmetric(vertical: 12.0),
//        ),
//      ),
//    );

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
    final children = [
      Container(
        width: MediaQuery.of(context).size.width,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Details of ${this.product.name}".toUpperCase(),
                  textAlign: TextAlign.center,
                  style: Theme
                      .of(context)
                      .textTheme
                      .headline1
                      .copyWith(color: Colors.black)),
              Text(
                'Swipe to the left or the right',
                textAlign: TextAlign.center,
                style: Theme
                    .of(context)
                    .textTheme
                    .headline4
                    .copyWith(color: Colors.black),
              ),
            ],
          ),
        ),
        color: Colors.white,
      ),
    ];

    children.addAll(this
        .product
        .attachments
        .map((e) => Container(
      color: Colors.white,
      width: MediaQuery
          .of(context)
          .size
          .width,
      child: Image.network(e.url, fit: BoxFit.cover),
    ))
        .toList());

    return ListView(
      scrollDirection: Axis.horizontal,
      physics: PageScrollPhysics(),
      children: children,
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
        subtitle: Text(
          title,
          style:
          TextStyle(color: Theme
              .of(context)
              .accentColor, fontSize: 15.0),
        ),
      ),
    );
  }
}
