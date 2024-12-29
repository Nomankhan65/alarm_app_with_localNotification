import 'package:alarm/view/set_alarm_view.dart';
import 'package:alarm/view_model/home_vew_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../view_model/notification_view_model.dart';

class HomeView extends StatefulWidget {
  HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final controller = Get.put(HomeViewViewModel());
  final notificationController = Get.put(NotificationViewModel());
  @override
  void initState() {
    // TODO: implement initState
    notificationController.initialize(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Alarm'),
      ),
      body: Obx(() {
        return ListView.builder(
            itemCount: controller.alarmList.length,
            itemBuilder: (context, index) {
              var data = controller.alarmList[index];
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: Container(
                  width: double.infinity,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(data.dateTime.toString()),
                      IconButton(
                          onPressed: () {
                            controller.deleteAlarm(index);
                          },
                          icon: Icon(
                            CupertinoIcons.delete,
                            color: Colors.red,
                          )),
                      CupertinoSwitch(
                          value: data.milliseconds! <
                                  DateTime.now().millisecondsSinceEpoch
                              ? false
                              : data.check,
                          onChanged: (value) {
                            controller.switchButton(index, value);
                            data.check
                                ? notificationController.scheduleNotification(
                            DateTime.parse(data.dateTime!), data.id!)
                                : notificationController
                                    .cancelNotification(data.id!);
                            print(data.check);
                          }),
                    ],
                  ),
                ),
              );
            });
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (_) => SetAlarmView()));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
