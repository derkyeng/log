import 'package:flutter/material.dart';
import 'package:mini_notebook/models/note.dart';
import 'package:mini_notebook/utils/database_helper.dart';
import 'package:mini_notebook/screens/note_screen.dart';

class NotebookPage extends StatefulWidget {
  @override
  _NotebookPageState createState() => _NotebookPageState();
}

class _NotebookPageState extends State<NotebookPage> {
  List<Note> notes = new List();
  DatabaseHelper db = new DatabaseHelper();

  @override
  void initState() {
    super.initState();

    db.getAllNotes().then((tasks) {
      setState(() {
        tasks.forEach((element) {
          notes.add(Note.fromMap(element));
        });
      });
    });
  }

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
                subtitle: Text(notes[index].content),
                onTap: () {
                  debugPrint('$index tapped');
                },
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _createNewNote(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _createNewNote(BuildContext context) async {
    String result = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => NoteScreen(Note('', ''))));

    if (result == 'save') {
      db.getAllNotes().then((tasks) {
        setState(() {
          notes.clear();
          tasks.forEach((element) {
            notes.add(Note.fromMap(element));
          });
        });
      });
    }
  }
}
