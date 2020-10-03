import 'package:drugStore/localization/app_translation.dart';
import 'package:drugStore/models/category.dart';
import 'package:drugStore/models/pagination.dart';
import 'package:drugStore/partials/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:scoped_model/scoped_model.dart';

import '../models/product.dart';
import '../utils/state.dart';
import 'product_list_item.dart';

class ProductsListView extends StatelessWidget {
  final int _columnCount = 2;

  final ScrollPhysics physics;
  final ScrollController _controller = new ScrollController();

  ProductsListView({@required this.physics});

  Widget _buildProductsList(
      BuildContext context, Pagination<Product> obj, Category category) {
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

    if (category != null) {
      products =
          products.where((element) => element.category.id == category.id);
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5),
      child: SingleChildScrollView(
        physics: physics,
        child: Column(
          children: [
            AnimationLimiter(
              child: GridView.count(
                controller: _controller,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
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
              child: obj.status == PaginationStatus.Loading
                  ? new Align(
                      child: new Container(
                        child: Center(
                          child: new CircularProgressIndicator(),
                        ),
                      ),
                      alignment: FractionalOffset.center)
                  : new Align(
                      child: new Container(
                        child: new OutlineButton(
                          onPressed: () => obj.fetchNextPage(context),
                          child: Text(
                              AppTranslations.of(context).text('load_more')),
                        ),
                      ),
                      alignment: FractionalOffset.center),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<StateModel>(
      builder: (BuildContext context, Widget widget, StateModel model) {
        final settings = ModalRoute.of(context).settings;

        Widget content = _buildProductsList(
            context, model.products, model.categories.selected);

        if (settings.name == Router.products) {
          content = RefreshIndicator(
            onRefresh: () => model.fetchProducts(context),
            child: content,
          );
        }
        return content;
      },
    );
  }
}
