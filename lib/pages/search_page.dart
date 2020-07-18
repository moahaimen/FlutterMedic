import 'package:drugStore/components/product_list_item.dart';
import 'package:drugStore/models/product.dart';
import 'package:drugStore/utils/state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:toast/toast.dart';

enum SearchStatus { Clean, Searching, NoResult, Result }

class SearchPage extends StatefulWidget {
  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  static SearchStatus _searchStatus = SearchStatus.Clean;
  static List<Product> _result;

  Widget _buildResultsList() {
    switch (_searchStatus) {
      case SearchStatus.Clean:
        Center(
          child: Text("Search"),
        );
        break;
      case SearchStatus.Searching:
        return Center(
          child: CircularProgressIndicator(),
        );
      case SearchStatus.NoResult:
        return Center(
          child: Text("No products matched the search key"),
        );
      case SearchStatus.Result:
        final int columnCount = 2;
        return AnimationLimiter(
          child: GridView.count(
            childAspectRatio: 2 / 3,
            crossAxisCount: columnCount,
            children: List.generate(
              _result.length,
              (int index) {
                return AnimationConfiguration.staggeredGrid(
                  position: index,
                  duration: const Duration(milliseconds: 375),
                  columnCount: columnCount,
                  child: ScaleAnimation(
                    child: FadeInAnimation(
                      child: ProductListItem(product: _result[index]),
                    ),
                  ),
                );
              },
            ),
          ),
        );
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          autofocus: true,
          textInputAction: TextInputAction.go,
          onSubmitted: search,
        ),
      ),
      body: Center(
        child: _buildResultsList(),
      ),
    );
  }

  void search(String value) {
    setState(() => _searchStatus = SearchStatus.Searching);

    final model = ScopedModel.of<StateModel>(context);
    var products = model.products;

    if (products == null || products.length == 0) {
      setState(() => _searchStatus = SearchStatus.NoResult);
      Toast.show('No results found', context);
      return;
    }

    if (value != null && value.isNotEmpty) {
      products = products
          .where((element) =>
              element.name.toLowerCase().contains(value.toLowerCase()))
          .toList();
    }

    // recheck
    if (products == null || products.length == 0) {
      setState(() => _searchStatus = SearchStatus.NoResult);
      Toast.show('No results found', context);
      return;
    }

    _result = products;
    setState(() => _searchStatus = SearchStatus.Result);
  }
}
