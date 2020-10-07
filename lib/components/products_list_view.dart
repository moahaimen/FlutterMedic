import 'package:drugStore/localization/app_translation.dart';
import 'package:drugStore/models/brand.dart';
import 'package:drugStore/models/category.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:scoped_model/scoped_model.dart';

import '../models/product.dart';
import '../utils/state.dart';
import 'product_list_item.dart';

class ProductsListView extends StatefulWidget {
  static final int columnCount = 2;
  final Map<String, dynamic> filter;
  final ScrollPhysics physics;

  ProductsListView({@required this.filter, @required this.physics});

  @override
  State<StatefulWidget> createState() => _ProductsListViewState();
}

class _ProductsListViewState extends State<ProductsListView> {
  Widget _buildProductsList(
    BuildContext context,
    bool loading,
    List<Product> products,
    int take,
    void Function() loadMore, {
    Brand brand,
    Category category,
    String name,
  }) {
    if (loading) {
      return Center(child: CircularProgressIndicator());
    }

    if (products == null || products.length == 0) {
      return Center(
          child: Text(AppTranslations.of(context).text("products_list_empty")));
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
              element.enName.toLowerCase().contains(name.toLowerCase()) ||
              element.arName.toLowerCase().contains(name.toLowerCase()))
          .toList();
    }

    if (take < 0) {
      take = 15;
    } else if (take > products.length) {
      take = products.length;
    }
    products = products.take(take).toList();

    // Recheck  after filtering
    if (products.length == 0) {
      return Container(
        child: Center(
            child:
                Text(AppTranslations.of(context).text("products_list_empty"))),
      );
    }

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 5),
      physics: widget.physics,
      child: Column(
        children: [
          AnimationLimiter(
            child: GridView.count(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              childAspectRatio: 3 / 4,
              crossAxisCount: ProductsListView.columnCount,
              children: List.generate(
                products.length,
                (int index) => buildListItem(index, products[index]),
              ),
            ),
          ),
          Container(
            height: 100,
            child: Center(
              child: RaisedButton.icon(
                icon: Icon(Icons.search, color: Colors.white),
                label: Text('Load more', style: TextStyle(color: Colors.white)),
                onPressed: loadMore,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget buildListItem(int index, Product product) {
    return AnimationConfiguration.staggeredGrid(
      position: index,
      duration: const Duration(milliseconds: 375),
      columnCount: ProductsListView.columnCount,
      child: ScaleAnimation(
        child: FadeInAnimation(
          child: ProductListItem(product: product),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<StateModel>(
      builder: (BuildContext context, Widget child, StateModel model) {
        final list = _buildProductsList(
          context,
          model.productsLoading,
          model.products,
          model.take * 15,
          model.increaseTake,
          brand: widget.filter['brand'],
          category: widget.filter['category'],
          name: widget.filter['name'],
        );

        if (widget.filter.containsKey('home') &&
            widget.filter['home'] == true) {
          return list;
        }

        return RefreshIndicator(
          onRefresh: () {
            return model.fetchProducts();
          },
          child: list,
        );
      },
    );
  }
}
