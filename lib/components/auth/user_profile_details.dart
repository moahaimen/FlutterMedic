import 'package:drugStore/components/auth/user_logout_dialogue.dart';
import 'package:drugStore/localization/app_translation.dart';
import 'package:drugStore/models/user.dart';
import 'package:drugStore/partials/app_router.dart';
import 'package:drugStore/utils/state.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:toast/toast.dart';

class UserProfileDetails extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final state = ScopedModel.of<StateModel>(context);
    final translator = AppTranslations.of(context);

    final User user = state.user;

    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: <Widget>[
        SliverAppBar(
          stretch: true,
          floating: true,
          snap: false,
          pinned: true,
          onStretchTrigger: () {
            state.refreshUser().then((value) {
              if (value != null) {
                Toast.show(translator.text("user_fetch_done"), context);
              } else {
                Toast.show(translator.text("user_fetch_failed"), context);
              }
            });
            return;
          },
          expandedHeight: 360.0,
          flexibleSpace: FlexibleSpaceBar(
            stretchModes: <StretchMode>[
              StretchMode.zoomBackground,
              StretchMode.blurBackground,
              StretchMode.fadeTitle,
            ],
            background: Center(
              child: Text(
                user.name,
                style: theme.textTheme.headline1,
              ),
            ),
          ),
          actions: [
            IconButton(
              padding: EdgeInsets.symmetric(horizontal: 12),
              onPressed: () => _gotoUserOrdersPage(context),
              icon: Icon(Icons.favorite),
              tooltip: translator.text('user_orders'),
            ),
          ],
        ),
        Directionality(
          textDirection: translator.locale.languageCode == 'en'
              ? TextDirection.ltr
              : TextDirection.rtl,
          child: SliverList(
            delegate: SliverChildListDelegate([
              _buildUserNameItem(context, user, translator.text('user_name')),
              _buildFirstNameItem(context, user, translator.text('first_name')),
              _buildLastNameItem(context, user, translator.text('last_name')),
              _buildEmailItem(context, user, translator.text('email_address')),
              _buildPhoneNumberItem(
                  context, user, translator.text('phone_number')),
              _buildProvinceItem(user, state, translator.text('province'),
                  translator.locale.languageCode, theme),
              _buildAddressItem(context, user, translator.text('address')),
              _buildUserOptions(context, translator),
            ]),
          ),
        ),
      ],
    );
  }

  Widget _buildUserNameItem(BuildContext context, User user, String title) {
    return Card(
      shadowColor: Colors.white30,
      margin: EdgeInsets.zero,
      color: Colors.white,
      child: ListTile(
        leading: Icon(
          Icons.clear_all,
          size: 25.0,
          color: Theme.of(context).primaryColorDark,
        ),
        title: Text(user.userName),
        subtitle: Text(title,
            style: TextStyle(
                color: Theme.of(context).accentColor, fontSize: 15.0)),
      ),
    );
  }

  Widget _buildFirstNameItem(BuildContext context, User user, String title) {
    return Card(
      shadowColor: Colors.white30,
      margin: EdgeInsets.zero,
      color: Colors.white,
      child: ListTile(
        leading: Icon(
          Icons.clear_all,
          size: 25.0,
          color: Theme.of(context).primaryColorDark,
        ),
        title: Text(user.firstName),
        subtitle: Text(title,
            style: TextStyle(
                color: Theme.of(context).accentColor, fontSize: 15.0)),
      ),
    );
  }

  Widget _buildLastNameItem(BuildContext context, User user, String title) {
    return Card(
      shadowColor: Colors.white30,
      margin: EdgeInsets.zero,
      color: Colors.white,
      child: ListTile(
        leading: Icon(
          Icons.clear_all,
          size: 25.0,
          color: Theme.of(context).primaryColorDark,
        ),
        title: Text(user.lastName),
        subtitle: Text(title,
            style: TextStyle(
                color: Theme.of(context).accentColor, fontSize: 15.0)),
      ),
    );
  }

  Widget _buildEmailItem(BuildContext context, User user, String title) {
    return Card(
      shadowColor: Colors.white30,
      margin: EdgeInsets.zero,
      color: Colors.white,
      child: ListTile(
        leading: Icon(
          Icons.clear_all,
          size: 25.0,
          color: Theme.of(context).primaryColorDark,
        ),
        title: Text(user.email),
        subtitle: Text(title,
            style: TextStyle(
                color: Theme.of(context).accentColor, fontSize: 15.0)),
      ),
    );
  }

  Widget _buildPhoneNumberItem(BuildContext context, User user, String title) {
    return Card(
      shadowColor: Colors.white30,
      margin: EdgeInsets.zero,
      color: Colors.white,
      child: ListTile(
        leading: Icon(
          Icons.clear_all,
          size: 25.0,
          color: Theme.of(context).primaryColorDark,
        ),
        title: Text(user.phoneNumber ?? '-'),
        subtitle: Text(title,
            style: TextStyle(
                color: Theme.of(context).accentColor, fontSize: 15.0)),
      ),
    );
  }

  Widget _buildProvinceItem(User user, StateModel state, String title,
      String locale, ThemeData theme) {
    final province = state.provinces
        .firstWhere((p) => p.id == user.provinceId, orElse: () => null);
    final provinceName = province != null ? province.getName(locale) : '-';

    return Card(
      shadowColor: Colors.white30,
      margin: EdgeInsets.zero,
      color: Colors.white,
      child: ListTile(
        leading: Icon(
          Icons.clear_all,
          size: 25.0,
          color: theme.primaryColorDark,
        ),
        title: Text(provinceName),
        subtitle: Text(title,
            style: TextStyle(color: theme.accentColor, fontSize: 15.0)),
      ),
    );
  }

  Widget _buildAddressItem(BuildContext context, User user, String title) {
    return Card(
      shadowColor: Colors.white30,
      margin: EdgeInsets.zero,
      color: Colors.white,
      child: ListTile(
        leading: Icon(
          Icons.clear_all,
          size: 25.0,
          color: Theme.of(context).primaryColorDark,
        ),
        title: Text(user.address ?? '-'),
        subtitle: Text(title,
            style: TextStyle(
                color: Theme.of(context).accentColor, fontSize: 15.0)),
      ),
    );
  }

  Widget _buildUserOptions(BuildContext context, AppTranslations translator) {
    return Container(
      alignment: Alignment.center,
      child: ButtonBar(
        alignment: MainAxisAlignment.center,
        children: [
          RaisedButton.icon(
            padding: EdgeInsets.symmetric(horizontal: 12),
            onPressed: () => _gotoUserEditPage(context),
            icon: Icon(Icons.edit),
            label: Text(translator.text('user_edit')),
          ),
          RaisedButton.icon(
            padding: EdgeInsets.symmetric(horizontal: 12),
            onPressed: () => _openLogoutDialogue(context),
            icon: Icon(Icons.logout),
            label: Text(translator.text('logout')),
          ),
        ],
      ),
    );
  }

  void _gotoUserOrdersPage(BuildContext context) {
    Navigator.of(context).pushNamed(AppRouter.userOrders);
  }

  void _gotoUserEditPage(BuildContext context) {
    Navigator.of(context).pushNamed(AppRouter.userProfileEdit);
  }

  void _openLogoutDialogue(BuildContext context) {
    UserLogoutDialogue.show(context);
  }
}
