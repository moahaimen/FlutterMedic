import 'package:drugStore/partials/router.dart';
import 'package:flutter/material.dart';

class DrawerBuilder {
  static TextStyle _makeTextStyle(String route) {
    return TextStyle(
        color: Colors.black38,
        fontWeight:
            Router.current == route ? FontWeight.w800 : FontWeight.w500);
  }

  static Drawer build(BuildContext context, String route) {
    return Drawer(
      elevation: 111,
      child: Container(
        color: Colors.white,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration:
                  BoxDecoration(color: Theme.of(context).primaryColorDark),
              padding: EdgeInsets.symmetric(vertical: 25.0, horizontal: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Drugs Store'.toUpperCase(),
                    style: TextStyle(
                      color: Theme.of(context).accentColor,
                      fontSize: 24,
                    ),
                  ),
                  SizedBox(
                    height: 4.0,
                  ),
                  Text(
                    'Hello, client!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  Spacer(),
                  Text("molardentalmaterials.com"),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text(
                "Home",
                style: _makeTextStyle(Router.home),
              ),
              onTap: () {
                if (Router.current == Router.home) {
                  return null;
                }
                Navigator.of(context).pushReplacementNamed(Router.home);
              },
            ),
            ListTile(
              leading: Icon(Icons.local_hospital),
              title: Text(
                "Products",
                style: _makeTextStyle(Router.products),
              ),
              onTap: () {
                if (Router.current == Router.products) {
                  return null;
                }
                Navigator.of(context).pushReplacementNamed(Router.products);
              },
            ),
            ListTile(
              leading: Icon(Icons.shopping_cart),
              title: Text(
                "Cart",
                style: _makeTextStyle(Router.cart),
              ),
              onTap: () {
                if (Router.current == Router.cart) {
                  return null;
                }
                Navigator.of(context).pushReplacementNamed(Router.cart);
              },
            ),
          ],
        ),
      ),
    );
  }
}
