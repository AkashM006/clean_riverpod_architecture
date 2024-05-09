import 'package:clean_riverpod_architecture/src/data/repositories/task_repository_impl.dart';
import 'package:clean_riverpod_architecture/src/presentation/widgets/common/custom_app_bart.widget.dart';
import 'package:clean_riverpod_architecture/src/presentation/widgets/common/custom_loader.widget.dart';
import 'package:clean_riverpod_architecture/src/presentation/widgets/common/error.widget.dart';
import 'package:clean_riverpod_architecture/src/presentation/widgets/detail/task_detail.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DetailPage extends ConsumerWidget {
  final int taskId;
  const DetailPage({super.key, required this.taskId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final taskFuture = ref.watch(singleTaskProvider(taskId));

    return switch (taskFuture) {
      AsyncData(value: final task) => Scaffold(
          appBar: CustomAppBar(
            titleWidget: Text(task.title),
          ),
          body: TaskDetail(
            task: task,
          ),
        ),
      AsyncError(:final error) => Scaffold(
          appBar: const CustomAppBar(
            titleWidget: Text("Error"),
          ),
          body: Container(
            color: Theme.of(context).colorScheme.background,
            child: CustomErrorWidget(error.toString()),
          ),
        ),
      _ => const Scaffold(
          appBar: CustomAppBar(
            titleWidget: Text("Loading..."),
          ),
          body: CustomLoaderWidget(),
        ),
    };
  }
}
