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
  final void Function(int index) gotoTab;

  HomePageContent(this.gotoTab);

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<StateModel>(
      builder: (BuildContext context, Widget widget, StateModel model) {
        return RefreshIndicator(
          onRefresh: () {
            return model.fetchProducts();
          },
          child: ListView(
            children: [
              _buildMainProductsWidget(model.mainProducts),
              _buildTopFiveBrandsWidget(context, model.topBrands),
              _buildTopFiveCategoriesWidget(model.topCategories),
            ],
          ),
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
        Row(
          children: [
            Text(
              "Top Brands",
//              style: Theme.of(context).textTheme.headline1,
            ),
            Spacer(),
            IconButton(
              onPressed: () => this.gotoTab(0),
              icon: Icon(Icons.expand_more),
//              label: Text("See more"),
            ),
          ],
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

  Widget _buildTopFiveCategoriesWidget(List<Category> categories) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              "Top Categories",
            ),
            Spacer(),
            IconButton(
              onPressed: () => this.gotoTab(2),
              icon: Icon(Icons.expand_more),
//              label: Text("See more"),
            ),
          ],
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
