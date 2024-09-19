import 'package:fit_pro_client/models/task_group.dart';
import 'package:intl/intl.dart';

enum TaskStatus { actual, past, accepted }

class Task {
  final String id;
  final String title;
  final DateTime date;
  final String time;
  final String location;
  final String clientName;
  final String clientImage;
  TaskStatus status; 

  // Optional properties
  final String? clientPhoneNumber;
  final String? taskArea;
  final double? taskPlaceDistance;
  final TaskGroup? taskWorkGroup;
  final String? taskDetails;
  final String? taskTimeEvaluation;
  final String? taskTools;
  final String? taskFullAddress;

  Task({
    required this.id,
    required this.title,
    required this.date,
    required this.time,
    required this.location,
    required this.clientName,
    required this.clientImage,
    required this.status,
    this.clientPhoneNumber,
    this.taskArea,
    this.taskPlaceDistance,
    this.taskWorkGroup,
    this.taskDetails,
    this.taskTimeEvaluation,
    this.taskTools,
    this.taskFullAddress,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      title: json['title'],
      date: DateTime.parse(json['date']),
      time: json['time'],
      location: json['location'],
      clientName: json['clientName'],
      clientImage: json['clientImage'],
      status: TaskStatus.values.firstWhere((e) => e.toString() == 'TaskStatus.${json['status']}'),
      clientPhoneNumber: json['clientPhoneNumber'],
      taskArea: json['taskArea'],
      taskPlaceDistance: json['taskPlaceDistance']?.toDouble(),
      taskWorkGroup: json['taskWorkGroup'] != null
          ? TaskGroup.fromJson(json['taskWorkGroup'])
          : null,
      taskDetails: json['taskDetails'],
      taskTimeEvaluation: json['taskTimeEvaluation'],
      taskTools: json['taskTools'],
      taskFullAddress: json['taskFullAddress'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'date': date.toIso8601String(),
      'time': time,
      'location': location,
      'clientName': clientName,
      'clientImage': clientImage,
      'status': status.toString().split('.').last,
      'clientPhoneNumber': clientPhoneNumber,
      'taskArea': taskArea,
      'taskPlaceDistance': taskPlaceDistance,
      'taskWorkGroup': taskWorkGroup?.toJson(),
      'taskDetails': taskDetails,
      'taskTimeEvaluation': taskTimeEvaluation,
      'taskTools': taskTools,
      'taskFullAddress': taskFullAddress,
    };
  }

  // Helper method to get the start DateTime
  DateTime get startTime {
    final format = DateFormat.jm(); // '11:00 AM'
    final DateTime parsedTime = format.parse(time);
    return DateTime(date.year, date.month, date.day, parsedTime.hour, parsedTime.minute);
  }

  // Optional method to get the end time if you have a default duration
  DateTime get endTime => startTime.add(const Duration(hours: 1));
}
