import 'package:drugStore/localization/app_translation.dart';
import 'package:drugStore/models/user.dart';
import 'package:drugStore/partials/app_router.dart';
import 'package:drugStore/utils/state.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:toast/toast.dart';

class UserLogoutDialogue {
  static void show(BuildContext context) {
    final theme = Theme.of(context);
    final translator = AppTranslations.of(context);

    showDialog(
      context: context,
      builder: (BuildContext context) => ScopedModelDescendant<StateModel>(
        builder: (context, child, model) {
          final User user = model.user;

          return SimpleDialog(
            contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
            title: Text(
              (user?.name ?? '').toUpperCase(),
              style: theme.textTheme.headline6,
            ),
            children: [
              Text(
                translator.text('logout_message'),
                style: theme.textTheme.bodyText2,
              ),
              SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: model.userLoading
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : RaisedButton(
                            child: Text(
                              translator.text('sure'),
                            ),
                            textColor: theme.colorScheme.primary,
                            onPressed: () => logout(context, model),
                          ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: OutlineButton(
                      child: Text(
                        translator.text('cancel'),
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  static logout(BuildContext context, StateModel state) async {
    final ok = await state.logout();
    if (ok) {
      Navigator.of(context)
          .pushNamedAndRemoveUntil(AppRouter.home, (route) => false);
      Toast.show(
          AppTranslations.of(context).text('logout_done_message'), context);
    }
  }
}
