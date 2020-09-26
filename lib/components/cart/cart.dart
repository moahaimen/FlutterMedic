import 'package:drugStore/localization/app_translation.dart';
import 'package:flutter/material.dart';

import 'cart_steps_manager.dart';

class Cart extends StatelessWidget {
  Widget _getCartWidget(BuildContext context) {
    final translator = AppTranslations.of(context);

    return new Directionality(
      textDirection: translator.locale.languageCode == "en"
          ? TextDirection.ltr
          : TextDirection.rtl,
      child: Container(child: new CartStepsManager()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _getCartWidget(context);
  }
}
