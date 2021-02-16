import 'package:drugStore/pages/contact_us_page.dart';
import 'package:drugStore/pages/search_page.dart';
import 'package:drugStore/pages/settings_page.dart';
import 'package:drugStore/pages/user_order_details_page.dart';
import 'package:drugStore/pages/user_orders.dart';
import 'package:drugStore/pages/user_profile_edit_page.dart';
import 'package:drugStore/pages/user_profile_page.dart';
import 'package:drugStore/utils/state.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../pages/home_page.dart';
import '../pages/index_page.dart';
import '../pages/login_page.dart';
import '../pages/product_details_page.dart';
import '../pages/products_page.dart';
import '../pages/register_page.dart';

class AppRouter {
  static String current;

  static const String index = '/';
  static const String home = '/home/';
  static const String settings = '/settings/';
  static const String contactUs = '/contact-us/';

  static const String login = '/auth/login/';
  static const String register = '/auth/register/';

  static const String products = '/products/';
  static const String productDetails = '/products/:id/details/';
  static const String cart = '/cart/';
  static const String search = '/search/';

  static const String userProfile = '/me/';
  static const String userProfileEdit = '/me/edit';
  static const String userOrders = '/me/orders/';
  static const String userOrderDetails = '/me/orders/:id';

  static Map<String, Widget Function(BuildContext)> routes() {
    return {
      // Index: Always starts from splash, then you will redirected to
      // the correct page
      index: (BuildContext ctx) => _configureRoute(ctx, index, IndexPage()),
      // Authentication routes
      login: (BuildContext ctx) => _configureRoute(
            ctx,
            login,
            LoginPage(),
          ),
      register: (BuildContext ctx) =>
          _configureRoute(ctx, login, RegisterPage()),
      search: (BuildContext ctx) => _configureRoute(ctx, search, SearchPage()),
      productDetails: (BuildContext ctx) =>
          _configureRoute(ctx, productDetails, ProductDetailsPage()),
//      cart: (BuildContext ctx) => _routePageBuilder(ctx, cart, CartPage()),
      settings: (BuildContext ctx) =>
          _configureRoute(ctx, settings, SettingsPage()),
      contactUs: (BuildContext ctx) =>
          _configureRoute(ctx, contactUs, ContactUsPage()),

      userProfile: (BuildContext ctx) =>
          _configureRoute(ctx, userProfile, UserProfilePage(), auth: true),
      userProfileEdit: (BuildContext ctx) => _configureRoute(
          ctx, userProfileEdit, UserProfileEditPage(),
          auth: true),

      userOrders: (BuildContext ctx) =>
          _configureRoute(ctx, userOrders, UserOrdersPage(), auth: true),
      userOrderDetails: (BuildContext ctx) => _configureRoute(
          ctx, userOrderDetails, UserOrderDetailsPage(),
          auth: true),
    };
  }

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      // Home
      case home:
        return MaterialPageRoute(
          builder: (BuildContext context) => HomePage(
            id: settings.arguments ?? PageId.Home,
          ),
        );
      // Cart
      case cart:
        return MaterialPageRoute(
          builder: (BuildContext context) => HomePage(
            id: PageId.Cart,
          ),
        );
      // Products
      case products:
        return MaterialPageRoute(
          builder: (BuildContext context) => ProductsPage(
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

  static Widget _configureRoute(
      BuildContext context, String route, Widget widget,
      {bool auth = false}) {
    current = route;
    if (auth) {
      return ScopedModelDescendant<StateModel>(
        builder: (context, child, model) {
          if (model.userLoading) {
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else if (model.user == null) {
            return LoginPage();
          } else {
            return widget;
          }
        },
      );
    }
    return widget;
  }
}
