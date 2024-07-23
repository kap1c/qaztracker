// ignore_for_file: import_of_legacy_library_into_null_safe

import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_core/core/abstarct/constant/core_common_contant.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:qaz_tracker/services/data/notification_receive_model.dart';

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

/// Streams are created so that app can respond to notification-related events
/// since the plugin is initialised in the `main` function
final StreamController<ReceivedNotification> didReceiveLocalNotificationStream =
    StreamController<ReceivedNotification>.broadcast();

final StreamController<String> selectNotificationStream =
    StreamController<String>.broadcast();

const String portName = 'notification_send_port';

String? selectedNotificationPayload;

/// A notification action which triggers a url launch event
const String urlLaunchActionId = 'id_1';

/// A notification action which triggers a App navigation event
const String navigationActionId = 'id_3';

/// Defines a iOS/MacOS notification category for text input actions.
const String darwinNotificationCategoryText = 'textCategory';

/// Defines a iOS/MacOS notification category for plain actions.
const String darwinNotificationCategoryPlain = 'plainCategory';

@pragma('vm:entry-point')
Future<void> notificationTapBackground(
    NotificationResponse notificationResponse) async {
  await Firebase.initializeApp();
  // ignore: avoid_print
  print('notification(${notificationResponse.id}) action tapped: '
      '${notificationResponse.actionId} with'
      ' payload: ${notificationResponse.payload}');
  if (notificationResponse.input?.isNotEmpty ?? false) {
    // ignore: avoid_print
    print(
        'notification action tapped with input: ${notificationResponse.input}');
  }
  return Future<void>.value();
}

Future onSelectNotification(String? payload, BuildContext context) async {
  if (payload != null && payload.isNotEmpty) {}
}

/// Create a [AndroidNotificationChannel] for heads up notifications
const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description:
        'This channel is used for important notifications.', // description
    importance: Importance.high,
    showBadge: true,
    playSound: true);

class NotificationHandlerService {
  final BuildContext? context;
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  NotificationHandlerService(this.context);

  late StreamSubscription iosSubscription;

  initializeFcmNotification(BuildContext context) async {
    var initializationSettingsAndroid =
        const AndroidInitializationSettings('mipmap/ic_launcher');

    final List<DarwinNotificationCategory> darwinNotificationCategories =
        <DarwinNotificationCategory>[
      DarwinNotificationCategory(darwinNotificationCategoryText,
          actions: <DarwinNotificationAction>[
            DarwinNotificationAction.text('text_1', 'Action 1',
                buttonTitle: 'Send', placeholder: 'Placeholder')
          ]),
      DarwinNotificationCategory(darwinNotificationCategoryPlain,
          actions: <DarwinNotificationAction>[
            DarwinNotificationAction.plain('id_1', 'Action 1'),
            DarwinNotificationAction.plain('id_2', 'Action 2 (destructive)',
                options: <DarwinNotificationActionOption>{
                  DarwinNotificationActionOption.destructive
                }),
            DarwinNotificationAction.plain(
                navigationActionId, 'Action 3 (foreground)',
                options: <DarwinNotificationActionOption>{
                  DarwinNotificationActionOption.foreground
                }),
            DarwinNotificationAction.plain('id_4', 'Action 4 (auth required)',
                options: <DarwinNotificationActionOption>{
                  DarwinNotificationActionOption.authenticationRequired
                }),
          ],
          options: <DarwinNotificationCategoryOption>{
            DarwinNotificationCategoryOption.hiddenPreviewShowTitle
          })
    ];

    final DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
            requestAlertPermission: false,
            requestBadgePermission: false,
            requestSoundPermission: false,
            onDidReceiveLocalNotification: onDidReceiveLocalNotification,
            notificationCategories: darwinNotificationCategories);

    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsDarwin);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse:
            (NotificationResponse notificationResponse) {
      switch (notificationResponse.notificationResponseType) {
        case NotificationResponseType.selectedNotification:
          selectNotificationStream.add(notificationResponse.payload!);
          break;
        case NotificationResponseType.selectedNotificationAction:
          if (notificationResponse.actionId == navigationActionId) {
            selectNotificationStream.add(notificationResponse.payload!);
          }
          break;
      }
    }, onDidReceiveBackgroundNotificationResponse: notificationTapBackground);

    await _createNotificationChannel();

    _fcm.setForegroundNotificationPresentationOptions(
        alert: true, sound: true, badge: true);

    if (Platform.isIOS) {
      _fcm.getToken().then((value) => log('IOS FCM token value ----> $value'));

      _fcm.requestPermission(
          alert: true,
          announcement: true,
          badge: true,
          criticalAlert: true,
          sound: true);
    }

    FirebaseMessaging.onMessage.listen((event) async {
      displayNotification(event);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((event) async {
      if (event.data.isNotEmpty) {
        ///TODO: write logic
      }
    });
  }

  Future<void> _createNotificationChannel() async {
    const AndroidNotificationChannel androidNotificationChannel =
        AndroidNotificationChannel('your channel id 2', 'your channel name 2',
            description: 'your channel description 2');
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(androidNotificationChannel);
  }

  void dispose() {
    iosSubscription.cancel();
    selectNotificationStream.close();
  }

  Future<void> onDidReceiveLocalNotification(
      int? id, String? title, String? body, String? payload) async {}

  void displayNotification(RemoteMessage event) async {
    var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
        'your channel id', 'your channel name',
        channelDescription: 'your channel description',
        icon: 'mipmap/ic_launcher',
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker');

    var iOSPlatformChannelSpecifics = const DarwinNotificationDetails(
        presentAlert: true, presentBadge: true, presentSound: true);

    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
        event.ttl ?? 1,
        event.notification?.title?.toString() ?? CoreConstant.empty,
        event.notification?.body ?? CoreConstant.empty,
        platformChannelSpecifics,
        payload: event.messageId);
  }
}
