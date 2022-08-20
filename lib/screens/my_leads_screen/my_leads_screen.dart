import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lead_selling/models/purchased_lead.dart';
import 'package:lead_selling/models/coordinates.dart';
import 'package:lead_selling/screens/my_leads_screen/widgets/purchased_lead_list.dart';

class MyLeadsScreen extends StatefulWidget {
  const MyLeadsScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<MyLeadsScreen> createState() => _MyLeadsScreenState();
}

class _MyLeadsScreenState extends State<MyLeadsScreen> {
  List<PurchasedLead> leads = [];
  bool isLoading = false;

  void loadLeads(Coordinates? buyerCoordinates, String? buyerZip,
      PurchasedLead? startAfterLead) async {
    setState(() {
      isLoading = true;
    });
    if (startAfterLead == null) {
      leads.clear();
    }
    final leadsGet = startAfterLead == null
        ? await FirebaseFirestore.instance
            .collection('leads')
            // .where('dateAdded', isGreaterThan: relativeTimeDate[relativeTime])
            .orderBy('dateAdded', descending: true)
            .limit(3)
            .get()
        : await FirebaseFirestore.instance
            .collection('leads')
            // .where('dateAdded', isGreaterThan: relativeTimeDate[relativeTime])
            .orderBy('dateAdded', descending: true)
            .startAfter([startAfterLead.dateAdded])
            .limit(3)
            .get();
    for (var doc in leadsGet.docs) {
      final data = doc.data();
      leads.add(
        PurchasedLead(
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
          email: data['email'],
          phone: data['phone'],
        ),
      );
    }
    setState(() {
      isLoading = false;
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(20),
              child: PurchasedLeadList(
                leads: leads,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
