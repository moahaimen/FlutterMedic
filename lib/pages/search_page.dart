import 'package:drugStore/components/product_list_item.dart';
import 'package:drugStore/localization/app_translation.dart';
import 'package:drugStore/models/brand.dart';
import 'package:drugStore/models/category.dart';
import 'package:drugStore/models/product.dart';
import 'package:drugStore/utils/http.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

enum SearchStatus { Clean, Waiting, Searching, NoResult, Result }

class SearchPage extends StatefulWidget {
  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  SearchStatus _status = SearchStatus.Clean;
  List<Product> _data;

  String name;
  Category category;
  Brand brand;

  Widget _buildSearchContent(BuildContext context) {
    final translator = AppTranslations.of(context);

    final filter =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic> ?? {};

    if (filter.containsKey('name')) {
      setState(() {
        this.name = filter['name'];
      });
    }

    if (filter.containsKey('category')) {
      setState(() {
        this.category = filter['category'] as Category;
      });
    }

    if (filter.containsKey('brand')) {
      setState(() {
        this.brand = filter['brand'] as Brand;
      });
    }

    switch (_status) {
      case SearchStatus.Clean:
        return Center(child: Text(translator.text("search")));
      case SearchStatus.Searching:
        return Center(child: CircularProgressIndicator());
      case SearchStatus.Waiting:
        startSearch();
        return Center(child: CircularProgressIndicator());
      case SearchStatus.NoResult:
        return Center(child: Text(translator.text("search_empty_result")));
      case SearchStatus.Result:
        final int columnCount = 2;
        return SingleChildScrollView(
          child: AnimationLimiter(
            child: GridView.count(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              childAspectRatio: 2 / 3,
              crossAxisCount: columnCount,
              children: List.generate(
                _data.length,
                (int index) {
                  return AnimationConfiguration.staggeredGrid(
                    position: index,
                    duration: const Duration(milliseconds: 375),
                    columnCount: columnCount,
                    child: ScaleAnimation(
                      child: FadeInAnimation(
                          child: ProductListItem(product: _data[index])),
                    ),
                  );
                },
              ),
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
          textInputAction: TextInputAction.search,
          onChanged: (String v) {
            setState(() {
              _status = SearchStatus.Clean;
              name = v;
            });
          },
          onEditingComplete: startSearch,
        ),
        actions: _getBarActions(),
      ),
      body: Container(child: _buildSearchContent(context)),
    );
  }

  List<Widget> _getBarActions() {
    final List<Widget> children = new List();

    if (category != null) {
      children.add(
        Chip(
          label: Text(category.getName(context)),
          backgroundColor: Colors.red,
          labelPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 12),
          labelStyle:
              Theme.of(context).textTheme.caption.copyWith(color: Colors.white),
        ),
      );
    }

    if (brand != null) {
      children.add(
        Chip(
          label: Text(brand.getName(context)),
          backgroundColor: Colors.orangeAccent,
          labelPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 12),
          labelStyle:
              Theme.of(context).textTheme.caption.copyWith(color: Colors.white),
        ),
      );
    }

    return children;
  }

  void startSearch() async {
    if (_status != SearchStatus.Clean) {
      return;
    }

    setState(() => _status = SearchStatus.Searching);

    final url = DotEnv().env['fetchProductsUrl'] + '?category_id=19';
    final Map<String, dynamic> params = new Map();

    if (name != null && name.length > 0) {
      if (AppTranslations.of(context).locale.languageCode == "en") {
        params['en_name'] = name;
      } else {
        params['ar_name'] = name;
      }
    }

    if (category != null) {
      final categoryId = category.id;
      params['category_id'] = categoryId;
    }

    if (brand != null) {
      final brandId = brand.id;
      params['brand_id'] = brandId;
    }

    print(params);

    final response = await Http.get(context, url, params: params);
    final data =
        List.from(response['data']).map((e) => Product.fromJson(e)).toList();

    _data = data;

    setState(() => _status = SearchStatus.Result);
  }
}
