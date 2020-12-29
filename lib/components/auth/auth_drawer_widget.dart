import 'package:drugStore/localization/app_translation.dart';
import 'package:drugStore/partials/app_router.dart';
import 'package:drugStore/utils/state.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class AuthDrawerWidget extends StatelessWidget {
  @override
  build(BuildContext context) {
    final theme = Theme.of(context);
    final translator = AppTranslations.of(context);

    return ScopedModelDescendant<StateModel>(
      builder: (BuildContext context, Widget child, StateModel model) {
        final content = model.userLoading || model.user == null
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  OutlineButton.icon(
                    icon: Icon(Icons.login_rounded, color: theme.accentColor),
                    label: Text(
                      translator.text('login'),
                      style: theme.textTheme.bodyText2,
                    ),
                    onPressed: () => Navigator.of(context)
                        .pushReplacementNamed(AppRouter.login),
                  ),
                  SizedBox(width: 6),
                  OutlineButton.icon(
                    icon: Icon(
                      Icons.app_registration,
                      color: theme.accentColor,
                    ),
                    label: Text(translator.text('register'),
                        style: theme.textTheme.bodyText2),
                    onPressed: () => Navigator.of(context)
                        .pushReplacementNamed(AppRouter.register),
                  ),
                ],
              )
            : Center(
                child: OutlineButton.icon(
                  icon: Icon(
                    Icons.account_box,
                    color: theme.accentColor,
                  ),
                  label: Text(translator.text('user_account'),
                      style: theme.textTheme.bodyText2),
                  onPressed: () => Navigator.of(context)
                      .pushReplacementNamed(AppRouter.userProfile),
                ),
              );

        return Container(
            padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            child: content);
      },
    );
  }
}
