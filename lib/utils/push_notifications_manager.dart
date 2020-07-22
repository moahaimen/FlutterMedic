import 'package:drugStore/models/notification.dart' as MM;
import 'package:drugStore/partials/router.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class PushNotificationsManager {
  //
  // String
  //
  static String topic = 'user';

  //
  // Singleton instance of PushNotificationsManager
  //
  static PushNotificationsManager _instance;

  //
  // Static initializer of PushNotificationsManager
  //
  static void initialize(BuildContext context) {
    if (_instance == null) {
      _instance = new PushNotificationsManager(context: context);
      _instance.init();
    }
    _instance.context = context;
  }

  //
  // Parse message data
  //
  MM.Notification parseMessage(Map<String, dynamic> message) {
    var messageData = message['notification'];
    final String title = messageData['title'] ?? 'Drugs Store';
    final String description = messageData['body'] ?? '';
    final String route = messageData['route'] ?? Router.home;

    print("$title, $description, $route");
    return new MM.Notification(title, description, route);
  }

  //
  //
  //
  static Future<dynamic> backgroundMessageHandler(
      Map<String, dynamic> message) {
    if (message.containsKey('data')) {
      // Handle data message
      final dynamic data = message['data'];
    }

    if (message.containsKey('notification')) {
      // Handle notification message
      final dynamic notification = message['notification'];
    }
  }

  BuildContext context;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  PushNotificationsManager({this.context});

  Future<void> init() async {
    // For iOS request permission first.
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(
            sound: true, badge: true, alert: true, provisional: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        _showDialog(message);
      },
      onBackgroundMessage: backgroundMessageHandler,
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
        _navigateToItemDetail(message);
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
        _navigateToItemDetail(message);
      },
    );

    _firebaseMessaging.getToken().then((String token) {
      assert(token != null);
      print("Push Messaging token: $token");
    });

    _firebaseMessaging.subscribeToTopic(topic);
  }

  Widget _buildDialog(BuildContext context, MM.Notification notification) {
    return AlertDialog(
      content: Text(notification.description),
      actions: <Widget>[
        FlatButton(
          color: Theme.of(context).accentColor,
          child: const Text('Okay'),
          onPressed: () => Navigator.pop(context, false),
        ),
      ],
    );
  }

  void _showDialog(Map<String, dynamic> message) {
    showDialog(
        context: context,
        builder: (BuildContext context) =>
            _buildDialog(context, parseMessage(message))).then((ok) {
      if (ok) {
        _navigateToItemDetail(message);
      }
    });
  }

  void _navigateToItemDetail(Map<String, dynamic> message) {
    final MM.Notification notification = parseMessage(message);

    Navigator.popUntil(context, (Route<dynamic> route) => route is PageRoute);
    if (Router.current.compareTo(notification.route) != 0) {
      Navigator.pushNamed(context, notification.route);
    }
  }
}
