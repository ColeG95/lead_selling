import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lead_selling/constants.dart';
import 'package:lead_selling/models/coordinates.dart';
import 'package:lead_selling/models/unpurchased_lead.dart';
import 'package:lead_selling/screens/lead_list_screen/widgets/dropdown_filter.dart';
import 'package:lead_selling/screens/lead_list_screen/widgets/lead_list.dart';

class LeadListScreen extends StatefulWidget {
  const LeadListScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<LeadListScreen> createState() => _LeadListScreenState();
}

class _LeadListScreenState extends State<LeadListScreen> {
  List<UnpurchasedLead> leads = [];
  List<UnpurchasedLead> cart = [];
  bool isLoading = false;
  TextEditingController locationController = TextEditingController();
  RelativeTime relativeTime = RelativeTime.Last_2_Weeks;
  RelativeDistance relativeDistance = RelativeDistance.Within_30_Miles;

  void loadLeads(Coordinates? buyerCoordinates, String? buyerZip,
      UnpurchasedLead? startAfterLead) async {
    setState(() {
      isLoading = true;
    });
    if (startAfterLead == null) leads.clear();
    final leadsGet = startAfterLead == null
        ? await FirebaseFirestore.instance
            .collection('leads')
            .orderBy('dateAdded', descending: true)
            .limit(3)
            .get()
        : await FirebaseFirestore.instance
            .collection('leads')
            .orderBy('dateAdded', descending: true)
            .startAfter([startAfterLead.dateAdded])
            .limit(3)
            .get();
    for (var doc in leadsGet.docs) {
      final data = doc.data();
      leads.add(
        UnpurchasedLead(
          condition: data['condition'],
          dateAdded: data['dateAdded'],
          deviceId: data['deviceId'],
          docId: doc.id,
          coordinates: data['coordinates']['latitude'] != null
              ? Coordinates(
                  latitude: data['coordinates']['latitude'],
                  longitude: data['coordinates']['longitude'],
                )
              : null,
          zipCode: data['zipCode'],
        ),
      );
    }
    setState(() {
      isLoading = false;
    });
  }

  void selectTimeFilter(dynamic time) {
    setState(() {
      relativeTime = time;
    });
  }

  void selectDistanceFilter(dynamic distance) {
    setState(() {
      relativeDistance = distance;
    });
  }

  @override
  void initState() {
    super.initState();

    loadLeads(null, null, null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('test'),
        backgroundColor: Colors.grey[800],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DropdownFilter(
                  value: relativeTime,
                  allValues: RelativeTime.values,
                  allTexts: RelativeTime.values
                      .map((e) => e.name.replaceAll('_', ' '))
                      .toList(),
                  onChanged: selectTimeFilter,
                ),
                DropdownFilter(
                  value: relativeDistance,
                  allValues: RelativeDistance.values,
                  allTexts: RelativeDistance.values
                      .map((e) => e.name.replaceAll('_', ' '))
                      .toList(),
                  onChanged: selectDistanceFilter,
                )
              ],
            ),
            Container(
              margin: const EdgeInsets.all(20),
              child: LeadList(
                leads: leads,
                cart: cart,
              ),
            ),
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : ElevatedButton(
                    onPressed: () {
                      print(leads.last.docId);
                      loadLeads(null, null, leads.last);
                    },
                    child: const Text('Load More'),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.grey[800],
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
