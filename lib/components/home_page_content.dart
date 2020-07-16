import 'package:drugStore/pages/home_page.dart';
import 'package:drugStore/partials/router.dart';
import 'package:drugStore/ui/carousel.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../models/brand.dart';
import '../models/category.dart';
import '../models/product.dart';
import '../utils/state.dart';
import 'brand_list_item.dart';
import 'category_list_item.dart';

class HomePageContent extends StatelessWidget {
  HomePageContent();

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<StateModel>(
      builder: (BuildContext context, Widget widget, StateModel model) {
        return ListView(
          shrinkWrap: true,
          children: [
            _buildMainProductsWidget(model.mainProducts),
            _buildTopFiveBrandsWidget(context, model.topBrands),
            _buildTopFiveCategoriesWidget(context, model.topCategories),
          ],
        );
      },
    );
  }

  Widget _buildMainProductsWidget(List<Product> products) {
    return Carousel();
  }

  Widget _buildTopFiveBrandsWidget(BuildContext context, List<Brand> brands) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          child: Row(
            children: [
              Text(
                "Top Brands",
                style: Theme
                    .of(context)
                    .textTheme
                    .headline5,
              ),
              Spacer(),
              IconButton(
                onPressed: () =>
                    Navigator.of(context).pushReplacementNamed(
                      Router.home,
                      arguments: PageId.Brands,
                    ),
                icon: Icon(Icons.chevron_right),
              ),
            ],
          ),
        ),
        Container(
          height: 150.0,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: brands
                .map<Widget>((e) => Container(
              width: 150,
              height: 150,
              child: BrandListItem(brand: e),
            ))
                .toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildTopFiveCategoriesWidget(BuildContext context,
      List<Category> categories) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          child: Row(
            children: [
              Text(
                "Top Categories",
                style: Theme
                    .of(context)
                    .textTheme
                    .headline5,
              ),
              Spacer(),
              IconButton(
                onPressed: () =>
                    Navigator.of(context).pushReplacementNamed(
                      Router.home,
                      arguments: PageId.Categories,
                    ),
                icon: Icon(Icons.chevron_right),
              ),
            ],
          ),
        ),
        Container(
          height: 150.0,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: categories
                .map<Widget>((e) => Container(
              width: 150,
              height: 150,
              child: CategoryListItem(category: e),
            ))
                .toList(),
          ),
        ),
      ],
    );
  }
}
