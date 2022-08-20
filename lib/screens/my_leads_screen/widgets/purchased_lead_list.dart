import 'package:flutter/material.dart';
import 'package:lead_selling/models/coordinates.dart';
import 'package:lead_selling/models/purchased_lead.dart';
import 'package:lead_selling/constants.dart';

import 'package:lead_selling/widgets/cell_text.dart';

class PurchasedLeadList extends StatefulWidget {
  final List<PurchasedLead> leads;

  const PurchasedLeadList({
    Key? key,
    required this.leads,
  }) : super(key: key);

  @override
  State<PurchasedLeadList> createState() => _PurchasedLeadListState();
}

class _PurchasedLeadListState extends State<PurchasedLeadList> {
  Map<String, dynamic> getRelativeTime(DateTime date) {
    var now = DateTime.now();
    final difference = now.difference(date);
    final totalMinutes = difference.inMinutes;
    final minutes = totalMinutes % 60;
    final hours = (totalMinutes / 60).floor();
    final days = difference.inDays;
    if (hours == 0) {
      return {
        'text': '$minutes mins ago',
        'totalMinutes': totalMinutes,
      };
    } else if (hours > 0 && hours <= 48) {
      return {
        'text': '$hours hrs ago',
        'totalMinutes': totalMinutes,
      };
    } else if (hours > 48) {
      return {
        'text': '$days days ago',
        'totalMinutes': totalMinutes,
      };
    } else {
      return {
        'text': 'Undefined',
        'totalMinutes': totalMinutes,
      };
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Table(
          children: [
            TableRow(
              children: [
                CellText(
                  'Purchased',
                  textStyle: tableHeader,
                ),
                CellText(
                  'Signed up',
                  textStyle: tableHeader,
                ),
                CellText(
                  'Zip Code',
                  textStyle: tableHeader,
                ),
                CellText(
                  'Condition',
                  textStyle: tableHeader,
                ),
                CellText(
                  'Treatment',
                  textStyle: tableHeader,
                ),
                CellText(
                  'Phone',
                  textStyle: tableHeader,
                ),
                CellText(
                  'Email',
                  textStyle: tableHeader,
                ),
              ],
            ),
          ],
        ),
        Table(
          border: TableBorder.symmetric(
            inside: BorderSide(color: Colors.grey),
            outside: BorderSide(color: Colors.black),
          ),
          children: [
            ...widget.leads.indexedMap(
              (lead, i) {
                return TableRow(
                  children: [
                    // TODO change to purchased time

                    CellText(DateTime.now().toString()),
                    CellText(getRelativeTime(lead.dateAdded.toDate())['text']),
                    CellText(lead.zipCode ?? '?'),
                    CellText(lead.condition.toTitleCase()),
                    CellText('HBOT'),
                    CellText(lead.phone),
                    CellText(lead.email),
                  ],
                );
              },
            ).toList(),
          ],
        ),
      ],
    );
  }
}
