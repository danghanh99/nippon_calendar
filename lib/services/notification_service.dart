import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:nholiday_jp/nholiday_jp.dart';
import 'package:nippon_calendar/flutter_fire_cli/firebase_options.dart';
import 'package:timezone/timezone.dart' as timezoneLib;

class NotificationService {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  void showLocalNotification(String title, String body) {
    const androidNotificationDetail = AndroidNotificationDetails(
        '0', // channel Id
        'general' // channel Name
        );
    const iosNotificatonDetail = DarwinNotificationDetails();
    const notificationDetails = NotificationDetails(
      iOS: iosNotificatonDetail,
      android: androidNotificationDetail,
    );
    flutterLocalNotificationsPlugin.show(0, title, body, notificationDetails);
  }

  Future<void> init() async {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
    FirebaseMessaging a = FirebaseMessaging.instance;
    a.requestPermission();
    var bn = await a.getToken();
    print(bn);

    // firebase messing
    AndroidInitializationSettings initializationSettingsAndroid =
        const AndroidInitializationSettings('app_icon');
    DarwinInitializationSettings initializationSettingsIOS =
        const DarwinInitializationSettings();
    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    // firebase messing

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);

    // foreground
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification!;
      flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          const NotificationDetails(
            android: AndroidNotificationDetails(
              "channel.id",
              "channel.name",
              icon: 'some_icon_in_drawable_folder',
            ),
          ));
    });
    // foreground
  }

  Future<void> scheduleNotification(
    String title,
    String body,
    int hour,
    int minute,
    DateTime scheduleDate,
  ) async {
    final timezoneLib.TZDateTime scheduledDate = timezoneLib.TZDateTime(
        timezoneLib.local,
        scheduleDate.year,
        scheduleDate.month,
        scheduleDate.day,
        hour,
        minute);

    // }

    await flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      title,
      body,
      scheduledDate,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'your_channel_id',
          'your_channel_name',
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  void callScheduleMonth(
    int length,
    int month,
    int year,
  ) {
    scheduleNotification(
      "Calendar",
      "You have ${length} notification in ${month}/${year}",
      10,
      0,
      DateTime(year, month, 1),
    );
  }
}
