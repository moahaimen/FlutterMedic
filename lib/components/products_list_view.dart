import 'package:drugStore/models/brand.dart';
import 'package:drugStore/models/category.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:scoped_model/scoped_model.dart';

import '../models/product.dart';
import '../utils/state.dart';
import 'product_list_item.dart';

class ProductsListView extends StatelessWidget {
  //
  final Map<String, dynamic> filter;

  final int _columnCount = 2;

  ProductsListView({@required this.filter});

  Widget _buildProductsList(bool loading, List<Product> products,
      {Brand brand, Category category, String name}) {
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

    if (brand != null && brand.name != null) {
      products = products
          .where((element) => element.brand.name == brand.name)
          .toList();
    }

    if (category != null && category.name != null) {
      products = products
          .where((element) => element.category.name == category.name)
          .toList();
    }

    if (name != null && name.isNotEmpty) {
      products =
          products.where((element) => element.name.contains(name)).toList();
    }

    return AnimationLimiter(
      child: GridView.count(
        childAspectRatio: 2 / 3,
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
          child: _buildProductsList(
            model.productsLoading,
            model.products,
            brand: this.filter['brand'],
            category: this.filter['category'],
            name: this.filter['name'],
          ),
        );
      },
    );
  }
}
