import 'package:drugStore/localization/app_translation.dart';
import 'package:drugStore/models/user.dart';
import 'package:drugStore/pages/login_page.dart';
import 'package:drugStore/partials/app_router.dart';
import 'package:drugStore/ui/custom_form_field.dart';
import 'package:drugStore/utils/state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:toast/toast.dart';

import 'form_caption_widget.dart';

class LoginForm extends StatefulWidget {
  final LoginPageMode mode;

  LoginForm({@required this.mode});

  @override
  State<StatefulWidget> createState() {
    return _LoginFormState();
  }
}

class _LoginFormState extends State<LoginForm> {
  final GlobalKey<FormState> _form = GlobalKey<FormState>();
  final Map<String, dynamic> _formData = {
    'email': '',
    'password': '',
  };

  bool _okay = true;
  Map<String, List<dynamic>> _errors = new Map<String, List<dynamic>>();

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
                  caption: translator.text('login'),
                  targetWidth: targetWidth * .15,
                ),
                // Email
                CustomFormField(
                    keyboardType: TextInputType.emailAddress,
                    title: translator.text('email_address'),
                    initialValue: _formData['email'],
                    onChanged: (value) => _formData['email'] = value,
                    onSave: (value) {
                      _formData['email'] = value;
                      TextInput.finishAutofillContext(shouldSave: true);
                      setState(() {
                        this._errors.remove('email');
                      });
                    },
                    validator: (String email) {
                      if (email.isEmpty) {
                        return "Email is required field";
                      }
                      if (!RegExp(
                              r'([A-Za-z]+[A-Za-z0-9]+)(@)([A-Za-z]+).([A-Za-z0-9]+)')
                          .hasMatch(email)) {
                        return "Email must be in a valid format";
                      }

                      if (!_okay && this._errors.containsKey('email')) {
                        return this._errors['email'].first;
                      }
                      return null;
                    },
                    autoFillHints: [AutofillHints.email],
                    color: theme.accentColor),
                // Password
                CustomFormField(
                  title: translator.text('password'),
                  initialValue: _formData['password'],
                  onChanged: (value) => _formData['password'] = value,
                  onSave: (value) {
                    _formData['password'] = value;
                    TextInput.finishAutofillContext(shouldSave: true);
                    setState(() {
                      this._errors.remove('password');
                    });
                  },
                  validator: (String password) {
                    if (password.isEmpty || password.length < 8) {
                      return "Password is required field and length must be +8 chars";
                    }
                    if (!_okay && this._errors.containsKey('password')) {
                      return this._errors['password'].first;
                    }
                    return null;
                  },
                  autoFillHints: [AutofillHints.password],
                  color: theme.accentColor,
                  obscureText: true,
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
                              child: Text(translator.text("login_button")),
                              onPressed: () =>
                                  _login(context, model, translator));
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

  void _login(BuildContext ctx, StateModel state, AppTranslations t) async {
    if (!_form.currentState.validate()) {
      return;
    }

    final result = await state.loginUser(_formData);
    if (result is User) {
      if (mounted) {
        setState(() {
          _okay = true;
          _errors = null;
        });
      }

      if (this.widget.mode == LoginPageMode.LoginThenNavigate) {
        Navigator.of(context)
            .pushNamedAndRemoveUntil(AppRouter.home, (route) => false);
      }
      if (mounted) {
        Toast.show(t.text('user_logging_succeeded'), ctx);
      }
    } else {
      if (mounted) {
        setState(() {
          _okay = false;
          // _errors = Map.from(result);
        });
      }
      Toast.show(t.text('user_logging_failed'), ctx);
    }
  }
}
