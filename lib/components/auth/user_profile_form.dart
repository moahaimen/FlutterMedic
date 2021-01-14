import 'package:drugStore/localization/app_translation.dart';
import 'package:drugStore/partials/app_router.dart';
import 'package:drugStore/ui/custom_form_field.dart';
import 'package:drugStore/ui/custom_province_form_field.dart';
import 'package:drugStore/utils/state.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:toast/toast.dart';

import 'form_caption_widget.dart';

class UserProfileForm extends StatelessWidget {
  final Map<String, dynamic> _data = {};
  final GlobalKey<FormState> _form = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final translator = AppTranslations.of(context);

    final double deviceWidth = MediaQuery.of(context).size.width;
    final double targetWidth = deviceWidth > 550.0 ? 500.0 : deviceWidth * .95;
    final double paddingWidth = deviceWidth - targetWidth;

    final state = ScopedModel.of<StateModel>(context);

    return Directionality(
      textDirection: translator.locale.languageCode == 'en'
          ? TextDirection.ltr
          : TextDirection.rtl,
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: paddingWidth, vertical: 10),
          child: Form(
            key: _form,
            child: Column(
              children: <Widget>[
                FormCaptionWidget(
                  assetName: "assets/images/logo.jpg",
                  caption: translator.text('edit_user'),
                  targetWidth: targetWidth * .15,
                ),
                // UserName
                CustomFormField(
                  title: translator.text('user_name'),
                  initialValue: state.user.userName,
                  onSave: (value) => _data['user_name'] = value,
                  onChanged: (value) => _data['user_name'] = value,
                  validator: (String email) {
                    if (email.isEmpty) {
                      return "User name is required field";
                    }
                    return null;
                  },
                  color: theme.accentColor,
                  enabled: false,
                ),
                // FirstName
                CustomFormField(
                  title: translator.text('first_name'),
                  initialValue: state.user.firstName,
                  onSave: (value) => _data['first_name'] = value,
                  onChanged: (value) => _data['first_name'] = value,
                  validator: (String firstName) {
                    if (firstName.isEmpty) {
                      return "First name is required field";
                    }
                    return null;
                  },
                  color: theme.accentColor,
                ),
                // LastName
                CustomFormField(
                  title: translator.text('last_name'),
                  initialValue: state.user.lastName,
                  onSave: (value) => _data['last_name'] = value,
                  onChanged: (value) => _data['last_name'] = value,
                  validator: (String lastName) {
                    if (lastName.isEmpty) {
                      return "Last name is required field";
                    }
                    return null;
                  },
                  color: theme.accentColor,
                ),
                // Email
                CustomFormField(
                  title: translator.text('email_address'),
                  initialValue: state.user.email,
                  onSave: (value) => _data['email'] = value,
                  onChanged: (value) => _data['email'] = value,
                  validator: (String email) {
                    if (email.isEmpty) {
                      return "Email is required field";
                    }
                    if (!RegExp(
                            r'([A-Za-z]+[A-Za-z0-9]+)(@)([A-Za-z]+).([A-Za-z0-9]+)')
                        .hasMatch(email)) {
                      return "Email must be in a valid format";
                    }
                    return null;
                  },
                  color: theme.accentColor,
                  enabled: false,
                ),
                CustomProvinceFormField(
                  title: translator.text('province'),
                  initialValue: state.user.provinceId,
                  onSave: (int value) {
                    _data['province_id'] = value;
                  },
                  color: theme.accentColor,
                ),
                // Address
                CustomFormField(
                  title: translator.text('address'),
                  initialValue: state.user.address,
                  onSave: (value) => _data['address'] = value,
                  onChanged: (value) => _data['address'] = value,
                  validator: (String address) {
                    if (address.isEmpty) {
                      return "Address is required field";
                    }
                    return null;
                  },
                  color: theme.accentColor,
                ),
                // Phone Number
                CustomFormField(
                  title: translator.text('phone_number'),
                  initialValue: state.user.phoneNumber,
                  onSave: (value) => _data['phone_number'] = value,
                  onChanged: (value) => _data['phone_number'] = value,
                  validator: (String phoneNumber) {
                    if (phoneNumber.isEmpty) {
                      return "Phone number is required field";
                    }
                    return null;
                  },
                  color: theme.accentColor,
                  keyboardType: TextInputType.phone,
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  child: ScopedModelDescendant<StateModel>(
                    builder:
                        (BuildContext context, Widget child, StateModel model) {
                      return model.userLoading
                          ? CircularProgressIndicator()
                          : RaisedButton(
                              textColor: Colors.white,
                              child: Text(translator.text("save_button")),
                              onPressed: () =>
                                  _save(context, model, translator));
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _save(
      BuildContext context, StateModel state, AppTranslations translator) {
    if (!_form.currentState.validate()) {
      return;
    }

    state.updateUser(_data).then((ok) {
      if (!ok) {
        Toast.show(translator.text('user_save_failed'), context);
        return;
      }
      Toast.show(translator.text('user_save_succeeded'), context);
      Navigator.pushReplacementNamed(context, AppRouter.userProfile);
    });
  }
}
