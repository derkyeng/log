import 'package:flutter/material.dart';
import 'package:mini_notebook/screens/notebook.dart';

void main() {
  runApp(NotebookApp());
}

class NotebookApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mini Notebook',
      debugShowCheckedModeBanner: false,
      home: NotebookPage(),
    );
  }
}
