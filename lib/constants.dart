import 'package:flutter/cupertino.dart';

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

enum RelativeDistance {
  Within_20_Miles,
  Within_30_Miles,
  Within_50_Miles,
  Anywhere,
}
