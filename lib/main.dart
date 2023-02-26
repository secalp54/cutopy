
import 'package:cutopy/pages/main_page.dart';
import 'package:cutopy/thema/theme.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'modal/bilgi.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(NoteAdapter());
  await Hive.openBox<Note>("notes");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cutopy',
      home: MainPage(),
      theme: AppTheme().lightTheme(),
      debugShowCheckedModeBanner: false,
    );
  }
}
