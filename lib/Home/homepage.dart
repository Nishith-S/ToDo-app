import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:todo/DataBase/to_do_DB.dart';
import '../utils/dialog_box.dart';
import '../utils/todo_tile.dart';
import 'package:hive/hive.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final TextEditingController _controller = TextEditingController();
  late List foundToDO = [];
  List result = [];
  final _myBox = Hive.box("todoStorage");
  final GlobalKey<FormState> _newTaskKey = GlobalKey<FormState>();
  ToDoDatabase db = ToDoDatabase();

  //initially creating a tile if db.todolist io null
  //and also storing db.todolist in foundToDO
  @override
  void initState() {
    if (_myBox.get("TODOList") == null) {
      db.createTile();
    } else {
      db.getTile();
    }
    myFlag();
    foundToDO = db.todolist;
    super.initState();
  }

  //for developer to debug
  void myFlag() {
    print(db.todolist);
    print("----------FOUND---------");
    print(foundToDO);
    print("----------RESULT---------");
    print(result);
  }

  //searching method
  void runFilter(String enteredString) {
    try {
      if (db.todolist.isEmpty) {
        result = db.todolist;
      } else {
        result = db.todolist
            .where(
              (item) => item[0].toString().toLowerCase().contains(
                    enteredString.toLowerCase(),
                  ),
            )
            .toList();
      }
      myFlag();
      setState(() {
        foundToDO = result;
      });
    } catch (e) {
      Fluttertoast.showToast(
          msg: "Opps... Something went wrong come back later",
          toastLength: Toast.LENGTH_LONG);
    }
  }

  //method to add task to list
  void addNewTask() {
    if (_newTaskKey.currentState!.validate()) {
      setState(() {
        db.todolist.add([_controller.text, false]);
        _controller.clear();
        db.refreshTheApp();
        Fluttertoast.showToast(
            msg: "Task added",
            textColor: Theme.of(context).colorScheme.primary,
            toastLength: Toast.LENGTH_SHORT,
            backgroundColor: Theme.of(context).hintColor);
      });
      Navigator.of(context).pop();
      myFlag();
    }
  }

  //a dialog when user tap on floatingactionbutton
  createANewTask() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return DialogBox(
          myKey: _newTaskKey,
          controller: _controller,
          onAdd: addNewTask,
          onCancle: () {
            Navigator.of(context).pop();
            _controller.clear();
          },
          child: TextFormField(
            cursorColor: Theme.of(context).colorScheme.background,
            validator: (task) {
              if (task == null || task.isEmpty) {
                return "Enter a task";
              }
              return null;
            },
            autofocus: true,
            controller: _controller,
            decoration: InputDecoration(
                prefixIcon: const Icon(Icons.keyboard_alt_outlined),
                hintText: "Add a new task",
                hintStyle: TextStyle(color: Theme.of(context).hintColor),
                border: InputBorder.none),
          ),
        );
      },
    );
  }

  void deleteTask(int index) {
    setState(() {
      try {
        int foundIndex = foundToDO.indexOf(db.todolist[index]);
        print("the founded index is $foundIndex");
        print("value of index $index");
        db.todolist.removeAt(index);
      } catch (e) {
        Fluttertoast.showToast(
            msg: "Opps... Something went wrong come back later",
            toastLength: Toast.LENGTH_LONG);
      }
      db.refreshTheApp();
      Fluttertoast.showToast(
          msg: "Task deleted", toastLength: Toast.LENGTH_SHORT);
    });
    myFlag();
  }

  //method to change checked value of checkbox
  void onCheckedChange(bool? value, int index) {
    setState(() {
      // int foundIndex = foundToDO.indexOf(db.todolist[index]);
      try {
        int foundIndex = db.todolist
            .indexWhere((element) => element[0] == foundToDO[index][0]);
        print("the founded index is $foundIndex");
        print(value);
        print(index);
        db.todolist[foundIndex][1] = !db.todolist[foundIndex][1];
        db.refreshTheApp();
        db.getTile();
      } catch (e) {
        Fluttertoast.showToast(
            msg: "Opps... Something went wrong come back later",
            toastLength: Toast.LENGTH_LONG);
      }
    });
    myFlag();
  }

  //suggestion builder for searchbar
  Iterable<Widget> buildSuggestion() {
    return foundToDO.asMap().entries.map((entry) {
      int index = entry.key;
      var e = entry.value;
      return ToDOTile(
        taskName: e[0],
        taskCompleted: e[1],
        onChanged: (value) => onCheckedChange(value, index),
        tileDeleteFunction: (context) => deleteTask(index),
      );
    });
  }

  //Refresh method
  Future _handleRefresh() async {
    try {
      await Future.delayed(const Duration(seconds: 1));
      db.getTile();
      db.refreshTheApp();
      foundToDO = db.todolist;
      setState(() {});
    } catch (e) {
      Fluttertoast.showToast(
          msg: "Opps... Something went wrong come back later",
          toastLength: Toast.LENGTH_LONG);
    }
  }

  //method for "Select all" and "Unselect checked tasks" to determine the text and the below methods
  bool anyTaskSelected() {
    if (db.todolist.isNotEmpty) {
      var msg = db.todolist.any((element) => element[1]);
      print("anyTaskSelected message $msg");

      ///Checks every element in db.todolist in iteration order, and returns `true` if
      /// any of them make [element] return `true`, otherwise returns false.
      /// Returns `false` if the iterable is empty.
      /// .any() function iterates through all the tasks in db.todolist.
      /// The condition task[1] checks the second element of each task sublist. In the original code, the second element is a boolean value indicating whether the task is selected.
      /// If at least one task is selected, the any() function will return true; otherwise, it will return false.
      /// Return false if db.todolist is empty:If the list is empty, we return false as there are no tasks, hence none can be selected.
      return db.todolist.any((element) => element[1]);
    }
    return false;
  }

  //Select all task
  void selectAll() {
    for (int i = 0; i < foundToDO.length; i++) {
      db.todolist[i][1] = true;
    }
    db.refreshTheApp();
    myFlag();
  }

  //Unselect the all task or any selected task
  void unselectAll() {
    for (int i = 0; i < foundToDO.length; i++) {
      db.todolist[i][1] = false;
    }
    db.refreshTheApp();
    myFlag();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text(
          "To Do",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: 'Platypi',
            color: Colors.green.shade400,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.background,
        elevation: 0,
      ),
      body: LiquidPullToRefresh(
        borderWidth: 5,
        showChildOpacityTransition: true,
        color: Colors.green.shade400,
        height: 150,
        backgroundColor: Theme.of(context).colorScheme.background,
        onRefresh: _handleRefresh,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.all(10),
                padding: const EdgeInsets.only(
                  top: 15,
                ),
                width: 300,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: SearchAnchor(
                  isFullScreen: false,
                  builder: (BuildContext context, SearchController controller) {
                    return SearchBar(
                      textStyle: MaterialStateProperty.all(TextStyle(
                          color: Theme.of(context)
                              .floatingActionButtonTheme
                              .foregroundColor)),
                      surfaceTintColor: MaterialStateProperty.all(Colors.white),
                      backgroundColor:
                          Theme.of(context).searchBarTheme.backgroundColor,
                      //calling runFilter method whenever user type something or use back button on keyboard
                      onChanged: (value) {
                        runFilter(value);
                      },
                      elevation: MaterialStateProperty.all(0),
                      hintText: "Search...",
                      hintStyle: MaterialStateProperty.all(
                          TextStyle(color: Theme.of(context).hintColor)),
                      leading: Icon(
                        Icons.search_rounded,
                        color: Theme.of(context)
                            .floatingActionButtonTheme
                            .foregroundColor,
                      ),
                    );
                  },
                  suggestionsBuilder:
                      (BuildContext context, SearchController controller) {
                    return buildSuggestion().toList();
                  },
                ),
              ),
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.only(
                        left: 20, right: 0, top: 15, bottom: 1),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "All TODO's",
                            style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.bold),
                          ),
                          IconButton(
                            tooltip: "Refresh",
                            icon: const Icon(Icons.refresh_rounded),
                            onPressed: _handleRefresh,
                          )
                        ]),
                  ),
                  Container(
                      padding: const EdgeInsets.only(left: 20),
                      // color: Colors.red,
                      // width: 383,
                      height: 35,
                      alignment: Alignment.centerLeft,
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                if (anyTaskSelected()) {
                                  unselectAll();
                                } else {
                                  selectAll();
                                }
                              });
                            },
                            child: Text(
                              anyTaskSelected()
                                  ? "Unselect checked tasks"
                                  : "Select all",
                              style: const TextStyle(
                                fontSize: 19,
                              ),
                            ),
                          )
                        ],
                      )),
                ],
              ),
              db.todolist.isNotEmpty
                  ? ListView.builder(
                      reverse: true,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: foundToDO.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ToDOTile(
                          taskName: foundToDO[index][0],
                          taskCompleted: foundToDO[index][1],
                          onChanged: (value) => onCheckedChange(value, index),
                          tileDeleteFunction: (context) => deleteTask(index),
                        );
                      },
                    )
                  : Container(
                      padding: const EdgeInsets.symmetric(vertical: 140),
                      alignment: Alignment.center,
                      child: const Text(
                        "No task have been added!",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
              const SizedBox(
                height: 100,
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        elevation: 0,
        onPressed: createANewTask,
        tooltip: "New task",
        backgroundColor: Colors.green.shade400,
        label: const Text(
          "Add new task",
          style: TextStyle(color: Colors.white),
        ),
        icon: const Icon(
          Icons.add_task,
          color: Colors.white,
        ),
      ),
    );
    //);
  }
}
