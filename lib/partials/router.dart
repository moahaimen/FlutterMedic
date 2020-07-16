import 'package:flutter/material.dart';

import '../pages/home_page.dart';
import '../pages/index_page.dart';
import '../pages/login_page.dart';
import '../pages/product_details_page.dart';
import '../pages/products_page.dart';
import '../pages/register_page.dart';

class Router {
  static String current;

  static const String index = '/';
  static const String home = '/home/';

  static const String login = '/auth/login/';
  static const String register = '/auth/register/';

  static const String products = '/products/';
  static const String productDetails = '/products/:id/details/';
  static const String cart = '/cart/';

  static Map<String, Widget Function(BuildContext)> routes() {
    return {
      // Index: Always starts from splash, then you will redirected to
      // the correct page
      index: (BuildContext ctx) => _routePageBuilder(ctx, index, IndexPage()),
      // Authentication routes
      login: (BuildContext ctx) => _routePageBuilder(ctx, login, LoginPage()),
      register: (BuildContext ctx) =>
          _routePageBuilder(ctx, login, RegisterPage()),
      productDetails: (BuildContext ctx) =>
          _routePageBuilder(ctx, productDetails, ProductDetailsPage()),
//      cart: (BuildContext ctx) => _routePageBuilder(ctx, cart, CartPage()),
    };
  }

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
    // Home
      case home:
        return MaterialPageRoute(
          builder: (BuildContext context) =>
              HomePage(
                id: settings.arguments,
              ),
        );
    // Cart
      case cart:
        return MaterialPageRoute(
          builder: (BuildContext context) =>
              HomePage(
                id: PageId.Cart,
              ),
        );
    // Products
      case products:
        return MaterialPageRoute(
          builder: (BuildContext context) =>
              ProductsPage(
                filter: settings.arguments ?? new Map<String, dynamic>(),
              ),
        );
    }
    return null;
  }

  ///
  /// Redirecting unknown routes into home page
  ///
  static Route<dynamic> onUnknownRoute(RouteSettings settings) {
    return MaterialPageRoute(
      builder: (BuildContext context) => HomePage(id: PageId.Home),
    );
  }

  static Widget _routePageBuilder(
      BuildContext context, String route, Widget widget) {
    current = route;
    return widget;
  }
}
