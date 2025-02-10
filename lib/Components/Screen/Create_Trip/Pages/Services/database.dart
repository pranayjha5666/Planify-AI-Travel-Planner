import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods{

  Future<void> addDetailsToDatabase(Map<String, dynamic> userInfoMap, String userTripId) async {
    String dateTimeId = DateTime.now().millisecondsSinceEpoch.toString();
    userInfoMap['isFav'] = false;

    await FirebaseFirestore.instance
        .collection('UserTrips')
        .doc(userTripId)
        .collection("Places")
        .doc(dateTimeId)
        .set(userInfoMap);
  }

  Future<void> updateFavoriteStatus(String userTripId, String placeId, bool isFav) async {
    await FirebaseFirestore.instance
        .collection('UserTrips')
        .doc(userTripId)
        .collection("Places")
        .doc(placeId)
        .update({'isFav': isFav});
  }

  Future<void> addProfileToDatabase(Map<String, dynamic> userInfoMap, String userTripId) async {

    await FirebaseFirestore.instance
        .collection('UserTrips')
        .doc(userTripId)
        .collection("Profile")
        .doc("profiledetails")
        .set(userInfoMap);
  }

}
