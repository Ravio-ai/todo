class Todo {
  final String title;
  final String createdAt;
  bool isCompleted;

  Todo(this.title, this.createdAt, {this.isCompleted = false});

  //from json
  Todo.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        createdAt = json['createdAt'],
        isCompleted = json['isCompleted'];

  //to json
  Map<String, dynamic> toJson() => {
        'title': title,
        'createdAt': createdAt,
        'isCompleted': isCompleted,
      };

  @override
  String toString() {
    return 'Todo{title: $title, createdAt: $createdAt, isCompleted: $isCompleted}';
  }
}
