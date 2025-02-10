import 'package:ai_travel_planner/Model/tripdetails_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FetchData {
  final User? user = FirebaseAuth.instance.currentUser;
  late final CollectionReference tripCollection = FirebaseFirestore.instance
      .collection('UserTrips')
      .doc(user?.uid)
      .collection('Places');

  Stream<List<TripDetails>> getTrips() {
    return tripCollection.snapshots().map((snapshot) {
      List<TripDetails> trips = snapshot.docs.map((doc) {
        var data = doc.data() as Map<String, dynamic>;
        ;
        return TripDetails.fromMap(data, doc.id);
      }).toList();
      trips.sort((a, b) => int.parse(b.documentId).compareTo(int.parse(a.documentId)));
      return trips;
    });
  }
}
