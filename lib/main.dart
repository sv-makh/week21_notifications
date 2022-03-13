import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sumple Notifications',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: NotificationsApp(),
    );
  }
}

class NotificationsApp extends StatefulWidget {
  const NotificationsApp({Key? key}) : super(key: key);

  @override
  _NotificationsAppState createState() => _NotificationsAppState();
}

class _NotificationsAppState extends State<NotificationsApp> {
  late FlutterLocalNotificationsPlugin localNotifications;

  @override
  void initState() {
    super.initState();
    //объект для Android настроек
    var androidInitialize = AndroidInitializationSettings('ic_launcher');
    //объект для IOS настроек
    var IOSInitialize = IOSInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,);
    // общая инициализация
    var initializationSettings = InitializationSettings(
        android: androidInitialize, iOS: IOSInitialize);

    //создаем локальное уведомление
    localNotifications = FlutterLocalNotificationsPlugin();
    localNotifications.initialize(initializationSettings);
  }

  Future<void> _showNotificationNow() async {
    const AndroidNotificationDetails androidDetails =
      AndroidNotificationDetails(
        "ID",
        "Название уведомления",
        //importance: Importance.high,
        channelDescription: "Контент уведомления",
      );
    const IOSNotificationDetails iosDetails =
      IOSNotificationDetails();
    const NotificationDetails generalNotificationDetails =
      NotificationDetails(android: androidDetails, iOS: iosDetails);
    await localNotifications.show(
        0, "Название", "Тело уведомления", generalNotificationDetails);
  }

  Future<void> _showNotificationsDaily() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
        'repeating channel ID',
        'repeating channel name',
        channelDescription: 'repeating description'
      );
    const IOSNotificationDetails iosDetails =
      IOSNotificationDetails();
    const NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics, iOS: iosDetails);
    await localNotifications.periodicallyShow(
        0,
        'Ежедневное напоминание',
        'Выделить полчаса на занятия программированием',
        RepeatInterval.daily,
        platformChannelSpecifics,
        androidAllowWhileIdle: true
    );

    /*await localNotifications.zonedSchedule(
      0,
      'Your daily notification',
      'Schedule half an hour to program',
      scheduledDate,
      notificationDetails,
      uiLocalNotificationDateInterpretation: uiLocalNotificationDateInterpretation,
      androidAllowWhileIdle: androidAllowWhileIdle
    )*/
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(
        child: Text('Press button to receive notifications'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Row( children: [
        const SizedBox(width: 15),
        FloatingActionButton.extended(
          onPressed: _showNotificationNow,
          icon: const Icon(Icons.notifications),
          label: const Text('Notif now')
        ),
        const SizedBox(width: 15),
        FloatingActionButton.extended(
          onPressed: _showNotificationsDaily,
          icon: const Icon(Icons.notifications_active),
          label: const Text('Notif daily')
        )
      ]),
    );
  }
}
