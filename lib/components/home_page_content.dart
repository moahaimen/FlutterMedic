import 'package:drugStore/components/brand_list_home_item.dart';
import 'package:drugStore/pages/home_page.dart';
import 'package:drugStore/partials/router.dart';
import 'package:drugStore/ui/main_products_carousel.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../models/brand.dart';
import '../models/category.dart';
import '../utils/state.dart';
import 'brand_list_item.dart';
import 'categorized_products_list_view.dart';
import 'category_list_item.dart';

class HomePageContent extends StatelessWidget {
  HomePageContent();

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<StateModel>(
      builder: (BuildContext context, Widget widget, StateModel model) {
        return ListView(
          children: [
            _buildMainProductsWidget(),
            SizedBox(
              height: 10,
            ),
            _buildBrandsWidget(context, model.brands),
//            SizedBox(
//              height: 10,
//            ),
//            _buildMainProductsWidget(model.mainProducts),
            SizedBox(
              height: 10,
            ),
            _buildCategoriesWidget(context, model.categories),
            SizedBox(
              height: 10,
            ),
            CategorizedProductsListView(),
          ],
        );
      },
    );
  }

  Widget _buildMainProductsWidget() {
    return MainProductsCarousel();
  }

  Widget _buildBrandsWidget(BuildContext context, List<Brand> brands) {
    return Container(
      height: 200.0,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children:
            brands.map<Widget>((e) => BrandListHomeItem(brand: e)).toList(),
      ),
    );
  }

  Widget _buildCategoriesWidget(
      BuildContext context, List<Category> categories) {
    return Container(
      color: Colors.white,
      height: 150.0,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length + 1,
        itemBuilder: (BuildContext context, int index) => Container(
          width: 100,
          height: 100,
          child: index == 0
              ? _buildWatchAllCategoriesWidget(context)
              : CategoryListItem(category: categories[index - 1]),
        ),
      ),
    );
  }

  Widget _buildWatchAllCategoriesWidget(BuildContext context) {
    return GestureDetector(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: Icon(Icons.menu, size: 39),
            ),
            Text(
              "Watch All",
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
      onTap: () => Navigator.of(context).pushReplacementNamed(
        Router.home,
        arguments: PageId.Categories,
      ),
    );
  }
}
