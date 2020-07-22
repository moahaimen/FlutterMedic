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
  @override
  Widget build(BuildContext context) {
    final String title = "drugsStore";
    final StateModel state = new StateModel();

    return ScopedModel<StateModel>(
      model: state,
      child: MaterialApp(
        title: title,
        theme: ThemeBuilder.getTheme(),
        initialRoute: Router.index,
        routes: Router.routes(),
        onGenerateRoute: Router.onGenerateRoute,
        onUnknownRoute: Router.onUnknownRoute,
      ),
    );
  }
}
