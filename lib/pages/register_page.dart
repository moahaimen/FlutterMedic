import 'package:drugStore/components/auth/register_form.dart';
import 'package:drugStore/partials/app_router.dart';
import 'package:drugStore/partials/drawer.dart';
import 'package:drugStore/partials/toolbar.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerBuilder.build(context, AppRouter.register),
      appBar: Toolbar.get(title: AppRouter.register, context: context),
      body: Container(
        child: RegisterForm(),
      ),
    );
  }
}
