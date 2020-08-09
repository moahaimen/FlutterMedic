import 'package:drugStore/localization/app_translation.dart';
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


  final ScrollPhysics physics;

  ProductsListView({@required this.filter, @required this.physics});

  Widget _buildProductsList(BuildContext context, bool loading,
      List<Product> products,
      {Brand brand, Category category, String name}) {
    if (loading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    if (products == null || products.length == 0) {
      return Center(
        child: Text(AppTranslations.of(context).text("products_list_empty")),
      );
    }

    if (brand != null) {
      products = products
          .where((element) => element.brand.enName == brand.enName)
          .toList();
    }

    if (category != null) {
      products = products
          .where((element) => element.category.enName == category.enName)
          .toList();
    }

    if (name != null && name.isNotEmpty) {
      products = products
          .where((element) =>
      element.enName.contains(name) || element.arName.contains(name))
          .toList();
    }

    // Recheck  after filtering
    if (products.length == 0) {
      return Container(
        child: Center(
          child: Text(AppTranslations.of(context).text("products_list_empty")),
        ),
      );
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5),
      child: AnimationLimiter(
        child: GridView.count(
          shrinkWrap: true,
          physics: physics,
          childAspectRatio: 3 / 4,
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<StateModel>(
      builder: (BuildContext context, Widget widget, StateModel model) {
        if (this.filter.containsKey('home') && this.filter['home'] == true) {
          return _buildProductsList(
            context,
            model.productsLoading,
            model.products,
            brand: this.filter['brand'],
            category: this.filter['category'],
            name: this.filter['name'],
          );
        }
        return RefreshIndicator(
          onRefresh: () {
            return model.fetchProducts();
          },
          child: _buildProductsList(
            context,
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
