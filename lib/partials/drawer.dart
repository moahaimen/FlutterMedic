import 'package:drugStore/components/auth/auth_drawer_widget.dart';
import 'package:drugStore/constants/strings.dart';
import 'package:drugStore/localization/app_translation.dart';
import 'package:drugStore/pages/home_page.dart';
import 'package:drugStore/partials/app_router.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';

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
        name: AppRouter.home,
        title: 'home',
        iconData: Icons.home,
        arguments: PageId.Home),
    _RouteData(
        name: AppRouter.home,
        title: 'brands',
        iconData: Icons.account_balance,
        arguments: PageId.Brands),
    _RouteData(
        name: AppRouter.home,
        title: 'categories',
        iconData: Icons.widgets,
        arguments: PageId.Categories),
    _RouteData(
        name: AppRouter.products, title: 'products', iconData: Icons.widgets),
    _RouteData(
        name: AppRouter.home,
        title: 'cart',
        iconData: Icons.shopping_cart,
        arguments: PageId.Cart),
    _RouteData(
        name: AppRouter.userOrders,
        title: 'user_orders',
        iconData: Icons.favorite_border,
        arguments: PageId.Cart),
    _RouteData(
        name: AppRouter.settings, title: 'settings', iconData: Icons.settings),
    _RouteData(
        name: AppRouter.contactUs, title: 'contact_us', iconData: Icons.help),
  ];

  static Drawer build(BuildContext context, String route) {
    final themeData = Theme.of(context);
    final translator = AppTranslations.of(context);

    return Drawer(
      elevation: 111,
      child: Container(
        color: Colors.white,
        child: ListView(
          padding: EdgeInsets.zero,
          children: _buildListOfRoutes(context, themeData, translator),
        ),
      ),
    );
  }

  static Widget _buildDrawerListItem(BuildContext ctx, IconData icon,
      String title, String route, dynamic args, ThemeData theme) {
    return ListTile(
      leading: Icon(
        icon,
        color: theme.primaryColorDark,
      ),
      title: Text(
        title,
        style: theme.textTheme.bodyText2,
      ),
      onTap: () =>
          Navigator.of(ctx).pushReplacementNamed(route, arguments: args),
    );
  }

  static List<Widget> _buildListOfRoutes(
      BuildContext ctx, ThemeData theme, AppTranslations translator) {
    // Header
    final Widget header = Container(
      height: 120,
      child: DrawerHeader(
        decoration: BoxDecoration(
          color: Colors.transparent,
          image: DecorationImage(
            image: AssetImage('assets/images/molar-2.png'),
            fit: BoxFit.fill,
            matchTextDirection: true,
          ),
        ),
        curve: Curves.bounceIn,
        child: Container(),
      ),
    );

    // Share app
    final Widget share = ListTile(
      leading: Icon(Icons.share, color: theme.primaryColorDark),
      title: Text(
        translator.text("share"),
        style: theme.textTheme.bodyText2,
      ),
      onTap: () async {
        final downloadUrl = await Strings.downloadUrl;
        final RenderBox box = ctx.findRenderObject();
        Share.share("${translator.text('share_app_message')} $downloadUrl",
            subject: Strings.applicationTitle,
            sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
      },
    );

    final Widget auth = AuthDrawerWidget();

    final List<Widget> routes = [];
    routes.add(header);
    routes.addAll(_routes
        .map((e) => _buildDrawerListItem(ctx, e.iconData,
            translator.text(e.title), e.name, e.arguments, theme))
        .toList());
    routes.add(share);
    routes.add(auth);
    return routes;
  }
}
