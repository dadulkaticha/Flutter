
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'models/task.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Task> _tasks = [];

  void _addTask(Task task) {
    setState(() {
      _tasks.add(task);
    });
  }

  void _toggleDone(int index) {
    setState(() {
      _tasks[index].isDone = !_tasks[index].isDone;
    });
  }

  void _deleteTask(int index) {
    setState(() {
      _tasks.removeAt(index);
    });
  }

  void _editTask(int index, Task newTask) {
    setState(() {
      _tasks[index] = newTask;
    });
  }

  void _showAddTaskDialog() {
    showDialog(
      context: context,
      builder: (ctx) {
        String title = '';
        String priority = 'Normal';
        DateTime dueDate = DateTime.now();

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Přidat úkol'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    onChanged: (value) => title = value,
                    decoration: const InputDecoration(labelText: 'Název'),
                  ),
                  DropdownButton<String>(
                    value: priority,
                    items: const [
                      DropdownMenuItem(value: 'Low', child: Text('Low')),
                      DropdownMenuItem(value: 'Normal', child: Text('Normal')),
                      DropdownMenuItem(value: 'High', child: Text('High')),
                    ],
                    onChanged: (val) {
                      setState(() {
                        priority = val ?? 'Normal';
                      });
                    },
                  ),
                  TextButton(
                    onPressed: () async {
                      final pickedDate = await showDatePicker(
                        context: context,
                        initialDate: dueDate,
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2100),
                      );
                      if (pickedDate != null) {
                        final pickedTime = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.fromDateTime(dueDate),
                        );
                        if (pickedTime != null) {
                          setState(() {
                            dueDate = DateTime(
                              pickedDate.year,
                              pickedDate.month,
                              pickedDate.day,
                              pickedTime.hour,
                              pickedTime.minute,
                            );
                          });
                        }
                      }
                    },
                    child: const Text('Zvolit deadline'),
                  ),
                  Text('Vybraný deadline: ${DateFormat('dd.MM.yyyy HH:mm').format(dueDate)}'),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Zrušit'),
                ),
                ElevatedButton(
                  onPressed: () {
                    _addTask(Task(title, priority, dueDate));
                    Navigator.pop(context);
                  },
                  child: const Text('Přidat'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showEditTaskDialog(int index) {
    final oldTask = _tasks[index];
    String title = oldTask.title;
    String priority = oldTask.priority;
    DateTime dueDate = oldTask.dueDate;
    final TextEditingController titleController = TextEditingController(text: title);

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Upravit úkol'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: titleController,
                    onChanged: (value) => title = value,
                    decoration: const InputDecoration(labelText: 'Název'),
                  ),
                  DropdownButton<String>(
                    value: priority,
                    items: const [
                      DropdownMenuItem(value: 'Low', child: Text('Low')),
                      DropdownMenuItem(value: 'Normal', child: Text('Normal')),
                      DropdownMenuItem(value: 'High', child: Text('High')),
                    ],
                    onChanged: (val) {
                      setState(() {
                        priority = val ?? 'Normal';
                      });
                    },
                  ),
                  TextButton(
                    onPressed: () async {
                      final pickedDate = await showDatePicker(
                        context: context,
                        initialDate: dueDate,
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2100),
                      );
                      if (pickedDate != null) {
                        final pickedTime = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.fromDateTime(dueDate),
                        );
                        if (pickedTime != null) {
                          setState(() {
                            dueDate = DateTime(
                              pickedDate.year,
                              pickedDate.month,
                              pickedDate.day,
                              pickedTime.hour,
                              pickedTime.minute,
                            );
                          });
                        }
                      }
                    },
                    child: const Text('Zvolit deadline'),
                  ),
                  Text('Vybraný deadline: ${DateFormat('dd.MM.yyyy HH:mm').format(dueDate)}'),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Zrušit'),
                ),
                ElevatedButton(
                  onPressed: () {
                    _editTask(index, Task(title, priority, dueDate, isDone: oldTask.isDone));
                    Navigator.pop(context);
                  },
                  child: const Text('Uložit'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: ListView.builder(
        itemCount: _tasks.length,
        itemBuilder: (context, i) {
          final task = _tasks[i];
          return ListTile(
            leading: Checkbox(
              value: task.isDone,
              onChanged: (_) => _toggleDone(i),
            ),
            title: Text(task.title),
            subtitle: Text(
              'Priorita: ${task.priority}, deadline: ${DateFormat('dd.MM.yyyy HH:mm').format(task.dueDate)}',
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => _showEditTaskDialog(i),
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => _deleteTask(i),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTaskDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}