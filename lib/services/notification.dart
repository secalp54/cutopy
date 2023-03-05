import 'package:cutopy/pages/main_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class Noti {
  final BuildContext context;
  late String _channelId;
  String _chanelName = "Cutopy";
  String _channelDesc = "Cutopy bildirim kanalı";
  late AndroidNotificationDetails androidPlatformChannalSp;
  late NotificationDetails _notificationDetails;

  Noti(this.context) {
    tz.initializeTimeZones();
    _channelId = "0";
    
    androidPlatformChannalSp =
        AndroidNotificationDetails(_channelId, "alp",
            icon: 'mipmap/ic_launcher',
            largeIcon: DrawableResourceAndroidBitmap('mipmap/ic_launcher'),
            playSound: true,
            // sound: const RawResourceAndroidNotificationSound('notification'),
            importance: Importance.max,
            priority: Priority.high);

    _notificationDetails= NotificationDetails(android: androidPlatformChannalSp);
  }
  Future Initialize(FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    var androidInitial = const AndroidInitializationSettings("mipmap/ic_launcher"); //
    var iosInitial = const DarwinInitializationSettings();
    var initializationSettings = InitializationSettings(android: androidInitial, iOS: iosInitial);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings, onDidReceiveNotificationResponse: (v) {
      print("tılandı.$v");
      onDidReceiveLocalNotification();
    });
  }

  showBigTextNoti(
      {var id = 0,
      required String title,
      required String body,
      var payload,
      required FlutterLocalNotificationsPlugin fln}) async {
    var nt = NotificationDetails(android: androidPlatformChannalSp, iOS: const DarwinNotificationDetails());
    await fln.show(id, title, body, nt);
  }

  void onDidReceiveLocalNotification() async {
    // display a dialog with the notification details, tap ok to go to another page
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => MainPage()));
  }

  Future<void> zonedScheduleNotification(DateTime date, String title, String body) async {
    var bugun = DateTime.now();
    var dif = bugun.difference(date)*-1 ;
    await flutterLocalNotificationsPlugin.zonedSchedule(
        0, title, body, tz.TZDateTime.now(tz.local).add(dif), _notificationDetails,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime);
  }
}
