import 'package:hive/hive.dart';

import '../modal/bilgi.dart';

class NoteRepository {
  final String boxName = "notes";
  Future<List<Note>> fetchNotes() async {
    var box = await Hive.box<Note>(boxName);
    List<Note> list = box.keys.map((key) {
      Note v = box.get(key) ?? Note("empty", "empty");
      return v;
    }).toList();
    return list;
  }

  addNotes(List<Note> notlar) async {
    // Hive.registerAdapter(NoteAdapter());
    var box = await Hive.box<Note>(boxName);
    await box.addAll(notlar);
    // print(box.toMap().toString());
  }

  addNote(Note note) async {
    var box = await Hive.box<Note>(boxName);
    box.add(note);
  }

  Future<void> deleteNotes(int index) async {
    var box = await Hive.box<Note>(boxName);
    await box.deleteAt(index);
  }

  updateNotes(int index, Note note) async {
    var box = await Hive.box<Note>(boxName);
    await box.putAt(index, note);
    
  }
}
