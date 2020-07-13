import 'package:flutter/material.dart';

import '../pages/cart_page.dart';
import '../pages/index_page.dart';
import '../pages/home_page.dart';
import '../pages/login_page.dart';
import '../pages/register_page.dart';
import '../pages/product_details_page.dart';
import '../pages/products_page.dart';

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
      // Home
      home: (BuildContext ctx) => _routePageBuilder(ctx, home, HomePage()),
      // Products
      products: (BuildContext ctx) =>
          _routePageBuilder(ctx, products, ProductsPage()),
      productDetails: (BuildContext ctx) =>
          _routePageBuilder(ctx, productDetails, ProductDetailsPage()),
      cart: (BuildContext ctx) => _routePageBuilder(ctx, cart, CartPage()),
    };
  }

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    return null;
  }

  ///
  /// Redirecting unknown routes into home page
  ///
  static Route<dynamic> onUnknownRoute(RouteSettings settings) {
    return MaterialPageRoute(
      builder: (BuildContext context) => HomePage(),
    );
  }

  static Widget _routePageBuilder(
      BuildContext context, String route, Widget widget) {
    current = route;
    return widget;
  }
}
