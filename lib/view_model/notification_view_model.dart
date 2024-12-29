import 'package:alarm/view/home_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationViewModel extends GetxController{

  FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin;
  late BuildContext context;

  initialize(cntxt) async {
    context=cntxt;
    var androidInitialize = new AndroidInitializationSettings('@mipmap/ic_launcher');
    var iOSInitialize = new DarwinInitializationSettings();
    var initializationsSettings =
    InitializationSettings(android: androidInitialize, iOS: iOSInitialize);
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    await flutterLocalNotificationsPlugin!.initialize(initializationsSettings,
        onDidReceiveNotificationResponse:onDidReceiveNotificationResponse);
  }

  void onDidReceiveNotificationResponse(NotificationResponse response) async {
    showNotification();
    if (response.actionId == 'snooze') {
      debugPrint('Snooze button pressed');
      // Snooze logic: Reschedule the notification
      DateTime snoozeTime = DateTime.now().add(Duration(minutes:1)); // Snooze for 5 minutes
      await scheduleNotification(snoozeTime, 1);
    } else if (response.actionId == 'cancel') {
      debugPrint('Cancel button pressed');
      // Cancel the notification
      await cancelNotification(1);
    } else {
      // Default action: handle payload or navigate
      final String? payload = response.payload;
      if (payload != null) {
        debugPrint('notification payload: $payload');
      }
      await Navigator.push(context,
          MaterialPageRoute<void>(builder: (context) => HomeView())
      );
    }
  }


  showNotification() async {
    const List<AndroidNotificationAction> actions = [
      AndroidNotificationAction(
        'snooze', // Unique ID for the action
        'Snooze', // Label shown on the button
        showsUserInterface: true, // Show additional UI if needed
        inputs: [], // For input collection (if needed)
      ),
      AndroidNotificationAction(
        'cancel', // Unique ID for the action
        'Cancel', // Label shown on the button
      ),
    ];
    const AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails('your channel id', 'your channel name',
      channelDescription: 'your channel description',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
      actions:actions,

    );

    const NotificationDetails notificationDetails =
    NotificationDetails(android: androidNotificationDetails);
    await flutterLocalNotificationsPlugin!.show(
        0, 'Alarm', 'plain body', notificationDetails,
        payload: 'item x');
  }

  scheduleNotification(DateTime datetime,int id) async {
    int newTime= datetime.millisecondsSinceEpoch - DateTime.now().millisecondsSinceEpoch;
    print(datetime.millisecondsSinceEpoch);
    print(DateTime.now().millisecondsSinceEpoch);
    print(newTime);

    await flutterLocalNotificationsPlugin!.zonedSchedule(
        id,
        'Alarm Clock',
        DateFormat().format(DateTime.now()),
        tz.TZDateTime.now(tz.local).add( Duration(milliseconds: newTime)),


        const NotificationDetails(
            android: AndroidNotificationDetails(
                'your channel id', 'your channel name',
                channelDescription: 'your channel description',
                sound: RawResourceAndroidNotificationSound("alarm"),
                autoCancel: false,
                playSound: true,
                priority: Priority.max


            )),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime);
  }




  cancelNotification(int notificationId)async{

    await flutterLocalNotificationsPlugin!.cancel(notificationId);


  }


}