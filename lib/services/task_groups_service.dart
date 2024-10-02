import 'package:fit_pro_client/models/task_group.dart';
import 'package:fit_pro_client/services/dio_client.dart';
import 'package:fit_pro_client/services/fake_data.dart';

class TaskGroupsService {
  final DioClient dioClient = DioClient();
  final FakeData fakeData = FakeData();

  Future<List<TaskGroup>> fetchTaskGroups() async {
    try {
      // Response response = await dioClient.dio.get('/task_groups');
      // List data = response.data;
      // return data.map((group) => TaskGroup.fromJson(group)).toList();

      // For now, return fake data
      await Future.delayed(const Duration(milliseconds: 500));
      return fakeData.fakeTaskGroups;
    } catch (e) {
      throw Exception('Failed to fetch task groups');
    }
  }
}
