import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

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

  Future _showNotification() async {
    var androidDetails = AndroidNotificationDetails(
      "ID",
      "Название уведомления",
      importance: Importance.high,
      channelDescription: "Контент уведомления",
    );
    var iosDetails = IOSNotificationDetails();
    var generalNotificationDetails =
    NotificationDetails(android: androidDetails, iOS: iosDetails);
    await localNotifications.show(
        0, "Название", "Тело уведомления", generalNotificationDetails);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Press button to receive notification'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showNotification,
        child: Icon(Icons.notifications_none),
      ),
    );
  }
}
