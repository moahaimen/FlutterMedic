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
  String _title = 'Initializing...';

  @override
  void initState() {
    super.initState();

    ScopedModel
        .of<StateModel>(context)
        .messages
        .listen(setTitle, onDone: onDone);
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

  void setTitle(String title) {
    setState(() {
      this._title = title;
    });
  }

  void onDone() {
//    application.setLocale(_model.settings['locale']);
    Navigator.pushReplacementNamed(
      context,
      AppRouter.home,
      arguments: PageId.Home,
    );
  }
}
