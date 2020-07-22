import 'package:drugStore/components/cart.dart';
import 'package:drugStore/components/home_page_content.dart';
import 'package:drugStore/partials/toolbar.dart';
import 'package:drugStore/utils/push_notifications_manager.dart';
import 'package:flutter/material.dart';

import '../components/brands_list_view.dart';
import '../components/categories_list_view.dart';
import '../partials/drawer.dart';
import '../partials/router.dart';

enum PageId { Brands, Home, Categories, Cart }

class _Page {
  PageId id;

  _Page(this.id);

  String get title {
    switch (this.id) {
      case PageId.Home:
        return 'Home';
      case PageId.Brands:
        return 'Brands';
      case PageId.Categories:
        return 'Categories';
      case PageId.Cart:
        return 'Cart';
    }
    return '';
  }
}

class HomePage extends StatefulWidget {
  final PageId id;

  HomePage({@required this.id});

  @override
  State<HomePage> createState() => HomePageState(id: this.id);
}

class HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffold = new GlobalKey<ScaffoldState>();
  final PageController _pageController;
  final _Page _page;

  HomePageState({PageId id})
      : _page = new _Page(id),
        _pageController = PageController(initialPage: id.index);

  @override
  Widget build(BuildContext context) {
    // Initializing PCM
    PushNotificationsManager.initialize(context);

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        key: _scaffold,
        drawer: DrawerBuilder.build(context, Router.home),
        appBar: Toolbar.get(title: this._page.title, context: context),
        body: Container(
          child: PageView(
            controller: _pageController,
            physics: PageScrollPhysics(),
            onPageChanged: (index) =>
                setState(() => _page.id = PageId.values[index]),
            children: <Widget>[
              BrandsListView(),
              HomePageContent(),
              CategoriesListView(),
              Cart(),
            ],
          ),
        ),
        bottomNavigationBar: _buildBottomNavigationBar(),
      ),
    );
  }

  BottomNavigationBar _buildBottomNavigationBar() {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.account_balance),
          title: Text("Brands"),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          title: Text("Home"),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.widgets),
          title: Text("Categories"),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_cart),
          title: Text("Cart"),
        ),
      ],
      currentIndex: _page.id.index,
      iconSize: 32.0,
      type: BottomNavigationBarType.fixed,
      onTap: (int index) => _pageController.jumpToPage(index),
    );
  }
}
