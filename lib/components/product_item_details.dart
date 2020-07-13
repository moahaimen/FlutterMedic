import 'package:drugStore/ui/ask_add_to_cart_modal.dart';
import 'package:flutter/material.dart';

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
          expandedHeight: 320.0,
          flexibleSpace: FlexibleSpaceBar(
            stretchModes: <StretchMode>[
              StretchMode.zoomBackground,
              StretchMode.blurBackground,
              StretchMode.fadeTitle,
            ],
//            centerTitle: true,
//            title: Text("XX"),
            background: _buildListOfAttachments(),
          ),
          actions: [
            IconButton(
              color: Theme.of(context).primaryColorDark,
              icon: Icon(Icons.add_shopping_cart),
              onPressed: _askAddToCart,
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
    return Container(
      margin: EdgeInsets.zero,
      padding: EdgeInsets.symmetric(horizontal: 18.0, vertical: 10.0),
      color: Colors.white,
      child: ListTile(
        title: RaisedButton.icon(
          onPressed: () => AskAddToCartModal.show(context, this.product),
          icon: Icon(Icons.add_shopping_cart),
          label: Text("Add to cart"),
          color: Theme.of(context).accentColor,
          padding: EdgeInsets.symmetric(vertical: 12.0),
        ),
      ),
    );
  }

  Widget _buildListOfAttachments() {
    final children = [
      Container(
        width: MediaQuery.of(context).size.width,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Details of ${this.product.name}".toUpperCase(),
                style: TextStyle(
                    color: Theme.of(context).primaryColorDark,
                    fontSize: 15.0,
                    fontWeight: FontWeight.w500),
              ),
              Text(
                'Swipe to the left or the right',
                style: TextStyle(
                    color: Theme.of(context).primaryColorDark,
                    fontSize: 12.0,
                    fontWeight: FontWeight.w200),
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
              width: MediaQuery.of(context).size.width,
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
    return Container(
//      decoration: BoxDecoration(border: BorderRadius.zero),
      margin: EdgeInsets.zero,
      padding: EdgeInsets.symmetric(horizontal: 18.0, vertical: 10.0),
      color: Colors.white,
      child: ListTile(
        leading: Icon(
          Icons.label,
          size: 25.0,
          color: Theme.of(context).primaryColorDark,
        ),
        title: Text(content),
        subtitle: Text(
          title,
          style:
              TextStyle(color: Theme.of(context).accentColor, fontSize: 15.0),
        ),
      ),
    );
  }

  void _askAddToCart() {
    AskAddToCartModal.show(context, this.product);
  }
}
