import 'package:drugStore/localization/application.dart';
import 'package:drugStore/partials/app_router.dart';
import 'package:drugStore/utils/state.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import 'home_page.dart';

class IndexPage extends StatefulWidget {
  @override
  IndexPageState createState() => new IndexPageState();
}

class IndexPageState extends State<IndexPage> {
  StateModel _model;

  @override
  void initState() {
    super.initState();

    _model = ScopedModel.of<StateModel>(context);
    _model.addListener(_shouldWeGotoHome);
  }

  @override
  void dispose() {
    super.dispose();

    _model.removeListener(_shouldWeGotoHome);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 10),
            Text(_title),
          ],
        ),
      ),
    );
  }

  void _shouldWeGotoHome() {
    if (!_model.categoriesLoading &&
        !_model.brandsLoading &&
        !_model.productsLoading &&
        !_model.userLoading &&
        !_model.settingsLoading &&
        !_model.exchangeLoading &&
        !_model.contactUsLoading &&
        !_model.orderRestoring) {
      application.setLocale(_model.settings['locale']);
      Navigator.pushReplacementNamed(
        context,
        AppRouter.home,
        arguments: PageId.Home,
      );
    }
  }

  String get _title {
    if (_model.userLoading) {
      return 'Loading user data...';
    } else if (_model.provincesLoading) {
      return 'Loading provinces information...';
    } else if (_model.contactUsLoading) {
      return 'Loading contact information...';
    } else if (_model.settingsLoading) {
      return 'Loading user settings...';
    } else if (_model.brandsLoading) {
      return 'Loading brands information...';
    } else if (_model.categoriesLoading) {
      return 'Loading categories information...';
    } else if (_model.exchangeLoading) {
      return 'Loading last currency exchange...';
    } else if (_model.productsLoading) {
      return 'Loading product information...';
    } else if (_model.orderRestoring) {
      return 'Loading stored order...';
    } else {
      return 'Initializing...';
    }
  }
}
