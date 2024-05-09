import 'package:clean_riverpod_architecture/src/data/repositories/task_repository_impl.dart';
import 'package:clean_riverpod_architecture/src/presentation/controller/tasks.controller.dart';
import 'package:clean_riverpod_architecture/src/presentation/widgets/common/custom_app_bart.widget.dart';
import 'package:clean_riverpod_architecture/src/presentation/widgets/common/custom_loader.widget.dart';
import 'package:clean_riverpod_architecture/src/presentation/widgets/common/error.widget.dart';
import 'package:clean_riverpod_architecture/src/presentation/widgets/home/tasks_list.widget.dart';
import 'package:clean_riverpod_architecture/src/presentation/widgets/new_task/new_task.widget.dart';
import 'package:clean_riverpod_architecture/src/utils/classes/controller_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasksStream = ref.watch(tasksProvider);

    ref.listen(
      tasksControllerProvider,
      (previous, next) {
        switch (next.removeTaskState.status) {
          case ControllerStatus.success:
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Removed task successfully"),
              ),
            );
            break;
          case ControllerStatus.failure:
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(next.removeTaskState.message),
              ),
            );
            break;
          default:
            break;
        }
      },
    );

    return Scaffold(
      appBar: const CustomAppBar(
        titleWidget: Text("Welcome"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showNewTaskForm(context),
        child: const Icon(Icons.add),
      ),
      body: switch (tasksStream) {
        AsyncData(value: final tasks) => TasksList(tasks: tasks),
        AsyncError(:final error) => CustomErrorWidget(error.toString()),
        _ => const CustomLoaderWidget(),
      },
    );
  }
}
