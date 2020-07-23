import 'package:flutter/material.dart';
import 'package:mini_notebook/models/note.dart';
import 'package:mini_notebook/utils/database_helper.dart';

class NoteScreen extends StatefulWidget {
  final Note note;
  NoteScreen(this.note);
  @override
  _NoteScreenState createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
  DatabaseHelper db = new DatabaseHelper();

  TextEditingController _titleController;
  TextEditingController _contentController;

  @override
  void initState() {
    super.initState();

    _titleController = new TextEditingController(text: widget.note.title);
    _contentController = new TextEditingController(text: widget.note.content);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: BackButton(
          color: Colors.lightBlue[300],
        ),
        elevation: 0.0,
        title: TextField(
          controller: _titleController,
          decoration: InputDecoration.collapsed(
            hintText: 'Title',
            border: InputBorder.none,
          ),
          style: TextStyle(color: Colors.lightBlue[300], fontSize: 22.5),
        ),
      ),
      resizeToAvoidBottomInset: false,
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          FocusScope.of(context).unfocus();
          debugPrint('Outside pressed');
        },
        child: SafeArea(
          child: Container(
            margin: EdgeInsets.all(15.0),
            alignment: Alignment.center,
            child: Column(
              children: <Widget>[
                // TextField(
                //   controller: _titleController,
                //   decoration: InputDecoration(labelText: 'Title'),
                // ),
                // Padding(padding: EdgeInsets.all(5.0)),
                TextField(
                  controller: _contentController,
                  decoration: InputDecoration(border: InputBorder.none),
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                ),
                Padding(padding: EdgeInsets.all(5.0)),
                RaisedButton(
                  child:
                      (widget.note.id != null ? Text('Update') : Text('Add')),
                  onPressed: () {
                    if (widget.note.id != null) {
                      db
                          .updateNote(Note.fromMap(
                            {
                              'id': widget.note.id,
                              'title': _titleController.text,
                              'content': _contentController.text
                            },
                          ))
                          .then(
                            (value) => Navigator.pop(context, 'update'),
                          );
                    } else {
                      db
                          .insert(
                            Note(
                                _titleController.text, _contentController.text),
                          )
                          .then((value) => Navigator.pop(context, 'save'));
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
