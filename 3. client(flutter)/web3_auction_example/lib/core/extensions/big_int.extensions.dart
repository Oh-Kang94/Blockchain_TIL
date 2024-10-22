extension BigintExtensions on BigInt {
  // BigInt를 DateTime으로 변환
  DateTime toDateTime() {
    return DateTime.fromMillisecondsSinceEpoch(toInt() * 1000);
  }
}
