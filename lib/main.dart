import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:scoped_model/scoped_model.dart';

import 'partials/router.dart';
import 'partials/theme.dart';
import 'utils/state.dart';

void main() async {
  await DotEnv().load('assets/.env');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final String appTitle = "medicalProductsStore";

  @override
  Widget build(BuildContext context) {
    final state = StateModel();
    final app = MaterialApp(
      title: this.appTitle,
      theme: ThemeBuilder.getTheme(),
      initialRoute: Router.index,
      routes: Router.routes(),
      onGenerateRoute: Router.onGenerateRoute,
      onUnknownRoute: Router.onUnknownRoute,
    );

    return ScopedModel(
      model: state,
      child: app,
    );
  }
}
