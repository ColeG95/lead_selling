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
    if (startAfterLead == null) {
      leads.clear();
      cart.clear();
    }
    final leadsGet = startAfterLead == null
        ? await FirebaseFirestore.instance
            .collection('leads')
            .where('dateAdded', isGreaterThan: relativeTimeDate[relativeTime])
            .orderBy('dateAdded', descending: true)
            .limit(3)
            .get()
        : await FirebaseFirestore.instance
            .collection('leads')
            .where('dateAdded', isGreaterThan: relativeTimeDate[relativeTime])
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
    loadLeads(null, null, null);
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
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  DropdownFilter(
                    value: relativeTime,
                    allValues: RelativeTime.values,
                    allTexts: RelativeTime.values
                        .map((e) => e.name.replaceAll('_', ' '))
                        .toList(),
                    onChanged: selectTimeFilter,
                  ),
                  const SizedBox(width: 20),
                  DropdownFilter(
                    value: relativeDistance,
                    allValues: RelativeDistance.values,
                    allTexts: RelativeDistance.values
                        .map((e) => e.name.replaceAll('_', ' '))
                        .toList(),
                    onChanged: selectDistanceFilter,
                  ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      onPrimary: Colors.white,
                      primary: Colors.lightBlueAccent,
                    ),
                    child: Text(
                      'Buy Selected Leads',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  const SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: () {
                      if (cart.length == leads.length) {
                        setState(() {
                          cart = [];
                        });
                      } else {
                        setState(() {
                          cart = [...leads];
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.grey[300],
                      onPrimary: Colors.grey[900],
                    ),
                    child: Text(
                      cart.length != leads.length
                          ? 'Select All'
                          : 'Deselect All',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
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
                    style: ElevatedButton.styleFrom(
                      primary: Colors.grey[300],
                      onPrimary: Colors.grey[900],
                    ),
                    child: const Text(
                      'Load More',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
