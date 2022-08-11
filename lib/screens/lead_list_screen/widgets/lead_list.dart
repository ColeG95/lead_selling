import 'package:flutter/material.dart';
import 'package:lead_selling/models/coordinates.dart';
import 'package:lead_selling/models/unpurchased_lead.dart';
import 'package:lead_selling/constants.dart';

import 'cell_text.dart';

class LeadList extends StatefulWidget {
  final List<UnpurchasedLead> leads;
  final List<UnpurchasedLead> cart;

  const LeadList({
    Key? key,
    required this.leads,
    required this.cart,
  }) : super(key: key);

  @override
  State<LeadList> createState() => _LeadListState();
}

class _LeadListState extends State<LeadList> {
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
                  'Price',
                  textStyle: tableHeader,
                ),
                CellText(
                  'Add to Cart',
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
                bool leadSelected = widget.cart.contains(lead);
                return TableRow(
                  children: [
                    CellText(getRelativeTime(lead.dateAdded.toDate())['text']),
                    CellText(lead.zipCode ?? '?'),
                    CellText(lead.condition.toTitleCase()),
                    CellText('HBOT'),
                    CellText('\$100'),
                    Checkbox(
                      value: leadSelected,
                      onChanged: (value) {
                        if (leadSelected) {
                          setState(() {
                            widget.cart.remove(lead);
                          });
                        } else {
                          setState(() {
                            widget.cart.add(lead);
                          });
                        }
                      },
                    ),
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
