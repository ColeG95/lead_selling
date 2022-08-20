import 'package:flutter/material.dart';

class CellText extends StatelessWidget {
  final String label;
  final TextStyle? textStyle;

  CellText(this.label, {this.textStyle});

  @override
  Widget build(BuildContext context) {
    return TableCell(
      verticalAlignment: TableCellVerticalAlignment.middle,
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: textStyle,
      ),
    );
  }
}
