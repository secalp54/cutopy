import 'package:hive/hive.dart';
part 'bilgi.g.dart';

@HiveType(typeId: 1)
class Note {
  @HiveField(0)
  final String baslik;
  @HiveField(1)
  final String text;

  @HiveField(2)
  final int selectIndex = 0;

  @HiveField(3)
  DateTime alarm = DateTime.now();

  Note(this.baslik, this.text);
  @override
  String toString() {
    // TODO: implement toString
    return this.baslik;
  }
}
