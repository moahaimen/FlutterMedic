import 'package:drugStore/localization/app_translation.dart';
import 'package:drugStore/pages/home_page.dart';
import 'package:drugStore/pages/login_page.dart';
import 'package:drugStore/partials/app_router.dart';
import 'package:drugStore/ui/custom_form_field.dart';
import 'package:drugStore/utils/state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:toast/toast.dart';

import 'form_caption_widget.dart';

class LoginForm extends StatelessWidget {
  final LoginPageMode mode;

  final GlobalKey<FormState> _form = GlobalKey<FormState>();
  final Map<String, dynamic> _formData = {
    'email': '',
    'password': '',
  };

  LoginForm(this.mode);

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
                    title: translator.text('email_address'),
                    initialValue: _formData['email'],
                    onChanged: (value) => _formData['email'] = value,
                    onSave: (value) {
                      _formData['email'] = value;
                      TextInput.finishAutofillContext(shouldSave: true);
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
                  },
                  validator: (String password) {
                    if (password.isEmpty || password.length < 8) {
                      return "Password is required field and length must be +8 chars";
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

  void _login(
      BuildContext context, StateModel state, AppTranslations translator) {
    if (!_form.currentState.validate()) {
      return;
    }

    state.loginUser(_formData).then((ok) {
      if (!ok) {
        Toast.show(translator.text('user_logging_failed'), context);
        return;
      }
      Toast.show(translator.text('user_logging_succeeded'), context);
      if (this.mode == LoginPageMode.LoginThenNavigate) {
        final navigator = Navigator.of(context);
        if (navigator.canPop()) {
          navigator.pop();
          return;
        }
        navigator.pushReplacementNamed(AppRouter.home, arguments: PageId.Home);
      }
    });
  }
}
