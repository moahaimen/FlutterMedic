import 'package:drugStore/partials/app_router.dart';
import 'package:drugStore/partials/drawer.dart';
import 'package:drugStore/partials/toolbar.dart';
import 'package:flutter/material.dart';

import '../components/cart/cart.dart';
import '../localization/app_translation.dart';

class CartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
      drawer: DrawerBuilder.build(context, AppRouter.home),
      appBar: Toolbar.get(
          title: AppTranslations.of(context).text('cart'), context: context),
      body: Cart());
}
