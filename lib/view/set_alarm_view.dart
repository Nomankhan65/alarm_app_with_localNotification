import 'dart:math';

import 'package:alarm/model/alarm_model.dart';
import 'package:alarm/view_model/home_vew_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';

import '../view_model/notification_view_model.dart';

class SetAlarmView extends StatelessWidget {
  final controller = Get.put(HomeViewViewModel());
  final notificationController = Get.put(NotificationViewModel());
  SetAlarmView({super.key});
  String? dateTime;
  bool repeat = false;
  DateTime? notificationTime;
  int? milliseconds;
  var id=DateTime.now().millisecond;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Set new alarm'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: 300,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.grey.shade200),
              child: CupertinoDatePicker(
                  showDayOfWeek: true,
                  minimumDate: DateTime.now(),
                  dateOrder: DatePickerDateOrder.dmy,
                  onDateTimeChanged: (time) {
                    dateTime = DateFormat().add_jms().format(time);
                    milliseconds = time.millisecondsSinceEpoch;
                    notificationTime = time;
                    print(dateTime);
                  }),
            ),
            SizedBox(
              height: 50,
            ),
            SizedBox(
              height: 50,
              width: double.infinity,
              child: ElevatedButton(
                  onPressed: () {
                    AlarmModel alarm = AlarmModel(
                        dateTime: dateTime,
                        check: true,
                        id:id,
                        milliseconds: milliseconds);
                    if( dateTime != null){
                      controller.addAlarm(alarm);
                      notificationController.scheduleNotification(notificationTime!, id);
                      Navigator.pop(context);
                      print('id ====  $id');
                      print(notificationTime);
                      print(dateTime);
                    }
                    else{
                      controller.snackbar('Select time to set alarm');
                    }

                  },
                  child: Text('Set alarm')),
            )
          ],
        ),
      ),
    );
  }
}
