import 'package:clean_riverpod_architecture/src/data/data_souces/local/database.dart';
import 'package:clean_riverpod_architecture/src/data/data_souces/local/schemas/task.schema.dart';
import 'package:clean_riverpod_architecture/src/domain/models/task.model.dart';
import 'package:clean_riverpod_architecture/src/utils/classes/errors.dart';
import 'package:drift/drift.dart';

part 'tasks.dao.g.dart';

@DriftAccessor(tables: [Tasks])
class TasksDao extends DatabaseAccessor<AppDatabase> with _$TasksDaoMixin {
  TasksDao(super.db);

  Stream<List<Task>> watchTasks() {
    return (select(tasks)).watch();
  }

  Future<List<Task>> getTasks() async {
    return await (select(tasks)).get();
  }

  Future<Task> getTask(int id) async {
    return await (select(tasks)..where((tbl) => tbl.id.equals(id))).getSingle();
  }

  Future<void> addTask(TaskModel task) async {
    try {
      await into(tasks).insert(TasksCompanion(
        title: Value(task.title),
        description: Value(task.description),
      ));
    } catch (error) {
      if (error is InvalidDataException) {
        final errorFields = error.errors.entries
            .map((e) => e.key.dartGetterName.toString())
            .toList()
            .join(', ');
        throw DataMigrationError(fields: errorFields);
      }
      rethrow;
    }
  }

  Future<void> updateTask(TaskModel newTask) async {
    print("New Task: ${newTask}");
    try {
      final result = await (update(tasks)
            ..where((tbl) => tbl.id.equals(newTask.id)))
          .write(
        TasksCompanion(
          title: Value(newTask.title),
          description: Value(newTask.description),
        ),
      );
      if (result == 0) {
        throw const AppError(
          message: "Unable to update the task. Please try again later",
        );
      }
    } catch (e) {
      print("Error: ${e.toString()}");
      if (e is AppError) rethrow;
      throw const AppError(
        message: "Unable to update the task. Please try again later",
      );
    }
  }

  Future<void> removeTask(int id) async {
    try {
      (delete(tasks)..where((tbl) => tbl.id.equals(id))).go();
    } catch (error) {
      throw const AppError(
        message: "Unable to delete your task it may not exist. Please check",
      );
    }
  }
}
