class AlarmModel {
  String ? dateTime;
  bool check;
  int ? id;
  int ? milliseconds;

  AlarmModel({
    required this.dateTime,
    required this.check,
    required this.id,
    required this.milliseconds
  });

  factory AlarmModel.fromJson(Map<String, dynamic> json) => AlarmModel(
    dateTime: json["dateTime"],
    check: json["check"],
    id:json["id"],
    milliseconds:json["milliseconds"],
  );

  Map<String, dynamic> toJson() => {
    "dateTime": dateTime,
    "check": check,
    "id":id,
    "milliseconds":milliseconds,
  };
}