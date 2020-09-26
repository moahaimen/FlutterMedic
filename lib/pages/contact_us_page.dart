import 'package:drugStore/constants/colors.dart';
import 'package:drugStore/constants/strings.dart';
import 'package:drugStore/localization/app_translation.dart';
import 'package:drugStore/models/pagination.dart';
import 'package:drugStore/partials/drawer.dart';
import 'package:drugStore/partials/router.dart';
import 'package:drugStore/partials/toolbar.dart';
import 'package:drugStore/utils/state.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:toast/toast.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUsPage extends StatefulWidget {
  @override
  _ContactUsPageState createState() => _ContactUsPageState();

  static asMap(List<dynamic> source) {
    final result = new Map<String, dynamic>();

    source.forEach((e) {
      if (!result.containsKey(e['section'])) {
        result[e['section']] = new Map<String, dynamic>();
      }

      result[e['section']][e['key']] = {
        'en_value': e['en_value'],
        'ar_value': e['ar_value'],
        'url': e['url'],
      };
    });

    return result;
  }
}

class _ContactUsPageState extends State<ContactUsPage> {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<StateModel>(
        builder: (BuildContext context, Widget child, StateModel model) {
      return Scaffold(
        drawer: DrawerBuilder.build(context, Router.contactUs),
        appBar: Toolbar.get(title: Router.contactUs, context: context),
        body: _buildBodyWidget(model),
      );
    });
  }

  Widget _buildBodyWidget(StateModel model) {
    assert(model != null);
    assert(model.contactUs != null);

    final obj = model.contactUs;

    switch (obj.status) {
      case PaginationStatus.Null:
        obj.fetch(context);
        return Center(child: CircularProgressIndicator());
      case PaginationStatus.Loading:
        return Center(child: CircularProgressIndicator());
      case PaginationStatus.Ready:
        return _buildContactUsWidget(context, ContactUsPage.asMap(obj.data));
    }
    return null;
  }

  Widget _buildContactUsWidget(
      BuildContext context, Map<String, dynamic> contactUs) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 30),
      child: Column(
        children: [
          _buildConnectionsWidget(contactUs['connections']),
          _buildAboutWidget(context, contactUs['about']['about']),
          // _buildPoweredByWidget(),
        ],
      ),
    );
  }

  Widget _buildConnectionsWidget(dynamic connections) {
    return Container(
      child: Center(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildPhoneWidget(context, connections['phone']),
            _buildFacebookWidget(context, connections['facebook']),
            _buildEmailWidget(context, connections['email']),
          ],
        ),
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
          onTap: () => _launchPhone(phone['url']),
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
          onTap: () => _launchFacebook(facebook['url']),
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
          onTap: () => _launchEmail(email['url']),
        ),
      ),
    );
  }

  Widget _buildAboutWidget(BuildContext context, Map<String, dynamic> about) {
    final theme = Theme.of(context);
    return Flexible(
      fit: FlexFit.tight,
      child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
          child: Center(
            child: Column(
              children: [
                Text(
                  Strings.applicationTitle,
                  textAlign: TextAlign.justify,
                  style: theme.textTheme.headline2.copyWith(
                    color: AppColors.accentColor,
                  ),
                ),
                Text(
                  AppTranslations.of(context).locale.languageCode == "en"
                      ? about['en_value']
                      : about['ar_value'],
                  textAlign: TextAlign.justify,
                  style: theme.textTheme.bodyText1,
                ),
                _buildPoweredByWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPoweredByWidget() {
    return Container(
      padding: EdgeInsets.only(top: 12),
      child: OutlineButton(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(" لعمل متجر ومذاخر الكترونية",
                style: const TextStyle(
                  fontSize: 18,
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF130f40),
                )),
            Text("ITM for Tech Solutions",
                style: const TextStyle(
                  fontSize: 18,
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF130f40),
                )),
          ],
        ),
        onPressed: _launchPersonalMessenger,
      ),
    );
  }

  void _launchPhone(String phone) => _launchUrl('tel:$phone');

  void _launchFacebook(String url) => _launchUrl('http://fb.me/$url');

  void _launchEmail(String url) => _launchUrl('mailto:$url');

  // Replace 'zappos' with your facebbok username
  void _launchPersonalMessenger() =>
      _launchUrl('http://m.me/gathanfer.gathanfer.7');

  Future<void> _launchUrl(String url) async {
    if (url == null) {
      throw new Exception("Url cannot be null");
    }
    if (!await canLaunch(url)) {
      Toast.show('Failed to open the application', context);
    }
    await launch(url);
  }
}
