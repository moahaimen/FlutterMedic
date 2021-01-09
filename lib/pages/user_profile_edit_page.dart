import 'package:drugStore/components/auth/user_profile_form.dart';
import 'package:drugStore/partials/app_router.dart';
import 'package:drugStore/partials/drawer.dart';
import 'package:drugStore/partials/toolbar.dart';
import 'package:flutter/material.dart';

class UserProfileEditPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Toolbar.get(title: AppRouter.userOrders, context: context),
      drawer: DrawerBuilder.build(context, AppRouter.userOrders),
      body: Container(
        child: UserProfileForm(),
      ),
    );
  }
}
