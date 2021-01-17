import 'package:drugStore/models/notification.dart' as MM;
import 'package:drugStore/partials/app_router.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

enum PushNotificationMode { Local, Dialog }

class PushNotificationsManager {
  //
  // Local notifications plugin channel details
  //
  static int notificationsCounter = 0;
  static String id = 'notidication00';
  static String name = 'drugsStore';
  static String description = 'drugsStore';

  //
  //
  //
  static PushNotificationMode mode = PushNotificationMode.Local;

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
    final String route = messageData['route'] ?? AppRouter.home;

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
      print("backgroundMessageHandler data $data");
    }

    if (message.containsKey('notification')) {
      // Handle notification message
      final dynamic notification = message['notification'];
      print("backgroundMessageHandler notificaion $notification");
    }

    return Future.value(true);
  }

  BuildContext context;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  final FlutterLocalNotificationsPlugin _plugin =
      new FlutterLocalNotificationsPlugin();

  PushNotificationsManager({this.context}) {
    _initLocalNotificationsPlugin();
    _initFirebaseMessaging();
  }

  void _initLocalNotificationsPlugin() {
    var androidSettings =
        new AndroidInitializationSettings('notification_icon');

    var iOSSettings = new IOSInitializationSettings(
        onDidReceiveLocalNotification: onDidReceiveLocalNotification);

    var settings = new InitializationSettings(
      android: androidSettings,
      iOS: iOSSettings,
    );

    _plugin.initialize(settings, onSelectNotification: onSelectNotification);
  }

  Future<void> _initFirebaseMessaging() async {
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
        mode == PushNotificationMode.Local
            ? _showNotification(message)
            : _showDialog(message);
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

    _firebaseMessaging
        .subscribeToTopic(topic)
        .then((value) => print('Subscribe to topic completed'));
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
    if (AppRouter.current.compareTo(notification.route) != 0) {
      Navigator.pushNamed(context, notification.route);
    }
  }

  Future<void> _showNotification(Map<String, dynamic> message) async {
    final notification = parseMessage(message);

    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      id,
      name,
      description,
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );

    var iOSPlatformChannelSpecifics = IOSNotificationDetails();

    var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    await _plugin.show(
      notificationsCounter++,
      notification.title,
      notification.description,
      platformChannelSpecifics,
      payload: notification.route,
    );
  }

  Future onSelectNotification(String payload) async {
    Navigator.pushNamed(context, AppRouter.home);
  }

  Future onDidReceiveLocalNotification(
      int id, String title, String body, String payload) async {
    // display a dialog with the notification details, tap ok to go to another page
    showDialog(
      context: context,
      builder: (BuildContext context) => new AlertDialog(
        title: new Text(title),
        content: new Text(body),
        actions: [
          FlatButton(
            child: new Text('Ok'),
            onPressed: () async {
              Navigator.of(context, rootNavigator: true).pop();
              print('clicked!!');
            },
          ),
        ],
      ),
    );
  }
}
