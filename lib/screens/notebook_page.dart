import 'package:flutter/material.dart';
import 'package:mini_notebook/models/note.dart';

class NotebookPage extends StatefulWidget {
  @override
  _NotebookPageState createState() => _NotebookPageState();
}

class _NotebookPageState extends State<NotebookPage> {
  List<Note> notes = [
    Note('Note 1', 'Contents of Note 1'),
    Note('Note 2', 'Contents of Note 2'),
    Note('Note 3', 'Contents of Note 3'),
    Note('Note 4', 'Contents of Note 4'),
    Note('Note 5', 'Contents of Note 5'),
    Note('Note 6', 'Contents of Note 6'),
    Note('Note 7', 'Contents of Note 7'),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GridView.builder(
          itemCount: notes.length,
          gridDelegate:
              SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
          itemBuilder: (context, index) {
            return Card(
              color: Colors.lightBlue,
              child: ListTile(
                title: Text(notes[index].title),
                subtitle: Text(notes[index].contents),
                onTap: () {
                  debugPrint('$index tapped');
                },
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
      ),
    );
  }
}
