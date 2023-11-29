import 'package:flutter/material.dart';
import 'task.dart';

class EditTaskPage extends StatefulWidget {
  final Task task;

  const EditTaskPage({Key? key, required this.task}) : super(key: key);

  @override
  _EditTaskPageState createState() => _EditTaskPageState();
}

class _EditTaskPageState extends State<EditTaskPage> {
  late String title;
  late String description;
  late DateTime selectedDate;
  late TimeOfDay selectedTime;
  late TaskPriority selectedPriority;

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    title = widget.task.title;
    description = widget.task.description;
    selectedDate = widget.task.date;
    selectedTime = widget.task.time;
    selectedPriority = widget.task.priority;

    titleController.text = title;
    descriptionController.text = description;
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  labelText: 'Title',
                  labelStyle: TextStyle(
                    color: Colors.blueGrey,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blueGrey, width: 2.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.blueGrey.withOpacity(1.0),
                    ),
                  ),
                ),
                style: TextStyle(color: Colors.blueGrey),
                onChanged: (value) {
                  setState(() {
                    title = value;
                  });
                },
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(
                  labelText: 'Description',
                  labelStyle: TextStyle(
                    color: Colors.blueGrey,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blueGrey, width: 2.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.blueGrey.withOpacity(1.0),
                    ),
                  ),
                ),
                style: TextStyle(color: Colors.blueGrey),
                onChanged: (value) {
                  setState(() {
                    description = value;
                  });
                },
              ),
              SizedBox(height: 10),
              DropdownButtonFormField<TaskPriority>(
                value: selectedPriority,
                onChanged: (TaskPriority? newValue) {
                  setState(() {
                    if (newValue != null) {
                      selectedPriority = newValue;
                    }
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Priority',
                  labelStyle: TextStyle(color: Colors.blueGrey),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blueGrey),
                  ),
                ),
                dropdownColor: Colors.white,
                style: TextStyle(color: Colors.blueGrey),
                icon: Icon(Icons.arrow_drop_down, color: Colors.blueGrey),
                items: TaskPriority.values.map((TaskPriority priority) {
                  return DropdownMenuItem<TaskPriority>(
                    value: priority,
                    child: Text(
                      "${priority.toShortString().toUpperCase()}",
                      style: TextStyle(color: Colors.blueGrey),
                    ),
                  );
                }).toList(),
              ),
              TextButton(
                onPressed: () async {
                  final DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: selectedDate,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                    builder: (BuildContext context, Widget? child) {
                      return Theme(
                        data: ThemeData.light().copyWith(
                          primaryColor: Colors.blueGrey,
                          colorScheme: ColorScheme.light(
                            primary: Colors.blueGrey,
                          ),
                          buttonTheme: ButtonThemeData(
                            textTheme: ButtonTextTheme.primary,
                          ),
                        ),
                        child: child!,
                      );
                    },
                  );

                  if (pickedDate != null && pickedDate != selectedDate) {
                    setState(() {
                      selectedDate = pickedDate;
                    });
                  }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(Icons.calendar_today, color: Colors.blueGrey),
                    Text(
                      'Select Date: ${selectedDate.toString().substring(0, 10)}',
                      style: TextStyle(color: Colors.blueGrey, fontSize: 16),
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: () async {
                  final TimeOfDay? pickedTime = await showTimePicker(
                    context: context,
                    initialTime: selectedTime,
                    builder: (BuildContext context, Widget? child) {
                      return Theme(
                        data: ThemeData.light().copyWith(
                          primaryColor: Colors.blueGrey,
                          colorScheme: ColorScheme.light(
                            primary: Colors.blueGrey,
                          ),
                          buttonTheme: ButtonThemeData(
                            textTheme: ButtonTextTheme.primary,
                          ),
                        ),
                        child: child!,
                      );
                    },
                  );

                  if (pickedTime != null && pickedTime != selectedTime) {
                    setState(() {
                      selectedTime = pickedTime;
                    });
                  }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(Icons.access_time, color: Colors.blueGrey),
                    Text(
                      'Select Time: ${selectedTime.format(context)}',
                      style: TextStyle(color: Colors.blueGrey, fontSize: 16),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Task updatedTask = Task(
                    title: titleController.text,
                    description: descriptionController.text,
                    date: selectedDate,
                    time: selectedTime,
                    priority: selectedPriority,
                    isCompleted: widget.task.isCompleted,
                  );
                  Navigator.of(context).pop(updatedTask);

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Task updated!'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
                child: Text(
                  'Update Task',
                  style: TextStyle(color: Colors.black),
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
