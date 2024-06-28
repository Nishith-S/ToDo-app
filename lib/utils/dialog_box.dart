import 'package:flutter/material.dart';

class DialogBox extends StatelessWidget {
  final controller;
  VoidCallback onAdd;
  VoidCallback onCancle;
  GlobalKey myKey;
  Widget child;

  DialogBox({
    super.key,
    required this.controller,
    required this.onAdd,
    required this.onCancle,
    required this.myKey,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog.adaptive(
      clipBehavior: Clip.hardEdge,
      elevation: 0,
      content: SizedBox(
        height: 150,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Form(
                key: myKey,
                child: Container(
                  width: 250,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: Theme.of(context).backgroundColor,
                      borderRadius: BorderRadius.circular(10)),
                  margin: EdgeInsets.only(),
                  child: child,
                )),
            const SizedBox(
              height: 22,
            ),
            //Buttons add + cancle
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                //Cancel Button
                ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.red[300])),
                  onPressed: onCancle,
                  child: const Text(
                    "Cancel",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                //add button
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Colors.green.shade400),
                  ),
                  onPressed: onAdd,
                  child: const Text(
                    "Add",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.primary,
      title: const Text(
        "Add a task",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
    );
  }
}
