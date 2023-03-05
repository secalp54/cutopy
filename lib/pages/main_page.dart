// ignore_for_file: prefer_interpolation_to_compose_strings

import 'package:clipboard/clipboard.dart';
import 'package:cutopy/bloc/note_cubit.dart';
import 'package:cutopy/bloc/note_repository.dart';
import 'package:cutopy/bloc/note_satete.dart';
import 'package:cutopy/const/string_const.dart';
import 'package:cutopy/const/time_calculate.dart';
import 'package:cutopy/pages/add_notes.dart';
import 'package:cutopy/services/notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';

import '../modal/bilgi.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  void initState() {
    // TODO: implement initState
    Noti(context).Initialize(flutterLocalNotificationsPlugin);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // ignore: missing_required_param
    final NoteRepository repository = NoteRepository();
    return BlocProvider<NotesCubit>(
      create: (context) => NotesCubit(repository: repository),
      child: MainPageView(),
    );
  }
}

// ignore: must_be_immutable
class MainPageView extends StatelessWidget {
  MainPageView({Key? key}) : super(key: key);
  int selectedCard = 0;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotesCubit, NoteState>(
      builder: (context, state) {
        selectedCard = context.select<NotesCubit, int>((e) => (e.selectedCardNumber));
        //print(selectedCard);
        return Scaffold(
          appBar: AppBar(
            title: Text(
              AppString.appName,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            actions: [
              Visibility(
                visible: selectedCard > -1 ? true : false,
                child: IconButton(
                    onPressed: () {
                      context.read<NotesCubit>().DeleteNotes(selectedCard);
                    },
                    icon: Icon(
                      Icons.delete,
                      color: Colors.blueGrey[900],
                    )),
              )
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              await fabButton(context);
            },
            child: const Icon(Icons.add_comment),
          ),
          body: stateBuilder(state, context),
        );
      },
    );
  }

  Future<void> fabButton(BuildContext context) async {
    var note = await Navigator.of(context).push<Note>(MaterialPageRoute(builder: ((context) => NoteForm())));
    if (note != null) {
      if (note!.baslik != "" || note.text != "") {
        // ignore: use_build_context_synchronously
        context.read<NotesCubit>().addNote(note);
        var fark = TimeCalculate.TimeDif(note.alarm);
        if (fark.isNegative) await Noti(context).zonedScheduleNotification(note.alarm, note.baslik, note.text);
      }
    }
  }

  Widget gridBuilder(List<Note> noteList, BuildContext context) {
    int _crossCount = 2;

    return noteList.length == 0
        ? Center(
            child: Padding(
            padding: const EdgeInsets.all(50.0),
            child: Text(
              AppString.firstMessage,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ))
        : GridView.builder(
            itemCount: noteList.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: _crossCount),
            itemBuilder: ((context, index) {
              return GestureDetector(
                child: cardBuilder(context, noteList[index], index),
                onDoubleTap: (() async {
                  var value = await Navigator.of(context)
                      .push<Note>(MaterialPageRoute(builder: ((context) => NoteForm(note: noteList[index]))));
                  if (value != null) {
                    context.read<NotesCubit>().updateCard(index, value);
                    var fark = TimeCalculate.TimeDif(value.alarm);
                    if (fark.isNegative) {
                      await Noti(context).zonedScheduleNotification(value.alarm, value.baslik, value.text);
                    }
                  }
                }),
                onLongPress: () async {
                  var message = noteList[index].text;
                  FlutterClipboard.copy(message);
                  showMessage(message, context);
                  //  Noti.showBigTextNoti(title: "uy", body: "body", fln: flutterLocalNotificationsPlugin);
                },
                onTap: () {
                  context.read<NotesCubit>().selectCard(index);
                },
              );
            }));
  }

  Widget cardBuilder(BuildContext context, Note note, int index) {
    return Card(
        color: selectedCard == index ? Colors.blue[100] : Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: RichText(
            maxLines: 5,
            text: cardText(context, note),
          ),
        ));
  }

  TextSpan cardText(BuildContext context, Note note) {
    return TextSpan(
      text: "${note.baslik}\n\n",
      style: Theme.of(context).textTheme.titleMedium,
      children: <TextSpan>[
        // TextSpan(text: 'bold', style: TextStyle(fontWeight: FontWeight.bold)),
        TextSpan(text: note.text, style: Theme.of(context).textTheme.bodyText1),
      ],
    );
  }

  stateBuilder(NoteState state, BuildContext context) {
    if (state is NoteLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (state is NoteLoaded) {
      return gridBuilder(state.noteList, context);
    } else
      return Text(AppString.errMessaj);
  }

  void showMessage(String message, BuildContext context) {
    int max = 40;
    int aniTime = 3;
    message = message.substring(0, max < message.length ? max : message.length - 1);
    message += AppString.toastMessage;
    showToast(message, context: context, duration: Duration(seconds: aniTime));
  }
}
