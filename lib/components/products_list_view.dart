import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:scoped_model/scoped_model.dart';

import 'product_list_item.dart';
import '../models/product.dart';
import '../utils/state.dart';

class ProductsListView extends StatelessWidget {
  final int _columnCount = 2;

  Widget _buildProductsList(bool loading, List<Product> products) {
    if (loading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    if (products == null || products.length == 0) {
      return Center(
        child: Text("Products List is Empty"),
      );
    }

    return AnimationLimiter(
      child: GridView.count(
        crossAxisCount: _columnCount,
        children: List.generate(
          products.length,
          (int index) {
            return AnimationConfiguration.staggeredGrid(
              position: index,
              duration: const Duration(milliseconds: 375),
              columnCount: _columnCount,
              child: ScaleAnimation(
                child: FadeInAnimation(
                  child: ProductListItem(product: products[index]),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<StateModel>(
      builder: (BuildContext context, Widget widget, StateModel model) {
        return RefreshIndicator(
          onRefresh: () {
            return model.fetchProducts();
          },
          child: _buildProductsList(model.productsLoading, model.products),
        );
      },
    );
  }
}
