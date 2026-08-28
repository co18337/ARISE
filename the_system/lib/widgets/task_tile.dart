import 'package:flutter/material.dart';

import '../models/models.dart';

/// A single checkbox row for one [DailyTask]: title on the left, XP badge on
/// the right. Tapping anywhere on the row toggles it (that's what
/// `CheckboxListTile` gives us for free, instead of a bare `Checkbox`).
class TaskTile extends StatelessWidget {
  final DailyTask task;
  final ValueChanged<bool> onChanged;

  const TaskTile({super.key, required this.task, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      value: task.done,
      onChanged: (checked) => onChanged(checked ?? false),
      title: Text(
        task.template.title,
        style: task.done
            ? const TextStyle(decoration: TextDecoration.lineThrough)
            : null,
      ),
      secondary: Text('+${task.template.xp} XP'),
      controlAffinity: ListTileControlAffinity.leading,
    );
  }
}
