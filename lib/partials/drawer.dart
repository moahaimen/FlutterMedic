import 'package:drugStore/partials/router.dart';
import 'package:flutter/material.dart';

class _RouteData {
  final String name;
  final String title;
  final IconData iconData;
  final bool replacement;

  _RouteData({this.name, this.title, this.iconData, this.replacement});
}

class DrawerBuilder {
  static List<_RouteData> _routes = [
    _RouteData(
        name: Router.home,
        title: 'Home',
        iconData: Icons.home,
        replacement: true),
    _RouteData(
        name: Router.products,
        title: 'Products',
        iconData: Icons.widgets,
        replacement: true),
    _RouteData(
        name: Router.cart,
        title: 'Cart',
        iconData: Icons.shopping_cart,
        replacement: false),
  ];

  static TextStyle _makeTextStyle(String route, ThemeData theme) {
    return theme.textTheme.headline3.copyWith(
      fontWeight: Router.current == route ? FontWeight.w800 : FontWeight.w500,
      color:
      Router.current == route ? theme.accentColor : theme.primaryColorDark,
      decorationColor:
      Router.current == route ? theme.accentColor : theme.primaryColorDark,
    );
  }

  static Drawer build(BuildContext context, String route) {
    final themeData = Theme.of(context);

    return Drawer(
      elevation: 111,
      child: Container(
        color: Colors.white,
        child: ListView(
          padding: EdgeInsets.zero,
          children: _buildListOfRoutes(context, themeData),
        ),
      ),
    );
  }

  static List<Widget> _buildListOfRoutes(BuildContext context,
      ThemeData themeData) {
    List<Widget> routes = [];

    // Header
    routes.add(
      DrawerHeader(
        decoration: BoxDecoration(
          color: Theme
              .of(context)
              .primaryColorDark,
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(32.0),
          ),
        ),
        padding: EdgeInsets.symmetric(vertical: 25.0, horizontal: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Drugs Store'.toUpperCase(),
              style: TextStyle(
                color: Theme
                    .of(context)
                    .accentColor,
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
    );

    // Routes
    routes.addAll(_routes
        .map((e) =>
        ListTile(
          leading: Icon(e.iconData),
              title: Text(
                e.title,
                style: _makeTextStyle(e.name, themeData),
              ),
          onTap: Router.current == e.name
              ? null
              : () {
            if (e.replacement) {
              Navigator.of(context).pushReplacementNamed(e.name);
            } else {
              Navigator.of(context).pushNamed(e.name);
            }
          },
        ))
        .toList());

    return routes;
  }
}
