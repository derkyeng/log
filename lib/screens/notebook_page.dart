import 'package:flutter/material.dart';
import 'package:mini_notebook/models/note.dart';
import 'package:mini_notebook/utils/database_helper.dart';
import 'package:mini_notebook/screens/note_screen.dart';

class NotebookPage extends StatefulWidget {
  @override
  _NotebookPageState createState() => _NotebookPageState();
}

class _NotebookPageState extends State<NotebookPage> {
  List<Color> noteColors = [
    Colors.lightBlue[200],
    Colors.lightBlue[300],
    Colors.green[300],
    Colors.blue[100]
  ];
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
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Notebook',
          style: TextStyle(
            color: Colors.lightBlue[200],
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        actions: <Widget>[
          IconButton(
            color: Colors.lightBlue[200],
            icon: Icon(Icons.add),
            onPressed: () => _createNewNote(context),
          )
        ],
      ),
      body: SafeArea(
        child: GridView.builder(
          itemCount: notes.length,
          gridDelegate:
              SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
          itemBuilder: (context, index) {
            return Card(
              color: Colors.lightBlue[300],
              child: Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  ListTile(
                    contentPadding: EdgeInsets.fromLTRB(10.0, 2.0, 5.0, 0),
                    title: Text(notes[index].title),
                    subtitle: Text(
                      notes[index].content,
                      overflow: TextOverflow.ellipsis,
                    ),
                    onTap: () {
                      _navigateToNote(context, notes[index]);
                      debugPrint('$index tapped');
                    },
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: IconButton(
                      focusColor: Colors.black,
                      icon: Icon(Icons.delete),
                      onPressed: () =>
                          _deleteNote(context, notes[index], index),
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
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

  void _navigateToNote(BuildContext context, Note note) async {
    String result = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => NoteScreen(note)));

    if (result == 'update') {
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

  void _deleteNote(BuildContext context, Note note, int position) async {
    db.delete(note.id).then((note) {
      setState(() {
        notes.removeAt(position);
      });
    });
  }
}
