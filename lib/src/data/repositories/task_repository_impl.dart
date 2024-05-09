import 'package:clean_riverpod_architecture/src/data/data_souces/local/database.dart';
import 'package:clean_riverpod_architecture/src/data/repositories/base/base_db_repository.dart';
import 'package:clean_riverpod_architecture/src/domain/models/task.model.dart';
import 'package:clean_riverpod_architecture/src/domain/repositories/tasks_repository.dart';
import 'package:clean_riverpod_architecture/src/locator.dart';
import 'package:clean_riverpod_architecture/src/utils/classes/data_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'task_repository_impl.g.dart';

class TasksRepositoryImplementation extends BaseDbRepository
    implements TasksRepository {
  final AppDatabase _appDatabase;

  TasksRepositoryImplementation(this._appDatabase);

  @override
  Stream<List<TaskModel>> watchTasks() {
    return _appDatabase.tasksDao.watchTasks().map(
          (event) => event
              .map(
                (e) => TaskModel(
                  id: e.id,
                  title: e.title,
                  description: e.description,
                ),
              )
              .toList(),
        );
  }

  @override
  Future<TaskModel> getTask(int id) async {
    try {
      final result = await _appDatabase.tasksDao.getTask(id);

      return TaskModel(
        id: result.id,
        title: result.title,
        description: result.description,
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<DataState<void>> addTask(TaskModel task) {
    return safeExecute(() => _appDatabase.tasksDao.addTask(task));
  }

  @override
  Future<DataState<void>> removeTask(int id) {
    return safeExecute(() => _appDatabase.tasksDao.removeTask(id));
  }

  @override
  Future<DataState<void>> updateTask(TaskModel newTask) {
    return safeExecute(() => _appDatabase.tasksDao.updateTask(newTask));
  }
}

@riverpod
Stream<List<TaskModel>> tasks(TasksRef ref) {
  final tasksRepository = locator<TasksRepository>();
  return tasksRepository.watchTasks();
}

@riverpod
Future<TaskModel> singleTask(SingleTaskRef ref, int id) {
  final tasksRepository = locator<TasksRepository>();
  return tasksRepository.getTask(id);
}
