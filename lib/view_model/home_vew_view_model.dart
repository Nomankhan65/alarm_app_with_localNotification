import 'dart:convert';
import 'package:alarm/model/alarm_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeViewViewModel extends GetxController {
  late SharedPreferences sharedPreferences;
  RxList<AlarmModel> alarmList = <AlarmModel>[].obs;
  late BuildContext context;
  @override
  void onInit() async {
    super.onInit();
    sharedPreferences = await SharedPreferences.getInstance();
    getAlarm();
  }

  void addAlarm(AlarmModel alarm) {
    alarmList.add(alarm);
    setAlarm();
    snackbar('Alarm set at ${alarm.dateTime}');
    print('saved');
  }

  void setAlarm() {
    try {
      List<String> newList =
          alarmList.map((e) => json.encode(e.toJson())).toList();
      sharedPreferences.setStringList('alarmList', newList);
    } catch (e) {
      print(e.toString());
    }
  }

  void getAlarm() {
    try {
      // Fetch the stored alarm list
      List<String>? savedAlarms = sharedPreferences.getStringList('alarmList');

      // If there's saved data, decode it
      if (savedAlarms != null) {
        alarmList.value = savedAlarms
            .map((e) => AlarmModel.fromJson(json.decode(e)))
            .toList();
        print('Alarms loaded successfully.');
      } else {
        print('No alarms found in SharedPreferences.');
      }
    } catch (e) {
      print('Error loading alarms: $e');
    }
  }

  void deleteAlarm(int index) {
    snackbar('Alarm deleted at ${alarmList[index].dateTime}');
    alarmList.removeAt(index);
    List<String> newList =
        alarmList.map((e) => json.encode(e.toJson())).toList();
    sharedPreferences.setStringList('alarmList', newList);
    print(sharedPreferences.getStringList('alarmList'));

  }

  void switchButton(int index, bool value) {
    try {
      var updatedAlarm = alarmList[index];
      updatedAlarm = AlarmModel(
        dateTime: updatedAlarm.dateTime,
        check: value,
        id: updatedAlarm.id,
        milliseconds: updatedAlarm.milliseconds,
      );
      alarmList[index] = updatedAlarm; // Update the RxList
      setAlarm(); // Save changes to SharedPreferences
    } catch (e) {
      print('Error updating switch: $e');
    }
  }
  // Updates an existing alarm in the list and saves changes
  void updateAlarm(AlarmModel alarm, int index) {
    try {
      // Update the specific alarm in the list
      alarmList[index] = alarm;
      // Convert the updated list to JSON strings for storage
      List<String> newList =
      alarmList.map((e) => json.encode(e.toJson())).toList();
      // Save the updated list to SharedPreferences
      sharedPreferences.setStringList('alarmList', newList);
      snackbar('Alarm updated to${alarmList[index].dateTime}');
      // Refresh the reactive list to notify listeners
      alarmList.refresh();
    } catch (e) {

    }
  }
  void snackbar(
    String message,
  ) {
    Get.snackbar(
      'Alarm',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.grey.shade500,
      colorText: Colors.white,
      borderRadius: 10,
      margin: EdgeInsets.all(10),
      duration: Duration(seconds: 2),
    );
  }
}
