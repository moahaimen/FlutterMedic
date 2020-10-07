import 'package:drugStore/components/products_list_view.dart';
import 'package:drugStore/localization/app_translation.dart';
import 'package:flutter/material.dart';

enum SearchStatus { Clean, Searching, NoResult, Result }

class SearchPage extends StatefulWidget {
  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  SearchStatus _searchStatus = SearchStatus.Clean;
  String name;

  Widget _buildResultsList(BuildContext context) {
    final translator = AppTranslations.of(context);

    switch (_searchStatus) {
      case SearchStatus.Clean:
        Center(
          child: Text(translator.text("search")),
        );
        break;
      case SearchStatus.Searching:
        return Center(
          child: CircularProgressIndicator(),
        );
      case SearchStatus.NoResult:
        return Center(
          child: Text(translator.text("search_empty_result")),
        );
      case SearchStatus.Result:
        return ProductsListView(
            filter: {'name': name}, physics: AlwaysScrollableScrollPhysics());
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
      body: Center(child: _buildResultsList(context)),
    );
  }

  void search(String value) {
    setState(() {
      _searchStatus = SearchStatus.Searching;
      this.name = value;
      _searchStatus = SearchStatus.Result;
    });
  }
}
