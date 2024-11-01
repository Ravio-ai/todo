import 'dart:convert';
import 'dart:io';

import 'package:todo/todo.dart';

List<Map<String, dynamic>> todos = [];
const todoFile = "todos.json";

void saveToFile() async {
  //if file not exit create a new one
  if (!await File(todoFile).exists()) {
    await File(todoFile).create();
  }
  await File(todoFile).writeAsString(jsonEncode(todos));
}

void readFromFile() {
  // if (await File(todoFile).exists()) {
  const JsonDecoder decoder = JsonDecoder();
  var jsonString = File(todoFile).readAsStringSync();
  var jsonmap = decoder.convert(jsonString);
  for (var todo in jsonmap) {
    todos.add(todo);
  }
  // }
}

void addTodo() {
  print("Enter Your Todo Title");
  String? title = stdin.readLineSync(); // null safety in name string

  if (title == null) return; // Handle empty input
  final createdAt =
      DateTime.now().toString().substring(0, 16); // Format date/time
  Todo todo = Todo(title.toUpperCase(), createdAt);
  todos.add(todo.toJson());
  saveToFile(); // Save todos to file asynchronously
}

void printTodo() {
        print('+----+-------------------------------------+----------------+---------------+');

  final header =
      '| ID |            TODO TITLE               |  CREATED AT      |  COMPELTED  |';
  print(header);

  print(
      '+----+-------------------------------------+----------------+---------------+');

  for (int i = 0; i < todos.length; i++) {
    final task = todos[i];
    print('| ${i + 1}  | '
        '${task['title'].padRight(35)} | '
        '${task['createdAt'].toString().padRight(12)} | '
        '${task['isCompleted'] ? '✅          ' : '❌          '}|');
    print(
        '+----+-------------------------------------+----------------+---------------+');
  }
}

void markAsCOmplete() {
  printTodo();
  print("Enter Todo ID to mark as completed:");
  String? todoId = stdin.readLineSync();
  try {
    if (todoId != null) {
      int n = int.parse(todoId);
      if (n >= 1 && n <= todos.length) {
        if (todos[n-1]['isCompleted'] != true){
        todos[n - 1]['isCompleted'] = true;
        }else{
          print('already completed');
        }
        saveToFile();
      }
    }
  } catch (e) {
    print("Invalid Input");
  }
}

void deleteTodo() {
  printTodo();
  print("Enter Todo ID to delete:");
  String? todoId = stdin.readLineSync();
  int index = int.parse(todoId!);
  try {
    todos.removeAt(index - 1);
    saveToFile();
  } catch (e) {
    print("Invalid Input");
  }
}

void showOptions() {
  while (true) {
    print(
        "Type 'A' to add, 'D' to delete, 'C' to mark complete, or 'Q' to quit: ");
    String? option = stdin.readLineSync();
    if (option == null) return;

    switch (option.toUpperCase()) {
      case 'A':
        addTodo();
        break;
      case 'D':
        deleteTodo();
        break;
      case 'C':
        markAsCOmplete();
        break;
      case 'Q':
        break;
      default:
        print("Invalid Option");
    }
    printTodo();
    if (option.toUpperCase() == 'Q') {
      break;
    }
  }
}

void isFirstTime() async {
  if (await File(todoFile).exists()) {
    readFromFile();
    printTodo();
  } else {
    print("Welcome to the TODO App");
    addTodo();
    printTodo();
  }
  showOptions();
}

void main() {
  print("\x1B[2J\x1B[0;0H"); // clear entire screen, move cursor to 0;0
  isFirstTime();
  // showOptions();
}
