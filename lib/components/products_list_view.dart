import 'package:drugStore/localization/app_translation.dart';
import 'package:drugStore/models/brand.dart';
import 'package:drugStore/models/category.dart';
import 'package:drugStore/models/pagination.dart';
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
  final ScrollController _controller = new ScrollController();

  ProductsListView({@required this.filter, @required this.physics});

  Widget _buildProductsList(BuildContext context, Pagination<Product> obj,
      Map<String, dynamic> filter) {
    List<Product> products = obj.data;

    if (products == null || products.length == 0) {
      return Container(
        height: 250,
        child: Center(
          child: Text(
            AppTranslations.of(context).text("products_list_empty"),
          ),
        ),
      );
    }

    if (filter.containsKey('brand')) {
      final brand = filter['brand'] as Brand;
      if (brand != null)
        products =
            products.where((e) => e.brand.enName == brand.enName).toList();
    }

    if (filter.containsKey('category')) {
      final category = filter['category'] as Category;
      if (category != null)
        products = products
            .where((e) => e.category.enName == category.enName)
            .toList();
    }

    if (filter.containsKey('name')) {
      final name = filter['name'] as String;
      if (name.isNotEmpty)
        products = products
            .where((e) => e.enName.contains(name) || e.arName.contains(name))
            .toList();
    }

    // Recheck  after filtering
    if (products.length == 0) {
      return Container(
        height: 250,
        child: Center(
          child: Text(
            AppTranslations.of(context).text("products_list_empty"),
          ),
        ),
      );
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5),
      child: Column(
        children: [
          AnimationLimiter(
            child: GridView.count(
              controller: _controller,
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
          Center(
            child: ScopedModelDescendant(
              builder: (BuildContext c, Widget child, StateModel model) =>
                  FlatButton(
                    onPressed: model.products.status ==
                        PaginationStatus.Loading &&
                        model.products.nextPageUrl != null
                        ? null
                        : () => obj.fetch(context, path: obj.nextPageUrl),
                    child: Text(
                      model.products.status == PaginationStatus.Loading
                          ? AppTranslations.of(context).text("loading")
                          : AppTranslations.of(context).text("load_more"),
                      style: TextStyle(
                        inherit: true,
                        color: Theme
                            .of(context)
                            .accentColor,
                      ),
                    ),
                  ),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<StateModel>(
      builder: (BuildContext context, Widget widget, StateModel model) {
        assert(model != null);
        assert(model.products != null);

        final obj = model.products;

        switch (obj.status) {
          case PaginationStatus.Null:
            obj.fetch(context);
            return Center(child: CircularProgressIndicator());
          case PaginationStatus.Loading:
//            return Center(child: CircularProgressIndicator());
          case PaginationStatus.Ready:
            if (filter.containsKey('categorized') && filter['categorized']) {
              filter['category'] = model.categories.selected;
            }
            Widget content = _buildProductsList(context, obj, filter);

            if (!filter.containsKey('home') || !filter['home']) {
              content = RefreshIndicator(
                onRefresh: () => model.fetchProducts(context),
                child: content,
              );
            }
            return content;
        }
        return null;
      },
    );
  }
}
