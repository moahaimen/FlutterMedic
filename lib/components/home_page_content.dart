import 'package:carousel_pro/carousel_pro.dart';
import 'package:drugStore/localization/app_translation.dart';
import 'package:drugStore/pages/home_page.dart';
import 'package:drugStore/partials/router.dart';
import 'package:drugStore/ui/main_products_carousel.dart';
import 'package:drugStore/ui/brands_list_for_home.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../models/brand.dart';
import '../models/category.dart';
import '../utils/state.dart';
import 'categorized_products_list_view.dart';
import 'category_list_item.dart';

class HomePageContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<StateModel>(
      builder: (BuildContext context, Widget widget, StateModel model) {
        return ListView(
          children: [
            _buildLogoWidget(context),
            _buildBrandsWidget(context, model.brands),
            _buildMainProductsWidget(),
//            _buildMainProductsWidget(model.mainProducts),
            _buildCategoriesWidget(context, model.categories),
            _buildCategorizedProductsListView(),
          ],
        );
      },
    );
  }

  Widget _buildLogoWidget(BuildContext context) {
    return Container(
      height: 150.0,
      child: Carousel(
        images: ['assets/images/molar-2.png']
            .toList()
            .map((p) => Image.asset(p, fit: BoxFit.fitWidth))
            .toList(),
        dotSize: 5.0,
        dotSpacing: 15.0,
        dotColor: Theme.of(context).accentColor,
        indicatorBgPadding: 7.5,
        dotBgColor: Colors.transparent,
        borderRadius: true,
      ),
    );
  }

  Widget _buildMainProductsWidget() {
    return Container(
      color: Colors.transparent,
      padding: EdgeInsets.symmetric(vertical: 10),
      child: MainProductsCarousel(),
    );
  }

  Widget _buildCategorizedProductsListView() {
    return Container(
      color: Colors.transparent,
      padding: EdgeInsets.symmetric(vertical: 10),
      child: CategorizedProductsListView(),
    );
  }

  Widget _buildBrandsWidget(BuildContext context, List<Brand> brands) {
    return Container(
      height: 200.0,
      padding: EdgeInsets.symmetric(vertical: 10),
      color: Colors.white,
      child: BrandsListForHome(brands: brands),
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
              AppTranslations.of(context).text("see_all"),
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
