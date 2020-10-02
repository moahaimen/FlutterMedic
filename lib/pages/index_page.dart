import 'package:drugStore/partials/router.dart';
import 'package:drugStore/utils/state.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:toast/toast.dart';

import 'home_page.dart';

class IndexPage extends StatefulWidget {
  @override
  IndexPageState createState() => new IndexPageState();
}

class IndexPageState extends State<IndexPage> {
  StateModel model;

  @override
  Widget build(BuildContext context) {
    ScopedModel.of<StateModel>(context).fetchModelData(context).then((value) {
      Toast.show('app data loaded', context);
      Navigator.of(context)
          .pushReplacementNamed(Router.home, arguments: PageId.Home);
    });

    return Scaffold(
      body: new Stack(
        fit: StackFit.expand,
        children: <Widget>[Center(child: CircularProgressIndicator())],
      ),
    );
  }
}
