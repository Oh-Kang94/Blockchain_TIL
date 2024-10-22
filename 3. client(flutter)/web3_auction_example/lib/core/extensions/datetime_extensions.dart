extension DatetimeNullableExtensions on DateTime? {
  /// ### 'yyyy.MM.dd' 형태로 치환해서 String 출력.
  String get getDateFormat {
    if (this == null) {
      return '';
    }
    return '${this!.year}.${_addZeroIfNeeded(this!.month)}.${_addZeroIfNeeded(this!.day)}';
  }

  /// 앞에 0을 붙이는 함수 : DateTime 수정시 필요
  String _addZeroIfNeeded(int value) {
    return value < 10 ? '0$value' : '$value';
  }
}

extension DatetimeExtensions on DateTime {
  /// ### 'yyyy.MM.dd' 형태로 치환해서 String 출력.
  String get getDateFormat {
    return '$year.${_addZeroIfNeeded(month)}.${_addZeroIfNeeded(day)}';
  }

  BigInt toBigInt() {
    return BigInt.from(millisecondsSinceEpoch ~/ 1000);
  }

  /// 앞에 0을 붙이는 함수 : DateTime 수정시 필요
  String _addZeroIfNeeded(int value) {
    return value < 10 ? '0$value' : '$value';
  }
}
