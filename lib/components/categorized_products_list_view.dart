import 'package:drugStore/models/category.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../utils/state.dart';
import 'products_list_view.dart';

class CategorizedProductsListView extends StatefulWidget {
  @override
  _CategorizedProductsListViewState createState() =>
      _CategorizedProductsListViewState();
}

class _CategorizedProductsListViewState
    extends State<CategorizedProductsListView> {
  Category tapped;

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<StateModel>(
      builder: (BuildContext context, Widget widget, StateModel model) {
        if (model.categoriesLoading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        final categories = model.categories;
        final theme = Theme.of(context);

        return Container(
          color: Colors.white,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Text(
                  "browse our products".toUpperCase(),
                  style: theme.textTheme.headline2
                      .copyWith(color: theme.accentColor),
                ),
              ),
              Container(
                height: 50,
                color: Colors.white,
                child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: categories.length,
                    itemBuilder: (BuildContext context, int index) =>
                        FlatButton(
                            textColor: theme.accentColor,
                            child: Text(categories[index].name),
                            onPressed: () => setState(
                                () => this.tapped = categories[index]))),
              ),
              Container(
                color: Color(0xffefefef),
                child: ProductsListView(
                  filter: {'category': this.tapped, 'home': true},
                  physics: NeverScrollableScrollPhysics(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
