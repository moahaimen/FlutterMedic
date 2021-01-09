import 'package:drugStore/localization/app_translation.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../../utils/state.dart';
import 'cart_steps_manager.dart';

class Cart extends StatelessWidget {
  Widget _getCartWidget(BuildContext context, StateModel state) {
    final translator = AppTranslations.of(context);

    return new Directionality(
      textDirection: translator.locale.languageCode == "en"
          ? TextDirection.ltr
          : TextDirection.rtl,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: new CartStepsManager(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<StateModel>(
      builder: (BuildContext context, Widget child, StateModel model) {
        if (model.orderRestoring || model.provincesLoading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        return _getCartWidget(context, model);
      },
    );
  }
}
