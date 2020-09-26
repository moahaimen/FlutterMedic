import 'package:drugStore/localization/app_translation.dart';
import 'package:flutter/material.dart';

class CategorizedProductsTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final translator = AppTranslations.of(context);
    final theme = Theme.of(context);

    return Center(
      child: Text(
        translator.text("browse_our_products").toUpperCase(),
        style: theme.textTheme.headline2.copyWith(color: theme.accentColor),
      ),
    );
  }
}
