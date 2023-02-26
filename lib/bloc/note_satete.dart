import 'package:equatable/equatable.dart';

import '../modal/bilgi.dart';

abstract class NoteState extends Equatable {
  const NoteState();
}

class NoteInitial extends NoteState {
  @override
  List<Object?> get props => throw UnimplementedError();
}

class NoteLoading extends NoteState {
  @override
  List<Object?> get props => throw UnimplementedError();
}

class NoteLoaded extends NoteState {
  final List<Note> noteList;

  NoteLoaded(this.noteList);
  @override
  List<Object?> get props => [noteList];
}

class NoteCardSelectState extends NoteState {
  final int selectedCard;

  NoteCardSelectState(this.selectedCard);
  @override
  List<Object?> get props => [selectedCard];
}
