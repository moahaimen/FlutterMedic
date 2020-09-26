import 'package:drugStore/localization/application.dart';
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
  StateModel model;

  @override
  void initState() {
    super.initState();

    this.model = ScopedModel.of<StateModel>(context);
    this.model.addListener(_shouldGoToHome);
  }

  @override
  void dispose() {
    super.dispose();

    this.model.removeListener(_shouldGoToHome);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: new Stack(
        fit: StackFit.expand,
        children: <Widget>[Center(child: CircularProgressIndicator())],
      ),
    );
  }

  void _shouldGoToHome() {
    if (this.model.fetching) {
      return;
    }

    application.setLocale(model.settings.data['locale']);
    Navigator.pushReplacementNamed(context, Router.home,
        arguments: PageId.Home);
  }
}
