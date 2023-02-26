import 'package:cutopy/const/string_const.dart';
import 'package:cutopy/modal/bilgi.dart';
import 'package:flutter/material.dart';
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var note = widget.note?.text;
    _textController.text = note ?? "";
    _baslikController.text = (widget.note?.baslik) ?? "";
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
                icon: const Icon(Icons.cancel))
          ],
        ),
        body: SingleChildScrollView(
          child: Form(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              textForm(_baslikController, AppString.formTitle, 1, context, Icons.title),
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

  void saveNotes(BuildContext context) {
    var result = Note(_baslikController.text, _textController.text);
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
          style: Theme.of(context).textTheme.bodyText1,
          decoration: InputDecoration(
            hintText: title,
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }
}
