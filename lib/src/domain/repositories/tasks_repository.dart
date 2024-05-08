import 'package:clean_riverpod_architecture/src/domain/models/task.model.dart';
import 'package:clean_riverpod_architecture/src/utils/classes/data_state.dart';

abstract class TasksRepository {
  Stream<List<TaskModel>> watchTasks();
  Future<TaskModel> getTask(int id);
  Future<DataState<void>> addTask(TaskModel task);
  Future<DataState<void>> updateTask(TaskModel newTask);
  Future<DataState<void>> removeTask(int id);
}
