import 'package:drugStore/partials/router.dart';
import 'package:drugStore/utils/state.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

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
    _model.addListener(() {
      if (!_model.categoriesLoading &&
          !_model.brandsLoading &&
          !_model.productsLoading) {
        this.goto(Router.home);
      }
    });
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

  void goto(String url) {
    Navigator.of(context).pushReplacementNamed(url);
  }
}
