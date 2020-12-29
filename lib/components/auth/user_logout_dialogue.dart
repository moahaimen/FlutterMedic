import 'package:drugStore/localization/app_translation.dart';
import 'package:drugStore/models/user.dart';
import 'package:drugStore/utils/state.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:toast/toast.dart';

class UserLogoutDialogue {
  static void show(BuildContext context) {
    final translator = AppTranslations.of(context);
    final state = ScopedModel.of<StateModel>(context);

    final User user = state.user;

    showDialog(
        context: context,
        builder: (BuildContext context) => SimpleDialog(
              title: Icon(
                Icons.logout,
                size: 45,
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
              children: [
                Text(
                  "${user.firstName}, ${translator.text('logout_message')}",
                  style: TextStyle(
                      color: Theme.of(context).primaryColorDark,
                      fontSize: 20,
                      fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 12),
                OutlineButton(
                  child: Text(translator.text('sure')),
                  onPressed: () => logout(context, state),
                )
              ],
            ));
  }

  static logout(BuildContext context, StateModel state) async {
    final ok = await state.logout();
    if (ok) {
      Toast.show(
          AppTranslations.of(context).text('logout_done_message'), context);
      Navigator.of(context).pop();
    }
  }
}
