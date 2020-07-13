import 'package:drugStore/partials/app_bar.dart';
import 'package:drugStore/partials/drawer.dart';
import 'package:drugStore/partials/router.dart';
import 'package:flutter/material.dart';

import '../components/cart.dart';

class CartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        drawer: DrawerBuilder.build(context, Router.cart),
        appBar: Toolbar.get(title: Router.cart),
        body: Cart(),
      );
}
