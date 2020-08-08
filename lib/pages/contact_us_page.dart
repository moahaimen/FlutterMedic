import 'package:drugStore/constants/colors.dart';
import 'package:drugStore/constants/strings.dart';
import 'package:drugStore/localization/app_translation.dart';
import 'package:drugStore/partials/drawer.dart';
import 'package:drugStore/partials/router.dart';
import 'package:drugStore/partials/toolbar.dart';
import 'package:drugStore/utils/state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:toast/toast.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUsPage extends StatefulWidget {
  @override
  _ContactUsPageState createState() => _ContactUsPageState();
}

class _ContactUsPageState extends State<ContactUsPage> {
  Future<void> _launched;

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<StateModel>(
        builder: (BuildContext context, Widget child, StateModel model) {
      return Scaffold(
        drawer: DrawerBuilder.build(context, Router.contactUs),
        appBar: Toolbar.get(title: Router.contactUs, context: context),
        body: model.contactUsLoading
            ? Center(child: CircularProgressIndicator())
            : _buildContactUsWidget(context, model.contactUs),
      );
    });
  }

  Widget _buildContactUsWidget(
      BuildContext context, Map<String, dynamic> contactUs) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 30),
      child: Column(
        children: [
          Center(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildPhoneWidget(context, contactUs['connections']['phone']),
                _buildFacebookWidget(
                    context, contactUs['connections']['facebook']),
                _buildEmailWidget(context, contactUs['connections']['email']),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 8),
            child: _buildAboutWidget(context, contactUs['about']['about']),
          ),
        ],
      ),
    );
  }

  Widget _buildPhoneWidget(BuildContext context, Map<String, dynamic> phone) {
    return Container(
      height: 100,
      width: 100,
      child: Card(
        child: GestureDetector(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.phone,
                size: 40,
                color: Colors.grey,
              ),
              Text(AppTranslations.of(context).locale.languageCode == "en"
                  ? phone['en_value']
                  : phone['ar_value']),
            ],
          ),
          onTap: () {
            setState(() {
              _launched = _makePhoneCall('tel:07721837469');
            },
            );
            //            callPhone();
            //            _copyToClipboard(context, phone['url']);
          },
        ),
      ),
    );
  }

  Widget _buildFacebookWidget(
      BuildContext context, Map<String, dynamic> facebook) {
    return Container(
      height: 100,
      width: 100,
      child: Card(
        child: GestureDetector(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/facebook.png',
                width: 40,
                height: 40,
              ),
              Text(AppTranslations.of(context).locale.languageCode == "en"
                  ? facebook['en_value']
                  : facebook['ar_value']),
            ],
          ),
          onTap: () {
//            _copyToClipboard(context, facebook['url']);


          },
        ),
      ),
    );
  }

  Widget _buildEmailWidget(BuildContext context, Map<String, dynamic> email) {
    return Container(
      height: 100,
      width: 100,
      child: Card(
        child: GestureDetector(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.alternate_email,
                size: 40,
                color: Colors.grey,
              ),
              Text(AppTranslations.of(context).locale.languageCode == "en"
                  ? email['en_value']
                  : email['ar_value']),
            ],
          ),
          onTap: () {
            _copyToClipboard(context, email['url']);
          },
        ),
      ),
    );
  }

  Widget _buildAboutWidget(BuildContext context, Map<String, dynamic> about) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 22, vertical: 11),
      child: Center(
        child: Column(
          children: [
            Text(
              Strings.applicationTitle,
              style: Theme.of(context)
                  .textTheme
                  .headline3
                  .copyWith(color: AppColors.accentColor),
            ),
            Text(
              AppTranslations.of(context).locale.languageCode == "en"
                  ? about['en_value']
                  : about['ar_value'],
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }

  void _copyToClipboard(BuildContext context, String text) {
    Clipboard.setData(ClipboardData(text: text)).then(
        (value) => Toast.show("Copied to clipboard successfully", context));
  }
}

Future<void> _makePhoneCall(String url) async {

  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}


Future<void> callPhone() async {
  // Android
  var uri = '07721837469';

  if (await canLaunch(uri)) {
    await launch(uri);
  } else {
    // iOS

    if (await canLaunch(uri)) {
      await launch(uri);
    } else {
      throw 'Could not launch $uri';
    }
  }
}
