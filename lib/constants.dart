import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

extension IndexedIterable<E> on Iterable<E> {
  Iterable<T> indexedMap<T>(T Function(E element, int index) f) {
    var index = 0;
    return map((e) => f(e, index++));
  }
}

extension StringCasingExtension on String {
  String toCapitalized() =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';
  String toTitleCase() => replaceAll(RegExp(' +'), ' ')
      .split(' ')
      .map((str) => str.toCapitalized())
      .join(' ');
}

TextStyle tableHeader = const TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.bold,
);

enum RelativeTime {
  Last_24_Hours,
  Last_3_Days,
  Last_7_Days,
  Last_2_Weeks,
  Last_4_Weeks,
  Anytime,
}

Map<RelativeTime, dynamic> relativeTimeDate = {
  RelativeTime.Last_24_Hours: DateTime.now().subtract(Duration(hours: 24)),
  RelativeTime.Last_3_Days: DateTime.now().subtract(Duration(hours: 72)),
  RelativeTime.Last_7_Days: DateTime.now().subtract(Duration(hours: 168)),
  RelativeTime.Last_2_Weeks: DateTime.now().subtract(Duration(hours: 336)),
  RelativeTime.Last_4_Weeks: DateTime.now().subtract(Duration(hours: 672)),
  RelativeTime.Anytime: DateTime.now().subtract(Duration(days: 300)),
};

enum RelativeDistance {
  Within_20_Miles,
  Within_30_Miles,
  Within_50_Miles,
  Anywhere,
}

const Color themeColor = Colors.lightBlueAccent;
