import 'package:drugStore/models/order_product.dart';
import 'package:drugStore/partials/router.dart';
import 'package:drugStore/utils/state.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import 'order_item_quantity.dart';

class CartProductsList extends StatefulWidget {
  final GlobalKey<FormState> formKey;

  CartProductsList({@required this.formKey});

  @override
  State<CartProductsList> createState() =>
      _CartProductsListState(formKey: this.formKey);
}

class _CartProductsListState extends State<CartProductsList> {
  final GlobalKey<FormState> formKey;
  StateModel _model;

  _CartProductsListState({@required this.formKey});

  @override
  void initState() {
    super.initState();

    _model = ScopedModel.of<StateModel>(context);
  }

  Widget _buildProductItem(
      BuildContext context, int position, OrderProduct product) {
    return ListTile(
      leading: Image.network(
        product.product.image.url,
        width: 75.0,
      ),
      title: Row(
        children: [
          Text(
            product.product.name,
            style: Theme
                .of(context)
                .textTheme
                .headline3
                .copyWith(color: Colors.lightGreen),
          ),
        ],
      ),
      subtitle: Flex(
        direction: Axis.horizontal,
        children: [
          Container(
            width: 100.0,
            child: OrderItemQuantity(
              onQuantity: (int qty) =>
                  setState(() => _setItemQuantity(product, qty)),
              initQuantity: product.quantity,
            ),
          ),
          Container(
            width: 100.0,
            child: Chip(
              labelPadding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              label: Text(
                "${product.subTotal} \$",
                style: Theme
                    .of(context)
                    .textTheme
                    .bodyText2
                    .copyWith(
                  color: Colors.white,
                ),
              ),
              backgroundColor: Colors.redAccent,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildCartProductsList(List<OrderProduct> products) {
    Widget item;
    ThemeData theme = Theme.of(context);

    if (products != null && products.length > 0) {
      item = ListView.separated(
        shrinkWrap: true,
        separatorBuilder: (BuildContext context, int index) => Divider(),
        itemBuilder: (BuildContext context, int index) =>
            _buildProductItem(context, index, products[index]),
        itemCount: products.length,
      );
      // productCard = Center(child: Text(products.length.toString()));
    } else {
      item = Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 25, vertical: 12.5),
          child: Column(
            children: [
              Text(
                'Your Cart Is Empty',
                style: theme.accentTextTheme.headline3,
              ),
              SizedBox(height: 12),
              Text(
                'You need to add some items from products list',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyText1.copyWith(color: Colors.black),
              ),
              SizedBox(height: 12),
              OutlineButton.icon(
                onPressed: () =>
                    Navigator.of(context).pushNamed(Router.products),
                icon: Icon(
                  Icons.widgets,
                  size: 20,
                ),
                label: Text('Products'),
                color: Colors.white,
                textColor: Colors.black,
              ),
            ],
          ),
        ),
      );
    }
    return item;
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<StateModel>(
      builder: (BuildContext context, Widget child, StateModel model) {
        return Card(
          shadowColor: Colors.black,
          margin: EdgeInsets.zero,
          child: _buildCartProductsList(model.order?.products),
        );
      },
    );
  }

  void _setItemQuantity(OrderProduct e, int quantity) {
    setState(() {
      e.quantity = quantity;
      _model.setOrderProductQuantity(e.product.id, e.quantity);
    });
  }
}
