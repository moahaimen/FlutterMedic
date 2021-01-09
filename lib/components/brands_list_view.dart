import 'package:drugStore/localization/app_translation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:scoped_model/scoped_model.dart';

import '../models/brand.dart';
import '../utils/state.dart';
import 'brand_list_item.dart';

class BrandsListView extends StatelessWidget {
  final int _columnCount = 3;

  Widget _buildBrandsList(BuildContext context, bool loading,
      List<Brand> brands) {
    if (loading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    if (brands == null || brands.length == 0) {
      return Center(
        child: Text(AppTranslations.of(context).text("brands_list_empty")),
      );
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12),
      child: AnimationLimiter(
        child: GridView.count(
          crossAxisCount: _columnCount,
          childAspectRatio: 5 / 6,
          children: List.generate(
            brands.length,
                (int index) {
              return AnimationConfiguration.staggeredGrid(
                position: index,
                duration: const Duration(milliseconds: 375),
                columnCount: _columnCount,
                child: ScaleAnimation(
                  child: FadeInAnimation(
                    child: BrandListItem(brand: brands[index]),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<StateModel>(
      builder: (BuildContext context, Widget widget, StateModel model) {
        return RefreshIndicator(
          onRefresh: () {
            return model.fetchBrands();
          },
          child: _buildBrandsList(context, model.brandsLoading, model.brands),
        );
      },
    );
  }
}
