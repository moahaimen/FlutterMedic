import 'package:badges/badges.dart';
import 'package:drugStore/models/order.dart';
import 'package:drugStore/utils/state.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import 'router.dart';

class Toolbar {
  static final Map<String, String> _titles = {
    '/': 'Index',
    '/home/': 'Home',
    '/auth/login/': 'Login',
    '/auth/register/': 'Register',
    '/products/': 'Products',
    '/products/:id/details/': 'Product Details',
    '/cart/': 'Cart',
  };

  static AppBar get({String title, Widget child}) {
    final Widget content = child != null
        ? child
        : Text(title == null
            ? _titles[Router.current]
            : _titles.containsKey(title) ? _titles[title] : title);

    return AppBar(
      title: content,
      actions: [
        ScopedModelDescendant<StateModel>(
          builder: (BuildContext context, Widget child, StateModel model) =>
              GestureDetector(
            child: Badge(
                position: BadgePosition(bottom: 0, left: 0),
                shape: BadgeShape.circle,
                borderRadius: 5,
                child: Icon(Icons.shopping_cart),
                badgeContent: Text(
                  _getCartShoppingCount(model.order),
                  style: TextStyle(
                    fontSize: 5.5,
                  ),
                )),
            onTap: () => Navigator.of(context).pushNamed(Router.cart),
          ),
        ),
      ],
    );
  }

  static String _getCartShoppingCount(Order order) {
    int count = 0;
    if (order != null && order.products != null) {
      order.products.forEach((element) {
        count += element.quantity;
      });
    }
    return count.toString();
  }
}
