class Note {
  String _title;
  String _contents;
  int _index;

  Note(String title, String contents) {
    _title = title;
    _contents = contents;
  }

  String get title => _title;
  String get contents => _contents;
}
