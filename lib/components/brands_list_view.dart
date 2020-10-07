import 'package:drugStore/localization/app_translation.dart';
import 'package:drugStore/models/pagination.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:scoped_model/scoped_model.dart';

import '../models/brand.dart';
import '../utils/state.dart';
import 'brand_list_item.dart';

class BrandsListView extends StatelessWidget {
  final int _columnCount = 3;

  Widget _buildBrandsList(BuildContext context, bool loading,
      List<Brand> brands, Function loadMore) {
    if (loading) {
      return Container(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (brands == null || brands.length == 0) {
      return Container(
        child: GestureDetector(
          child: Center(
              child:
                  Text(AppTranslations.of(context).text("brands_list_empty"))),
          onTap: () => loadMore(
            context,
            dialog: true,
          ),
        ),
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
            (int index) => _generateBrandItem(index, brands[index]),
          ),
        ),
      ),
    );
  }

  Widget _generateBrandItem(int index, Brand brand) {
    return AnimationConfiguration.staggeredGrid(
      position: index,
      duration: const Duration(milliseconds: 375),
      columnCount: _columnCount,
      child: ScaleAnimation(
        child: FadeInAnimation(
          child: BrandListItem(brand: brand),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<StateModel>(
      builder: (BuildContext context, Widget widget, StateModel model) =>
          RefreshIndicator(
        onRefresh: () {
          return model.fetchBrands(context);
        },
        child: _buildBrandsList(
            context,
            model.brands.status == PaginationStatus.Loading,
            model.brands.data,
            model.brands.load),
      ),
    );
  }
}
