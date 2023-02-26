import 'package:bloc/bloc.dart';
import 'package:cutopy/bloc/note_repository.dart';

import '../modal/bilgi.dart';
import 'note_satete.dart';

class NotesCubit extends Cubit<NoteState> {
  NotesCubit({required this.repository, this.selectedCardNumber = -1}) : super(NoteInitial()) {
    getNotes();
    // selectCard(-1);
  }
  final NoteRepository repository;
  int selectedCardNumber;
  List<Note> noteList = [];

  Future<void> getNotes() async {
    emit(NoteLoading());
    noteList = await repository.fetchNotes();
    emit(NoteLoaded(noteList));
  }

  void DeleteNotes(int index) {
    repository.deleteNotes(index);
    selectCard(-1);
  }

  void addNote(Note note) {
    repository.addNote(note);

    getNotes();
  }

  void selectCard(int i) async {
    if (selectedCardNumber != i) {
      this.selectedCardNumber = i;
    } else {
      this.selectedCardNumber = -1;
    }
    getNotes();
  }

  void updateCard(int i, Note note) {
    repository.updateNotes(i, note);
    getNotes();
  }
}
