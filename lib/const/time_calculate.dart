class TimeCalculate {
  static Duration TimeDif(DateTime dt) {
    var bugun = DateTime.now();
    var dif = bugun.difference(dt);
    return dif;
  }
}
