import 'package:clean_riverpod_architecture/src/data/data_souces/local/database.dart';
import 'package:clean_riverpod_architecture/src/data/repositories/task_repository_impl.dart';
import 'package:clean_riverpod_architecture/src/domain/repositories/tasks_repository.dart';
import 'package:get_it/get_it.dart';

final locator = GetIt.I;

void setup() {
  final appDatabase = AppDatabase();

  locator.registerSingleton<TasksRepository>(
    TasksRepositoryImplementation(appDatabase),
  );
}
