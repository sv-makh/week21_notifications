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


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Press button to receive notification'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => {},
        child: Icon(Icons.notifications_none),
      ),
    );
  }
}
