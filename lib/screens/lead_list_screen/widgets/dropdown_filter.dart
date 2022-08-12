import 'package:flutter/material.dart';
import 'package:lead_selling/constants.dart';

class DropdownFilter extends StatelessWidget {
  final Object value;
  final List<Object> allValues;
  final List<String> allTexts;
  final void Function(dynamic) onChanged;

  const DropdownFilter({
    Key? key,
    required this.value,
    required this.allValues,
    required this.allTexts,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(4),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton(
          dropdownColor: Colors.grey[300],
          isDense: true,
          value: value,
          items: <DropdownMenuItem<Object>>[
            ...allValues
                .indexedMap(
                  (x, i) => DropdownMenuItem(
                    value: x,
                    child: Text(
                      allTexts[i],
                    ),
                    onTap: () {
                      onChanged(x);
                    },
                  ),
                )
                .toList(),
          ],
          onChanged: (value) {},
        ),
      ),
    );
  }
}

// DropdownButton(
// value: relativeTime,
// items: <DropdownMenuItem<RelativeTime>>[
// ...RelativeTime.values
//     .map(
// (time) => DropdownMenuItem(
// value: time,
// child: Text(
// time.name.replaceAll('_', ' '),
// ),
// onTap: () {
// setState(() {
// relativeTime = time;
// });
// },
// ),
// )
// .toList(),
// ],
// onChanged: (value) {},
// ),
