import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

void main() async {
  //необходимо для инициализации локального часового пояса
  //в последующем вызове _configureLocalTimeZone
  WidgetsFlutterBinding.ensureInitialized();
  await _configureLocalTimeZone();
  runApp(const MyApp());
}

//инициализация базы часовых поясов и локального часового пояса
//необходимо для правильного часа уведомления при выборе времени пользователем
Future<void> _configureLocalTimeZone() async {
  tz.initializeTimeZones();
  final String? timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
  tz.setLocalLocation(tz.getLocation(timeZoneName!));
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

  //выбранное время для уведомлений
  TimeOfDay selectedTime = TimeOfDay.now();

  @override
  void initState() {
    super.initState();
    //объект для Android настроек
    const AndroidInitializationSettings androidInitialize = AndroidInitializationSettings('ic_launcher');
    //объект для IOS настроек
    const IOSInitializationSettings IOSInitialize = IOSInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,);
    // общая инициализация
    const InitializationSettings initializationSettings = InitializationSettings(
        android: androidInitialize, iOS: IOSInitialize);

    //создаем локальное уведомление
    localNotifications = FlutterLocalNotificationsPlugin();
    localNotifications.initialize(initializationSettings);
  }

  //показывается одно уведоление при вызове этого метода
  Future<void> _showNotificationNow() async {
    const AndroidNotificationDetails androidDetails =
      AndroidNotificationDetails(
        "ID",
        "Название уведомления",
        importance: Importance.high,
        channelDescription: "Контент уведомления",
      );
    const IOSNotificationDetails iosDetails =
      IOSNotificationDetails();
    const NotificationDetails generalNotificationDetails =
      NotificationDetails(android: androidDetails, iOS: iosDetails);
    await localNotifications.show(
        0, "Название", "Тело уведомления", generalNotificationDetails);
  }

  //после вызова этого метода уведомления будут показываться ежедневно
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
  }

  //после вызова этого метода уведомления будут показываться ежедневно
  //в выбранное время
  Future<void> _showNotificationsDailyAtChosenTime(BuildContext context) async {
    //выбор времени
    TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    //newTime == null, если пользователь при выборе времени нажмет Отмена,
    //иначе уведомления будут показываться в выбранное время
    if (newTime != null) {
      selectedTime = newTime;
      await localNotifications.zonedSchedule(
          0,
          'Ещё одно ежедневное напоминание',
          'Время пить чай!',
          _nextInstanceOfChosenTime(),
          const NotificationDetails(
            android: AndroidNotificationDetails('daily notification channel id',
                'daily notification channel name',
                channelDescription: 'daily notification description'),
            iOS: IOSNotificationDetails()
          ),
          androidAllowWhileIdle: true,
          uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
          matchDateTimeComponents: DateTimeComponents.time);
    }
  }

  //рассчёт следующего времени для ежедневного уведомления в выбранное время
  tz.TZDateTime _nextInstanceOfChosenTime() {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate =
    tz.TZDateTime(tz.local, now.year, now.month, now.day, selectedTime.hour, selectedTime.minute);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  Future<void> _cancelNotifications() async {
    await localNotifications.cancelAll();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
            Text('Press button to receive notifications'),
            const SizedBox(height: 15),
            FloatingActionButton.extended(
                onPressed: _showNotificationNow,
                icon: const Icon(Icons.notifications),
                label: const Text('Notification now')
            ),
            const SizedBox(height: 15),
            FloatingActionButton.extended(
                onPressed: _showNotificationsDaily,
                icon: const Icon(Icons.notifications_active),
                label: const Text('Notifications daily')
            ),
            const SizedBox(height: 15),
            FloatingActionButton.extended(
              onPressed: () {
                _showNotificationsDailyAtChosenTime(context);
              },
              icon: const Icon(Icons.circle_notifications),
              label: const Text('Notifications daily at chosen time'),
            ),
            const SizedBox(height: 15),
            FloatingActionButton.extended(
              onPressed: _cancelNotifications,
              icon: const Icon(Icons.notifications_off),
              label: const Text('Cancel all notifications'),
            )
          ])
      ),
    );
  }
}
