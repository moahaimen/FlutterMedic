import 'package:drugStore/components/products_list_view.dart';
import 'package:drugStore/constants/colors.dart';
import 'package:drugStore/utils/state.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../localization/app_translation.dart';
import '../models/brand.dart';
import '../models/category.dart';

enum SearchStatus { Clean, Waiting, Searching, NoResult, Result }

class SearchPage extends StatefulWidget {
  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    final model = ScopedModel.of<StateModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          autofocus: true,
          textInputAction: TextInputAction.go,
          onChanged: (String v) => model.products.useFilter('name', v),
        ),
        actions: [
          IconButton(
              icon: Icon(Icons.info_outline),
              onPressed: () => _openFilterDetailsDialog(model))
        ],
      ),
      body: ProductsListView(mode: ProductsListViewMode.SEARCH),
    );
  }

  void _openFilterDetailsDialog(StateModel model) {
    final translator = AppTranslations.of(context);

    final filter = model.products.filter;

    final String title = translator.text('search');
    final String done = translator.text('ok');

    final List<Widget> children = [];

    if (filter['name'] != null && filter['name'].isNotEmpty) {
      children.add(Row(
        children: [Text('Name'), SizedBox(width: 15), Text(filter['name'])],
      ));
    }

    if (filter['brand'] != null) {
      children.add(Row(
        children: [
          Text('Brand'),
          SizedBox(width: 15),
          Text((filter['brand'] as Brand).enName)
        ],
      ));
    }

    if (filter['category'] != null) {
      children.add(Row(
        children: [
          Text('Category'),
          SizedBox(width: 15),
          Text((filter['category'] as Category).enName)
        ],
      ));
    }

    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Column(children: children, mainAxisSize: MainAxisSize.min),
        actions: [
          OutlineButton(
            child: Text(
              done,
              style: Theme.of(context)
                  .textTheme
                  .bodyText2
                  .copyWith(color: AppColors.accentColor),
            ),
            onPressed: () => Navigator.of(context).pop(),
          )
        ],
      ),
    );
  }
}
