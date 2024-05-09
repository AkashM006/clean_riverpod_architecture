import 'package:clean_riverpod_architecture/src/domain/models/task.model.dart';
import 'package:clean_riverpod_architecture/src/domain/repositories/tasks_repository.dart';
import 'package:clean_riverpod_architecture/src/locator.dart';
import 'package:clean_riverpod_architecture/src/utils/classes/controller_state.dart';
import 'package:clean_riverpod_architecture/src/utils/classes/data_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'tasks.controller.g.dart';
part 'tasks.controller.freezed.dart';

@freezed
class TasksControllerState with _$TasksControllerState {
  const factory TasksControllerState({
    @Default(ControllerState()) ControllerState addTasksState,
    @Default(ControllerState()) ControllerState updateTaskState,
    @Default(ControllerState()) ControllerState removeTaskState,
  }) = _TasksControllerState;
}

@riverpod
class TasksController extends _$TasksController {
  final _tasksRepository = locator<TasksRepository>();
  @override
  TasksControllerState build() {
    return const TasksControllerState();
  }

  Future<void> addTask(String title, String description) async {
    state = state.copyWith(
      addTasksState: state.addTasksState.setLoading(),
    );

    final result = await _tasksRepository.addTask(
      TaskModel(
        title: title,
        description: description,
      ),
    );

    switch (result) {
      case DataSuccess():
        state = state.copyWith(
          addTasksState: state.addTasksState.setSuccess(null),
        );
        break;
      case DataFailure(:final error):
        state = state.copyWith(
          addTasksState: state.addTasksState.setFailure(
            error.toString(),
          ),
        );
        break;
    }
  }

  Future<void> removeTask(int id) async {
    state = state.copyWith(removeTaskState: state.removeTaskState.setLoading());

    final result = await _tasksRepository.removeTask(id);

    switch (result) {
      case DataSuccess():
        state = state.copyWith(
          removeTaskState: state.removeTaskState.setSuccess(null),
        );
        break;
      case DataFailure(:final error):
        state = state.copyWith(
          removeTaskState: state.removeTaskState.setFailure(error.toString()),
        );
        break;
    }
  }

  Future<void> updateTask(TaskModel newTask) async {
    state = state.copyWith(updateTaskState: state.updateTaskState.setLoading());

    final result = await _tasksRepository.updateTask(newTask);

    switch (result) {
      case DataSuccess():
        state = state.copyWith(
          updateTaskState: state.updateTaskState.setSuccess(null),
        );
        break;
      case DataFailure(:final error):
        state = state.copyWith(
          updateTaskState: state.updateTaskState.setFailure(error.toString()),
        );
        break;
    }
  }
}
