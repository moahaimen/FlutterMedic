import 'package:drugStore/localization/app_translation.dart';
import 'package:drugStore/models/pagination.dart';
import 'package:drugStore/utils/state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:scoped_model/scoped_model.dart';

import '../models/category.dart';
import 'category_list_item.dart';

class CategoriesListView extends StatelessWidget {
  final int _columnCount = 3;

  Widget _buildCategoriesList(BuildContext context, bool loading,
      List<Category> categories) {
    if (loading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    if (categories == null || categories.length == 0) {
      return Center(
        child: Text(AppTranslations.of(context).text("categories_list_empty")),
      );
    }

    return AnimationLimiter(
      child: GridView.count(
        crossAxisCount: _columnCount,
        children: List.generate(
          categories.length,
              (int index) {
            return AnimationConfiguration.staggeredGrid(
              position: index,
              duration: const Duration(milliseconds: 375),
              columnCount: _columnCount,
              child: ScaleAnimation(
                child: FadeInAnimation(
                  child: CategoryListItem(category: categories[index]),
                ),
              ),
            );
          },
        ),
      ),
    );

//    return ListView.builder(
//      itemBuilder: (BuildContext context, int index) => CategoryListItem(
//        category: categories[index],
//      ),
//      itemCount: categories.length,
//    );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<StateModel>(
      builder: (BuildContext context, Widget widget, StateModel model) {
        return RefreshIndicator(
          onRefresh: () {
            return model.fetchCategories(context);
          },
          child: _buildCategoriesList(
            context,
            model.categories.status == PaginationStatus.Loading,
            model.categories.data,
          ),
        );
      },
    );
  }
}
