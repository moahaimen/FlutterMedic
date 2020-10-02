import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../localization/app_translation.dart';
import '../pages/home_page.dart';
import '../partials/router.dart';
import '../ui/brands_list_for_home.dart';
import '../ui/main_products_carousel.dart';
import '../utils/state.dart';
import 'category_list_item.dart';
import 'categorized_products/categorized_products_component.dart';

class HomePageContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<StateModel>(
      builder: (BuildContext context, Widget widget, StateModel model) {
        return SingleChildScrollView(
          child: Column(
            children: [
              _buildLogoWidget(context),
              _buildBrandsWidget(context),
              _buildMainProductsWidget(),
//            _buildMainProductsWidget(model.mainProducts),
              _buildCategoriesWidget(context, model),
              _buildCategorizedProductsListView(),
            ],
          ),
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
      child: CategorizedProductsComponent(),
    );
  }

  Widget _buildBrandsWidget(BuildContext context) {
    return Container(
      height: 200.0,
      padding: EdgeInsets.symmetric(vertical: 10),
      color: Colors.white,
      child: BrandsListForHome(),
    );
  }

  Widget _buildCategoriesWidget(BuildContext context, StateModel model) {
    return Container(
      color: Colors.white,
      height: 150.0,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: model.categories.data.length + 1,
        itemBuilder: (BuildContext context, int index) => Container(
            width: 100,
            height: 100,
            child: index == 0
                ? _buildCategoryAllWidget(context)
                : CategoryListItem(category: model.categories.data[index - 1])),
      ),
    );
  }

  Widget _buildCategoryAllWidget(BuildContext context) {
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
