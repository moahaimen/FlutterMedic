import 'package:drugStore/components/home_page_content.dart';
import 'package:drugStore/partials/app_bar.dart';
import 'package:flutter/material.dart';

import '../components/brands_list_view.dart';
import '../components/categories_list_view.dart';
import '../partials/drawer.dart';
import '../partials/router.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() {
    return HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  int _selectedIndex = 0;
  final PageController _pageController = PageController();

  String _appBarTitle = Router.home;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        key: _scaffoldKey,
        drawer: DrawerBuilder.build(context, Router.home),
        appBar: Toolbar.get(title: this._appBarTitle),
        body: Container(
          child: PageView(
            controller: _pageController,
            physics: BouncingScrollPhysics(),
            onPageChanged: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            children: <Widget>[
              BrandsListView(),
              HomePageContent(this._activateTab),
              CategoriesListView(),
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
          icon: Icon(Icons.branding_watermark),
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
      ],
      currentIndex: _selectedIndex,
      backgroundColor: Theme.of(context).primaryColorDark,
      selectedItemColor: Theme.of(context).accentColor,
      iconSize: 32.0,
      type: BottomNavigationBarType.shifting,
      onTap: (int index) => _pageController.jumpToPage(index),
    );
  }

  void _activateTab(int index) {
    setState(() {
      this._selectedIndex = index;
      this._pageController.jumpToPage(index);
    });
  }
}
