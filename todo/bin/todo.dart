import 'dart:convert';
import 'dart:io';

import 'package:dcli/dcli.dart';
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
  printerr(green("Enter Your Todo Title\n"));
  String? title = stdin.readLineSync(); // null safety in name string

  if (title == null) return; // Handle empty input
  final createdAt =
      DateTime.now().toString().substring(0, 16); // Format date/time
  Todo todo = Todo(title.toUpperCase(), createdAt);
  todos.add(todo.toJson());
  saveToFile(); // Save todos to file asynchronously
}

void printTodo() {
        printerr(green('+----+-------------------------------------+----------------+---------------+'));

  final header =
      '| ID |            TODO TITLE               |  CREATED AT      |  COMPELTED  |';
  printerr(cyan(header));

  printerr(green(
      '+----+-------------------------------------+----------------+---------------+'));

  for (int i = 0; i < todos.length; i++) {
    final task = todos[i];
    printerr(green('| ${i + 1}  | '
        '${task['title'].padRight(35)} | '
        '${task['createdAt'].toString().padRight(12)} | '
        '${task['isCompleted'] ? '✅          ' : '❌          '}|'));
    printerr(green(
        '+----+-------------------------------------+----------------+---------------+'));
  }
}

void markAsCOmplete() {
  printTodo();
  printerr(green("Enter Todo ID to mark as completed:"));
  String? todoId = stdin.readLineSync();
  try {
    if (todoId != null) {
      int n = int.parse(todoId);
      if (n >= 1 && n <= todos.length) {
        if (todos[n-1]['isCompleted'] != true){
        todos[n - 1]['isCompleted'] = true;
        }else{
          printerr(yellow('already completed'));
        }
        saveToFile();
      }
    }
  } catch (e) {
    printerr(red("Invalid Input"));
  }
}

void deleteTodo() {
  printTodo();
  printerr(green("Enter Todo ID to delete:"));
  String? todoId = stdin.readLineSync();
  int index = int.parse(todoId!);
  try {
    bool allowed = confirm('Are you sure you want to delete this todo?', defaultValue: false);
   allowed ? todos.removeAt(index - 1) : printerr(red('canceled'));
    saveToFile();
  } catch (e) {
    printerr(red("Invalid Input"));
  }
}

void showOptions() {
  while (true) {
    printerr(orange(
        "\nType 'A' to add, 'D' to delete, 'C' to mark complete, or 'Q' to quit: \n"));
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
        printerr(red("Invalid Option"));
    }
    printTodo();
    if (option.toUpperCase() == 'Q') {
      break;
    }
  }
}

void isFirstTime() async {
  if (await File(todoFile).exists()) {
    printerr(blue("Welcome Back\n\n".padLeft(43)));
    readFromFile();
    printTodo();
  } else {
    printerr(blue("Welcome to the TODO App\n\n".padLeft(43)));
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
