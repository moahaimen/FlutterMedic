import 'package:badges/badges.dart';
import 'package:drugStore/constants/colors.dart';
import 'package:drugStore/constants/strings.dart';
import 'package:drugStore/pages/home_page.dart';
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

  static AppBar get(
      {String title, Widget child, @required BuildContext context}) {
    final Widget content = child != null
        ? child
        : Text(title == null
            ? _titles[Router.current]
            : _titles.containsKey(title) ? _titles[title] : title);

    return AppBar(
      // title: content,
      title: Text(
        Strings.applicationTitle,
        style: Theme
            .of(context)
            .textTheme
            .headline3
            .copyWith(color: AppColors.molarRed1Color),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          icon: Icon(Icons.search, size: 30),
          onPressed: () => Navigator.of(context).pushNamed(Router.search),
        ),
        ScopedModelDescendant<StateModel>(
          builder: (BuildContext context, Widget child, StateModel model) =>
              Badge(
                position: BadgePosition(bottom: 5, left: 5),
                shape: BadgeShape.circle,
                borderRadius: 5,
                child: IconButton(
                  icon: Icon(Icons.shopping_cart, size: 30),
                  onPressed: () =>
                      Navigator.of(context)
                          .pushReplacementNamed(
                          Router.home, arguments: PageId.Cart),
                ),
                badgeContent:
                Text(model.orderRestoring ? '0' : model.orderItemsCount),
                badgeColor: Colors.transparent,
              ),
        ),
      ],
    );
  }
}
