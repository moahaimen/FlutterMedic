import 'package:drugStore/partials/drawer.dart';
import 'package:drugStore/partials/router.dart';
import 'package:drugStore/partials/toolbar.dart';
import 'package:flutter/material.dart';

import '../components/cart.dart';

class CartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
    drawer: DrawerBuilder.build(context, Router.home),
    appBar: Toolbar.get(title: "Cart", context: context),
        body: Cart(),
      );
}
