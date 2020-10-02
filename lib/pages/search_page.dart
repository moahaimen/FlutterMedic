import 'package:drugStore/components/product_list_item.dart';
import 'package:drugStore/localization/app_translation.dart';
import 'package:drugStore/models/brand.dart';
import 'package:drugStore/models/category.dart';
import 'package:drugStore/models/product.dart';
import 'package:drugStore/partials/router.dart';
import 'package:drugStore/utils/http.dart';
import 'package:drugStore/utils/state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:scoped_model/scoped_model.dart';

enum SearchStatus { Clean, Searching, NoResult, Result }

class SearchPage extends StatefulWidget {
  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  SearchStatus _status = SearchStatus.Clean;
  List<Product> _data;

  Map<String, dynamic> filter;

  Category category;
  Brand brand;

  @override
  void initState() {
    super.initState();

    if (!ScopedModel.of<StateModel>(context).ready) {
      Navigator.of(context).pushReplacementNamed(Router.index);
    }

    this.filter =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    this.applySearch();
  }

  Widget _buildSearchContent(BuildContext context) {
    final translator = AppTranslations.of(context);

    switch (_status) {
      case SearchStatus.Clean:
        Center(child: Text(translator.text("search")));
        break;
      case SearchStatus.Searching:
        return Center(child: CircularProgressIndicator());
      case SearchStatus.NoResult:
        return Center(child: Text(translator.text("search_empty_result")));
      case SearchStatus.Result:
        final int columnCount = 2;
        final List<Widget> children = [
          AnimationLimiter(
            child: GridView.count(
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
          )
        ];

        if (brand != null) {
          children.insert(
              0, Text('Products from brand ${brand.getName(context)}'));
        }

        if (category != null) {
          children.insert(
              0, Text('Products from category ${category.getName(context)}'));
        }

        return Column(children: children);
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
            onChanged: (String v) => this.filter['name'] = v,
            onEditingComplete: applySearch),
      ),
      body: Center(child: _buildSearchContent(context)),
    );
  }

  void applySearch() async {
    setState(() => _status = SearchStatus.Searching);

    final url = DotEnv().env['fetchProductsUrl'];

    final Map<String, dynamic> params = new Map();

    if (this.filter.containsKey('name')) {
      final name = this.filter['name'];

      params['en_name'] = name;
      params['ar_name'] = name;
    }

    if (this.filter.containsKey('category')) {
      final category = this.filter['category'] as Category;
      final categoryId = category.id;

      params['category_id'] = categoryId;
    }

    if (this.filter.containsKey('brand')) {
      final brand = this.filter['brand'] as Brand;
      final brandId = brand.id;

      params['brand_id'] = brandId;
    }

    final response = await Http.get(context, url) as List<dynamic>;
    final data = new List<Product>();

    response.forEach((e) => data.add(Product.fromJson(e)));

    _data = data;

    setState(() => _status = SearchStatus.Result);
  }
}
