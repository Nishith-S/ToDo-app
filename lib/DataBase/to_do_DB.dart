import 'package:hive/hive.dart';

class ToDoDatabase {
  final __myBox = Hive.box("todoStorage");
  List todolist = [];

  //If user opens for first time then create default todo tile
  void createTile() {
    todolist = [
      [
        "This is the default task we have added (*Swipe to left side to delete)",
        false
      ],
    ];
  }

  //get/ fetch the tiles from db
  void getTile() {
    todolist = __myBox.get("TODOList");
  }

  //refresh / adding tile to db the app when ever user interact with app
  void refreshTheApp<Widget>() {
    __myBox.put("TODOList", todolist);
  }
}
