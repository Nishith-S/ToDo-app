import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ToDOTile extends StatelessWidget {
  final String taskName;
  late bool taskCompleted;
  Function(bool?)? onChanged;
  Function(BuildContext)? tileDeleteFunction;

  //Constructor
  ToDOTile({
    super.key,
    required this.taskName,
    required this.taskCompleted,
    required this.onChanged,
    this.tileDeleteFunction,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 5, right: 5, top: 25),
      child: Slidable(
        endActionPane: ActionPane(
          motion: const DrawerMotion(),
          children: [
            SlidableAction(
              borderRadius: BorderRadius.circular(10),
              onPressed: tileDeleteFunction,
              icon: Icons.delete_forever_outlined,
              label: "Delete",
              backgroundColor: Colors.red.shade300,
            ),
          ],
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                //Check box to make task selected or unselected
                Checkbox(
                  activeColor: Colors.green.shade400,
                  checkColor: Theme.of(context).colorScheme.primary,
                  value: taskCompleted,
                  onChanged: onChanged,
                ),
                //Task name
                Expanded(
                  child: Text(
                    taskName,
                    style: TextStyle(
                        decoration: taskCompleted
                            ? TextDecoration.lineThrough
                            : TextDecoration.none),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
