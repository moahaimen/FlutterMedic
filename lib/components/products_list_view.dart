import 'package:drugStore/localization/app_translation.dart';
import 'package:drugStore/models/pagination.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:scoped_model/scoped_model.dart';

import '../models/product.dart';
import '../utils/state.dart';
import 'product_list_item.dart';

enum ProductsListViewMode { SEARCH, PAGE, CATEGORIES }

typedef Future<void> LoadMoreMethod(
  BuildContext context, {
  Map<String, dynamic> filter,
  bool notify,
  bool status,
  bool dialog,
});

class ProductsListView extends StatefulWidget {
  final ProductsListViewMode mode;

  ProductsListView({@required this.mode});

  @override
  State<StatefulWidget> createState() {
    return new _ProductsListViewState(mode: this.mode);
  }
}

class _ProductsListViewState extends State<ProductsListView> {
  static final int columnCount = 2;

  static ScrollPhysics getPhysics(ProductsListViewMode mode) {
    switch (mode) {
      case ProductsListViewMode.SEARCH:
        return AlwaysScrollableScrollPhysics();
      case ProductsListViewMode.PAGE:
        return AlwaysScrollableScrollPhysics();
      case ProductsListViewMode.CATEGORIES:
        return NeverScrollableScrollPhysics();
    }
    return null;
  }

  static List<Product> getProductsList(SelectablePagination<Product> obj) {
    assert(obj != null);

    final products = obj.data;

    if (products == null || products.isEmpty) {
      return new List();
    } else {
      return obj.data;
    }
  }

  static Widget getProductWidget(int index, Product item) {
    return AnimationConfiguration.staggeredGrid(
      position: index,
      duration: const Duration(milliseconds: 375),
      columnCount: columnCount,
      child: ScaleAnimation(
        child: FadeInAnimation(
          child: ProductListItem(product: item),
        ),
      ),
    );
  }

  Widget getProductsWidget(
      BuildContext context, List<Product> data, LoadMoreMethod loadMore) {
    assert(context != null);
    assert(data != null);
    assert(loadMore != null);

    if (data.length == 0) {
      final translator = AppTranslations.of(context);

      return new Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(translator.text('products_list_empty')),
            FlatButton(
              child: Text('refresh'),
              onPressed: () => loadMore(context, dialog: false),
            ),
          ],
        ),
      );
    } else {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 5),
        child: SingleChildScrollView(
          physics: physics,
          child: Column(
            children: [
              AnimationLimiter(
                child: GridView.count(
                  controller: scrollController,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  childAspectRatio: 3 / 4,
                  crossAxisCount: columnCount,
                  children: List.generate(
                    data.length,
                    (int i) => getProductWidget(i, data[i]),
                    growable: true,
                  ),
                ),
              ),
              Center(
                child: OutlineButton(
                  onPressed: () => loadMore(context, dialog: true),
                  child: Text(AppTranslations.of(context).text('load_more')),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }

  Widget _buildContent(
      BuildContext context, SelectablePagination<Product> obj) {
    switch (obj.status) {
      case PaginationStatus.Null:
      // throw new Exception('Pagination of products is null');
      // obj.load(context);
      // return new Center(child: CircularProgressIndicator());
      case PaginationStatus.Loading:
      case PaginationStatus.Ready:
        return getProductsWidget(context, getProductsList(obj), obj.loadNext);
    }
    throw new Exception('Unknown status at Pagination of Products');
  }

  final ScrollController scrollController;
  final ScrollPhysics physics;
  final ProductsListViewMode mode;

  StateModel stateModel;

  _ProductsListViewState({@required this.mode})
      : physics = getPhysics(mode),
        scrollController = new ScrollController();

  @override
  void dispose() {
    this.stateModel.products.clearFilter();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<StateModel>(
      builder: (BuildContext context, Widget widget, StateModel model) {
        this.stateModel = model;
        final Widget list = _buildContent(context, model.products);

        switch (mode) {
          case ProductsListViewMode.SEARCH:
          case ProductsListViewMode.CATEGORIES:
            return list;
          case ProductsListViewMode.PAGE:
            return RefreshIndicator(
                onRefresh: () => model.fetchProducts(context), child: list);
        }
        throw new Exception('Unknow mode at Products List View');
      },
    );
  }
}
