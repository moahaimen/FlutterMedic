import 'package:drugStore/components/auth/login_form.dart';
import 'package:drugStore/partials/app_router.dart';
import 'package:drugStore/partials/drawer.dart';
import 'package:drugStore/partials/toolbar.dart';
import 'package:flutter/material.dart';

enum LoginPageMode { Login, LoginThenNavigate }

class LoginPage extends StatelessWidget {
  final LoginPageMode mode;

  LoginPage(this.mode);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerBuilder.build(context, AppRouter.login),
      appBar: Toolbar.get(title: AppRouter.login, context: context),
      body: Container(
        child: LoginForm(this.mode),
      ),
    );
  }
}
