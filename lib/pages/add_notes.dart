import 'package:cutopy/const/string_const.dart';
import 'package:cutopy/const/time_calculate.dart';
import 'package:cutopy/modal/bilgi.dart';
import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:unfocus_widget/unfocus_widget.dart';

class NoteForm extends StatefulWidget {
  const NoteForm({Key? key, this.note}) : super(key: key);
  final Note? note;
  @override
  State<NoteForm> createState() => _NoteFormState();
}

class _NoteFormState extends State<NoteForm> {
  final TextEditingController _baslikController = TextEditingController();
  final TextEditingController _textController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  DateTime alarmTime = DateTime.now();
  bool setAlarm = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var note = widget.note?.text;
    _textController.text = note ?? "";
    _baslikController.text = (widget.note?.baslik) ?? "";
    if (widget.note != null) {
      var dif = TimeCalculate.TimeDif(widget.note!.alarm);
      if (dif.isNegative) {
        setAlarm = true;
        alarmTime = widget.note!.alarm;
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        saveNotes(context);
        return Future.value(true);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppString.formCaptionTitle),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.cancel)),
            IconButton(
                onPressed: () {
                  _showDateTimeDialog(context);
                },
                icon: const Icon(Icons.alarm))
          ],
        ),
        body: SingleChildScrollView(
          child: Form(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              textForm(_baslikController, AppString.formTitle, 1, context, Icons.title),
              setAlarm ? alarmContainer() : const SizedBox(),
              textForm(_textController, AppString.formBody, 30, context, Icons.text_fields),
              ElevatedButton(
                  onPressed: () {
                    saveNotes(context);
                  },
                  child: const Text("Kaydet")),
            ],
          )),
        ),
      ),
    );
  }

  Container alarmContainer() {
    return Container(
      color: Colors.grey,
      child: Text(DateFormat("dd-MM-yyyy hh:mm").format(alarmTime)),
    );
  }

  void saveNotes(BuildContext context) {
    var result = Note(_baslikController.text, _textController.text);
    result.alarm = alarmTime;
    Navigator.pop(context, result);
  }

  Widget textForm(TextEditingController controller, String? title, int maxLines, BuildContext context, IconData icon) {
    double borderSide = 20;
    double circularValue = 10;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: UnFocusWidget(
        child: TextFormField(
          //focusNode: _focusNode,
          controller: controller,
          maxLines: maxLines,
          style: Theme.of(context).textTheme.bodyLarge,
          decoration: InputDecoration(
            hintText: title,
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }

  void _showDateTimeDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Center(
          child: Container(
            color: Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: Text(
                    
                    "Hat??rlatma Zaman??n?? ayarlay??n.",
                    style: Theme.of(context).textTheme.headlineMedium,
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 50  ,),
                dateTimeForm(context),
              ],
            ),
          ),
        );
      },
    );

    // showDialog(
    //   context: context,
    //   builder: (context) {
    //     return Center(
    //         child: Container(
    //           color: Colors.white,
    //           child: Column(
    //             mainAxisAlignment: MainAxisAlignment.center,
    //             mainAxisSize: MainAxisSize.min,
    //             children: [
    //              dateTimeForm(context),
    //             ],
    //           ),
    //         ),
    //       );
    //   },
    // );
  }

  DateTimeFormField dateTimeForm(BuildContext context) {
    return DateTimeFormField(
      firstDate: DateTime.now(),
      use24hFormat: true,
      decoration: const InputDecoration(
        hintStyle: TextStyle(color: Colors.black45),
        errorStyle: TextStyle(color: Colors.redAccent),
        border: OutlineInputBorder(),
        suffixIcon: Icon(Icons.event_note),
        labelText: ' Hat??rlatma Zaman??',
      ),
      mode: DateTimeFieldPickerMode.dateAndTime,
      autovalidateMode: AutovalidateMode.always,
      validator: (e) {
        if (e != null) {
          var bugun = DateTime.now();
          var dif = bugun.difference(e) * -1;
          print(dif);
        }
        return null;
      },
      onDateSelected: (DateTime value) {
        print(value);

        setState(() {
          alarmTime = value;
          setAlarm = true;
          Navigator.pop(context);
        });
      },
    );
  }
}
