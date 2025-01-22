
class Task {
  String title;
  bool isDone;
  String priority;
  DateTime dueDate;

  Task(this.title, this.priority, this.dueDate, {this.isDone = false});
}