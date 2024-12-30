import 'package:alarm/view_model/home_vew_view_model.dart';
import 'package:alarm/view_model/notification_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import '../model/alarm_model.dart';


class UpdateAlarm extends StatelessWidget {
  int? index;
  int notificationId;
  UpdateAlarm(
      {super.key,
        required this.notificationId,
        required this.index,
      });

  DateTime? parsedDateTime;
   final controller = Get.put(HomeViewViewModel());

  final notificationServices = Get.put(NotificationViewModel());

  String? dateTime;

  bool repeat = false;

  DateTime? notificationTime;

  int? milliseconds;

  var id=DateTime.now().millisecond;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Update alarm'),
      ),
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.3,
            width: MediaQuery.of(context).size.width,
            child: Center(
                child: CupertinoDatePicker(
                  showDayOfWeek: true,
                  dateOrder: DatePickerDateOrder.dmy,
                  onDateTimeChanged: (time) {
                    dateTime = DateFormat().add_jms().format(time);
                    milliseconds = time.millisecondsSinceEpoch;
                    notificationTime = time;
                  },
                )),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: SizedBox(
              width:double.infinity,
              child: ElevatedButton(
                  onPressed: () {
                    AlarmModel alarmModel = AlarmModel(
                        dateTime: dateTime,
                        check: true,
                        id:id,
                        milliseconds:milliseconds);
                    if(dateTime != null){
                      controller.updateAlarm(alarmModel, index!);
                      notificationServices.scheduleNotification(notificationTime!,notificationId);
                      Navigator.pop(context);
                    }
                    else
                    {
                      controller.snackbar('Select time to update');
                    }


                  },
                  child: Text('Update alarm')),
            ),
          )
        ],
      ),
    );
  }
}
