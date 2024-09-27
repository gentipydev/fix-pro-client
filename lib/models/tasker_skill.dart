import 'package:fit_pro_client/models/task_group.dart';

class TaskerSkill {
  final TaskGroup taskGroup;
  final int tasksCompleted;

  TaskerSkill({
    required this.taskGroup,
    required this.tasksCompleted,
  });

  // Factory method to create a TaskerSkill from a JSON object
  factory TaskerSkill.fromJson(Map<String, dynamic> json) {
    return TaskerSkill(
      taskGroup: TaskGroup.fromJson(json['taskGroup']),
      tasksCompleted: json['tasksCompleted'],
    );
  }

  // Convert TaskerSkill object to JSON
  Map<String, dynamic> toJson() {
    return {
      'taskGroup': taskGroup.toJson(),
      'tasksCompleted': tasksCompleted,
    };
  }
}
