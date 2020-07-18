import 'package:drugStore/partials/router.dart';
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
      body: new Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Center(
            child: CircularProgressIndicator(),
          )
        ],
      ),
    );
  }

  void _shouldWeGotoHome() {
    if (!_model.categoriesLoading &&
        !_model.brandsLoading &&
        !_model.productsLoading &&
        !_model.orderRestoring) {
      this.goto(Router.home);
    }
  }

  void goto(String url) {
    Navigator.pushReplacementNamed(context, url, arguments: PageId.Home);
  }
}
