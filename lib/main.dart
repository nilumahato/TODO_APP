import 'package:flutter/material.dart';
import 'home_page.dart';

void main() {
  runApp(TodoApp());
}

class TodoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Todo App',
      home: HomePage(),
      theme: ThemeData(
        primaryColor: Colors.blueGrey,
        textSelectionTheme: TextSelectionThemeData(
          selectionColor: Colors.blueGrey.withOpacity(0.5),
          cursorColor: Colors.blueGrey,
          selectionHandleColor: Colors.blueGrey,
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.blueGrey,
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.blueGrey,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Colors.blueGrey),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(
            foregroundColor: MaterialStateProperty.all<Color>(Colors.blueGrey),
          ),
        ),
        checkboxTheme: CheckboxThemeData(
          fillColor: MaterialStateProperty.resolveWith<Color>(
            (Set<MaterialState> states) {
              if (states.contains(MaterialState.selected)) {
                return Colors.blueGrey;
              }
              return Colors.blueGrey.withOpacity(0.5);
            },
          ),
        ),
        dialogTheme: DialogTheme(
          backgroundColor: Colors.white,
        ),
        colorScheme: ColorScheme.light(
          primary: Colors.blueGrey,
        ),
      ),
    );
  }
}
