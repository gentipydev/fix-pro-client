import 'package:fit_pro_client/models/task_group.dart';
import 'package:fit_pro_client/models/tasker.dart';
import 'package:fit_pro_client/models/user.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uuid/uuid.dart';

enum TaskStatus { past, accepted }

class Task {
  final String id;
  final User client;
  final Tasker tasker;

  // Locations for building map markers and polyline
  final LatLng userLocation;
  final LatLng taskerLocation;
  final List<LatLng> polylineCoordinates;
  final LatLngBounds? bounds;

  final TaskGroup taskWorkGroup;
  final DateTime date;
  final TimeOfDay time;
  final String? taskerArea;
  final String? taskPlaceDistance;
  final String? userArea;
  final String? taskFullAddress;
  List<String>? taskTools;
  String? paymentMethod; 
  String? promoCode;
  String? taskDetails;
  String? taskEvaluation;
  String? taskExtraDetails;
  TaskStatus status;
  bool bringOwnTools;

  static const _uuid = Uuid();

  // Constructor with auto-generated id
  Task({
    String? id,
    required this.client,
    required this.tasker,
    required this.userLocation,
    required this.taskerLocation,
    required this.polylineCoordinates,
    this.bounds,
    required this.taskWorkGroup,
    required this.date,
    required this.time,
    this.taskerArea,
    this.taskPlaceDistance,
    this.userArea,
    this.taskTools,
    this.paymentMethod,
    this.promoCode,
    this.taskFullAddress,
    this.taskDetails,
    this.taskEvaluation,
    this.taskExtraDetails,
    required this.status,
    this.bringOwnTools = true,
  }) : id = id ?? _uuid.v4();

  // Factory method to create a Task from a JSON object
  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      
      // Deserialize client and tasker as User and Tasker models
      client: User.fromJson(json['client']),
      tasker: Tasker.fromJson(json['tasker']),
      
      userLocation: LatLng(json['userLocation']['latitude'], json['userLocation']['longitude']),
      taskerLocation: LatLng(json['taskerLocation']['latitude'], json['taskerLocation']['longitude']),
      polylineCoordinates: (json['polylineCoordinates'] as List)
          .map((coordinate) => LatLng(coordinate['latitude'], coordinate['longitude']))
          .toList(),
      
      bounds: json['bounds'] != null
        ? LatLngBounds(
            southwest: LatLng(json['bounds']['southwest']['latitude'], json['bounds']['southwest']['longitude']),
            northeast: LatLng(json['bounds']['northeast']['latitude'], json['bounds']['northeast']['longitude']),
          )
        : null,

      taskWorkGroup: TaskGroup.fromJson(json['taskWorkGroup']),
      date: DateTime.parse(json['date']),
      
      // Deserialize TimeOfDay
      time: TimeOfDay(
        hour: int.parse(json['time'].split(':')[0]),
        minute: int.parse(json['time'].split(':')[1]),
      ),
      
      taskerArea: json['taskArea'],
      taskPlaceDistance: json['taskPlaceDistance'],
      userArea: json['userArea'],
      taskTools: (json['taskTools'] as List<dynamic>?)?.map((e) => e.toString()).toList(),
      paymentMethod: json['paymentMethod'],
      promoCode: json['promoCode'],
      taskFullAddress: json['taskFullAddress'],
      taskDetails: json['taskDetails'],
      taskEvaluation: json['taskEvaluation'],
      taskExtraDetails: json['taskExtraDetails'],
      status: TaskStatus.values.firstWhere((e) => e.toString() == 'TaskStatus.${json['status']}'),
      bringOwnTools: json['bringOwnTools'] ?? true,
    );
  }

  // Convert Task object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      
      'client': client.toJson(),
      'tasker': tasker.toJson(),
      
      'userLocation': {'latitude': userLocation.latitude, 'longitude': userLocation.longitude},
      'taskerLocation': {'latitude': taskerLocation.latitude, 'longitude': taskerLocation.longitude},
      'polylineCoordinates': polylineCoordinates
          .map((coordinate) => {'latitude': coordinate.latitude, 'longitude': coordinate.longitude})
          .toList(),
      
      // Only serialize bounds if it is not null
      if (bounds != null) 'bounds': {
        'southwest': {'latitude': bounds!.southwest.latitude, 'longitude': bounds!.southwest.longitude},
        'northeast': {'latitude': bounds!.northeast.latitude, 'longitude': bounds!.northeast.longitude},
      },
      
      'taskWorkGroup': taskWorkGroup.toJson(),
      'date': date.toIso8601String(),
      
      // Serialize TimeOfDay as a string in "HH:mm" format
      'time': '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}',

      'taskArea': taskerArea,
      'taskPlaceDistance': taskPlaceDistance,
      'userArea': userArea,
      'taskTools': taskTools,
      'paymentMethod': paymentMethod,
      'promoCode': promoCode,
      'taskFullAddress': taskFullAddress,
      'taskDetails': taskDetails,
      'taskEvaluation': taskEvaluation,
      'taskExtraDetails': taskExtraDetails,
      'status': status.toString().split('.').last,
      'bringOwnTools': bringOwnTools,
    };
  }
}
