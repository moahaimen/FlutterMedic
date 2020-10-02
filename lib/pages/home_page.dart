import 'package:drugStore/components/cart/cart.dart';
import 'package:drugStore/components/home_page_content.dart';
import 'package:drugStore/localization/app_translation.dart';
import 'package:drugStore/partials/toolbar.dart';
import 'package:drugStore/utils/push_notifications_manager.dart';
import 'package:drugStore/utils/state.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../components/brands_list_view.dart';
import '../components/categories_list_view.dart';
import '../partials/drawer.dart';
import '../partials/router.dart';

enum PageId { Brands, Home, Categories, Cart }

class _Page {
  PageId id;

  _Page(this.id);

  String getTitle(BuildContext context) {
    final tt = AppTranslations.of(context);

    switch (this.id) {
      case PageId.Home:
        return tt.text('home');
      case PageId.Brands:
        return tt.text('brands');
      case PageId.Categories:
        return tt.text('categories');
      case PageId.Cart:
        return tt.text('cart');
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
  void initState() {
    super.initState();

    if (!ScopedModel.of<StateModel>(context).ready) {
      Navigator.of(context).pushReplacementNamed(Router.index);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Initializing PCM
    PushNotificationsManager.initialize(context);

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        key: _scaffold,
        drawer: DrawerBuilder.build(context, Router.home),
        appBar:
            Toolbar.get(title: this._page.getTitle(context), context: context),
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
    final tt = AppTranslations.of(context);

    return BottomNavigationBar(
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.account_balance),
          title: Text(tt.text("brands")),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          title: Text(tt.text("home")),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.widgets),
          title: Text(tt.text("categories")),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_cart),
          title: Text(tt.text("cart")),
        ),
      ],
      currentIndex: _page.id.index,
      iconSize: 32.0,
      type: BottomNavigationBarType.fixed,
      onTap: (int index) => _pageController.jumpToPage(index),
    );
  }
}
