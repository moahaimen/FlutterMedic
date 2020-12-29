import 'package:drugStore/components/auth/user_profile_details.dart';
import 'package:drugStore/partials/app_router.dart';
import 'package:drugStore/partials/drawer.dart';
import 'package:flutter/material.dart';

class UserProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerBuilder.build(context, AppRouter.userOrders),
      body: Container(
        child: UserProfileDetails(),
      ),
    );
  }
}
