
import 'dart:convert';

AlarmInfo alarmInfoFromJson(String str) => AlarmInfo.fromJson(json.decode(str));

String alarmInfoToJson(AlarmInfo data) => json.encode(data.toJson());

class AlarmInfo {
    AlarmInfo({
        this.id,
        this.title,
       required this.alarmDateTime,
       required this.isPending,
        this.gradientColorIndex,
    });

    int? id;
    String? title;
    DateTime alarmDateTime;
    String isPending;
    int? gradientColorIndex;

    factory AlarmInfo.fromJson(Map<String, dynamic> json) => AlarmInfo(
       id: json["id"],
        title: json["title"],
        alarmDateTime: DateTime.parse(json["alarmDateTime"]),
        isPending: json["isPending"],
        gradientColorIndex: json["gradientColorIndex"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "alarmDateTime": alarmDateTime.toIso8601String(),
        "isPending": isPending,
        "gradientColorIndex": gradientColorIndex,
    };
}
