import 'package:clean_riverpod_architecture/src/domain/models/task.model.dart';
import 'package:clean_riverpod_architecture/src/presentation/widgets/home/task_detail.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class TasksList extends StatelessWidget {
  const TasksList({
    super.key,
    required this.tasks,
  });
  final List<TaskModel> tasks;

  @override
  Widget build(BuildContext context) {
    if (tasks.isEmpty) {
      return Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.7,
          child: Text(
            'You have no tasks. Add one to view it here',
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .bodyLarge!
                .copyWith(fontStyle: FontStyle.italic),
          ),
        ),
      );
    }

    return SlidableAutoCloseBehavior(
      closeWhenOpened: true,
      closeWhenTapped: true,
      child: ListView.builder(
        itemBuilder: (context, index) => TaskDetailItem(task: tasks[index]),
        itemCount: tasks.length,
      ),
    );
  }
}
