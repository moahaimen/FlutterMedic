import 'package:drugStore/localization/app_translation.dart';
import 'package:drugStore/partials/app_router.dart';
import 'package:drugStore/ui/custom_form_field.dart';
import 'package:drugStore/ui/custom_province_form_field.dart';
import 'package:drugStore/utils/state.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:toast/toast.dart';

import 'form_caption_widget.dart';

class RegisterForm extends StatelessWidget {
  final Map<String, dynamic> _data = {
    'first_name': null,
    'last_name': null,
    'user_name': null,
    'email': null,
    'password': null,
    'password_confirmation': null,
    'province_id': null,
    'address': null,
    'phone_number': null
  };

  final GlobalKey<FormState> _form = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final translator = AppTranslations.of(context);

    final double deviceWidth = MediaQuery.of(context).size.width;
    final double targetWidth = deviceWidth > 550.0 ? 500.0 : deviceWidth * .95;
    final double paddingWidth = deviceWidth - targetWidth;

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
                  caption: translator.text('register'),
                  targetWidth: targetWidth * .15,
                ),
                // UserName
                CustomFormField(
                    title: translator.text('user_name'),
                    initialValue: _data['user_name'],
                    onSave: (value) => _data['user_name'] = value,
                    onChanged: (value) => _data['user_name'] = value,
                    validator: (String email) {
                      if (email.isEmpty) {
                        return "User name is required field";
                      }
                      return null;
                    },
                    color: theme.accentColor),
                // FirstName
                CustomFormField(
                    title: translator.text('first_name'),
                    initialValue: _data['first_name'],
                    onSave: (value) => _data['first_name'] = value,
                    onChanged: (value) => _data['first_name'] = value,
                    validator: (String email) {
                      if (email.isEmpty) {
                        return "First name is required field";
                      }
                      return null;
                    },
                    color: theme.accentColor),
                // LastName
                CustomFormField(
                    title: translator.text('last_name'),
                    initialValue: _data['last_name'],
                    onSave: (value) => _data['last_name'] = value,
                    onChanged: (value) => _data['last_name'] = value,
                    validator: (String email) {
                      if (email.isEmpty) {
                        return "User name is required field";
                      }
                      return null;
                    },
                    color: theme.accentColor),
                // Email
                CustomFormField(
                    title: translator.text('email_address'),
                    initialValue: _data['email'],
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
                    color: theme.accentColor),
                // Password
                CustomFormField(
                  controller: _passwordController,
                  title: translator.text('password'),
                  onSave: (value) => _data['password'] = value,
                  onChanged: (value) {
                    _data['password'] = value;
                  },
                  validator: (String password) {
                    if (password.isEmpty || password.length < 8) {
                      return "Password is required field and length must be +8 chars";
                    }
                    return null;
                  },
                  color: theme.accentColor,
                  obscureText: true,
                ),
                // Password Confirmation
                CustomFormField(
                  title: translator.text('password_confirmation'),
                  initialValue: _data['password_confirmation'],
                  onSave: (value) => _data['password_confirmation'] = value,
                  onChanged: (value) => _data['password_confirmation'] = value,
                  validator: (String password) {
                    if (password != _passwordController.text) {
                      return "Password confirmation doesn't match";
                    }
                    return null;
                  },
                  color: theme.accentColor,
                  obscureText: true,
                ),
                CustomProvinceFormField(
                  title: translator.text('province'),
                  initialValue: null,
                  onSave: (int value) {
                    _data['province_id'] = value;
                  },
                  color: theme.accentColor,
                ),
                // Address
                CustomFormField(
                  title: translator.text('address'),
                  initialValue: _data['address'],
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
                  initialValue: _data['phone_number'],
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
                              child: Text(translator.text("register_button")),
                              onPressed: () =>
                                  _register(context, model, translator));
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

  void _register(
      BuildContext context, StateModel state, AppTranslations translator) {
    if (!_form.currentState.validate()) {
      return;
    }

    state.registerUser(_data).then((ok) {
      if (!ok) {
        Toast.show(translator.text('user_registration_failed'), context);
        return;
      }
      Toast.show(translator.text('user_registration_succeeded'), context);
      Navigator.pushReplacementNamed(context, AppRouter.login);
    });
  }
}
