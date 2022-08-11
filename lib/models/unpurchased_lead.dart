import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lead_selling/models/coordinates.dart';

class UnpurchasedLead {
  final String condition;
  final Coordinates? coordinates;
  final String? zipCode;
  final Timestamp dateAdded;
  final String deviceId;
  final String docId;

  UnpurchasedLead({
    required this.condition,
    this.coordinates,
    this.zipCode,
    required this.dateAdded,
    required this.deviceId,
    required this.docId,
  });
}
