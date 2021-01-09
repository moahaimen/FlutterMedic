import 'package:drugStore/localization/app_translation.dart';
import 'package:flutter/material.dart';

class UserOrdersListEmpty extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final double deviceWidth = MediaQuery.of(context).size.width;
    final double targetWidth = deviceWidth > 550.0 ? 500.0 : deviceWidth * .80;

    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.hourglass_empty_rounded,
            size: 55,
            color: theme.primaryColorDark,
          ),
          Container(
            padding: EdgeInsets.only(top: 15),
            width: targetWidth,
            child: Text(
              AppTranslations.of(context).text('user_orders_empty'),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headline3,
            ),
          ),
        ],
      ),
    );
  }
}
