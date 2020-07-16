import 'package:drugStore/pages/home_page.dart';
import 'package:drugStore/partials/router.dart';
import 'package:flutter/material.dart';

class _RouteData {
  final String name;
  final String title;
  final IconData iconData;
  final dynamic arguments;

  _RouteData({this.name, this.title, this.iconData, this.arguments});
}

class DrawerBuilder {
  static List<_RouteData> _routes = [
    _RouteData(
        name: Router.home,
        title: 'Home',
        iconData: Icons.home,
        arguments: PageId.Home),
    _RouteData(
        name: Router.home,
        title: 'Brands',
        iconData: Icons.account_balance,
        arguments: PageId.Brands),
    _RouteData(
        name: Router.home,
        title: 'Categories',
        iconData: Icons.widgets,
        arguments: PageId.Categories),
    _RouteData(
        name: Router.products, title: 'Products', iconData: Icons.widgets),
    _RouteData(
        name: Router.home,
        title: 'Cart',
        iconData: Icons.shopping_cart,
        arguments: PageId.Cart),
  ];

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

  static Widget _buildDrawerListItem(BuildContext ctx, _RouteData e,
      ThemeData theme) {
    return ListTile(
      leading: Icon(
        e.iconData,
        color: theme.primaryColorDark,
      ),
      title: Text(
        e.title,
        style: theme.textTheme.bodyText1,
      ),
      onTap: () =>
          Navigator.of(ctx)
              .pushReplacementNamed(e.name, arguments: e.arguments),
    );
  }

  static List<Widget> _buildListOfRoutes(BuildContext ctx, ThemeData theme) {
    // Header
    final Widget header = DrawerHeader(
      decoration: BoxDecoration(
        color: theme.primaryColorDark,
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(35.0),
        ),
      ),
      padding: EdgeInsets.symmetric(vertical: 22.0, horizontal: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Drugs Store'.toUpperCase(),
            style: theme.textTheme.headline3.copyWith(color: theme.accentColor),
          ),
          SizedBox(
            height: 4.0,
          ),
          Text(
            'Hello, client!',
            style:
            theme.textTheme.bodyText1.copyWith(color: theme.primaryColor),
          ),
          Text(
            "molardentalmaterials.com",
            style: theme.textTheme.caption.copyWith(color: theme.primaryColor),
          ),
        ],
      ),
    );

    final List<Widget> routes = [];
    routes.add(header);
    routes.addAll(
        _routes.map((e) => _buildDrawerListItem(ctx, e, theme)).toList());
    return routes;
  }
}
