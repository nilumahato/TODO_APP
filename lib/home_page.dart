import 'package:flutter/material.dart';
import 'task.dart';
import 'add_task_page.dart';
import 'edit_task_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Task> tasks = [];
  String searchText = '';

  void completeOrDeleteTask(int index, {bool isDelete = false}) {
    setState(() {
      if (isDelete) {
        tasks.removeAt(index);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Task deleted!'),
            duration: Duration(seconds: 2),
          ),
        );
      } else {
        bool previousCompletionStatus = tasks[index].isCompleted;
        tasks[index].isCompleted = !tasks[index].isCompleted;

        if (tasks[index].isCompleted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Task completed!'),
              duration: Duration(seconds: 2),
            ),
          );
        } else {
          String statusMessage = previousCompletionStatus
              ? 'Task marked as pending again!'
              : 'Task is still pending!';
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(statusMessage),
              duration: Duration(seconds: 2),
            ),
          );
        }
      }
    });
  }

  Card buildTaskCard(Task task, int index) {
    return Card(
      elevation: 3,
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      color: Colors.grey[200],
      child: ListTile(
        contentPadding: EdgeInsets.all(16),
        leading: Checkbox(
          value: task.isCompleted,
          onChanged: (value) {
            setState(() {
              completeOrDeleteTask(index);
            });
          },
        ),
        title: Text(
          task.title,
          style: TextStyle(
            color: task.isCompleted ? Colors.blueGrey : Colors.black,
            fontWeight: task.isCompleted ? FontWeight.normal : FontWeight.bold,
            decoration: task.isCompleted
                ? TextDecoration.lineThrough
                : TextDecoration.none,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              task.description,
              style: TextStyle(color: Colors.blueGrey),
            ),
            SizedBox(height: 4),
            Text(
              'Date: ${task.date.toString().substring(0, 10)}',
              style: TextStyle(color: Colors.blueGrey),
            ),
            SizedBox(height: 4),
            Text(
              'Time: ${task.time.format(context)}',
              style: TextStyle(color: Colors.blueGrey),
            ),
            SizedBox(height: 4),
            Text(
              'Priority: ${task.priority.toShortString().toUpperCase()}',
              style: TextStyle(color: Colors.blueGrey),
            ),
          ],
        ),
        onTap: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => EditTaskPage(task: task)),
          );
          if (result != null) {
            setState(() {
              tasks[index] = result;
            });
          }
        },
      ),
    );
  }

  List<Task> getTasksSortedByPriority() {
    List<Task> sortedTasks = List.from(tasks);
    sortedTasks.sort((a, b) => b.priority.index.compareTo(a.priority.index));
    return sortedTasks;
  }

  @override
  Widget build(BuildContext context) {
    List<Task> sortedTasks = getTasksSortedByPriority();
    List<Task> filteredTasks = sortedTasks.where((task) {
      final title = task.title.toLowerCase();
      final description = task.description.toLowerCase();
      final query = searchText.toLowerCase();

      return title.contains(query) || description.contains(query);
    }).toList();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Todo App',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Search',
                prefixIcon: Icon(Icons.search, color: Colors.blueGrey),
                labelStyle: TextStyle(color: Colors.blueGrey),
                filled: true,
                fillColor: Colors.grey[200],
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  borderSide: BorderSide(color: Colors.transparent),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  borderSide: BorderSide(color: Colors.transparent),
                ),
              ),
              style: TextStyle(color: Colors.blueGrey),
              onChanged: (value) {
                setState(() {
                  searchText = value;
                });
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Tasks',
              style: TextStyle(
                color: Colors.blueGrey,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          filteredTasks.isEmpty
              ? Center(
                  child: Text(
                    'No tasks yet!',
                    style: TextStyle(color: Colors.blueGrey),
                  ),
                )
              : Expanded(
                  child: ListView.builder(
                    itemCount: filteredTasks.length,
                    itemBuilder: (context, index) {
                      return Dismissible(
                        key: Key(tasks[index].title),
                        direction: DismissDirection.horizontal,
                        background: Container(
                          color: Colors.red,
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.symmetric(horizontal: 20.0),
                          child: Icon(Icons.delete, color: Colors.white),
                        ),
                        secondaryBackground: Container(
                          color: Colors.red,
                          alignment: Alignment.centerRight,
                          padding: EdgeInsets.symmetric(horizontal: 20.0),
                          child: Icon(Icons.delete, color: Colors.white),
                        ),
                        confirmDismiss: (DismissDirection direction) async {
                          return await showDialog(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                              title: Text("Confirm"),
                              content: Text(
                                  "Are you sure you want to delete this task?"),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(false),
                                  child: Text("Cancel"),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(true);
                                    completeOrDeleteTask(index, isDelete: true);
                                  },
                                  child: Text("Delete"),
                                ),
                              ],
                            ),
                          );
                        },
                        child: buildTaskCard(filteredTasks[index], index),
                      );
                    },
                  ),
                ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddTaskPage()),
          );
          if (result != null) {
            setState(() {
              tasks.add(result);
            });
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
