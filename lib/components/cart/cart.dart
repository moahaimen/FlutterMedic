import 'package:drugStore/localization/app_translation.dart';
import 'package:drugStore/utils/state.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import 'cart_steps_manager.dart';

class Cart extends StatelessWidget {
  Widget _getCartWidget(BuildContext context) {
    final translator = AppTranslations.of(context);

    return ScopedModelDescendant<StateModel>(
      builder: (context, child, model) => Directionality(
        textDirection: translator.locale.languageCode == "en"
            ? TextDirection.ltr
            : TextDirection.rtl,
        child: Container(child: CartStepsManager(model.order)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _getCartWidget(context);
  }
}
