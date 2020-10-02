import 'package:drugStore/partials/router.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../components/product_item_details.dart';
import '../utils/state.dart';

class ProductDetailsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (!ScopedModel.of<StateModel>(context).ready) {
      Navigator.of(context).pushReplacementNamed(Router.index);
    }

    return Scaffold(
      body: ScopedModelDescendant<StateModel>(
        builder: (BuildContext context, Widget child, StateModel model) =>
            ProductItemDetails(product: model.products.selected),
      ),
    );
  }
}
