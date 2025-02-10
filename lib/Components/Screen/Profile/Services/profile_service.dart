import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import '../../../../Model/profile_model.dart';

class ProfileService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<ProfileModel> fetchProfileData() async {
    String userTripId = _auth.currentUser!.uid;

    try {
      DocumentSnapshot profileDoc = await _firestore
          .collection('UserTrips')
          .doc(userTripId)
          .collection("Profile")
          .doc("profiledetails")
          .get();
      return ProfileModel.fromMap(profileDoc.data() as Map<String, dynamic>);



    } catch (e) {
      print("Error fetching profile: $e");
      return ProfileModel(
        name: "Unknown",
        email: "No Email",
        profileImage:
        'https://images.unsplash.com/photo-1534528741775-53994a69daeb?q=80&w=500&auto=format&fit=crop',
      );
    }
  }

  Future<File?> pickImage() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false
      );
      if (result != null && result.files.single.path != null) {
        return File(result.files.single.path!);
      }
    } catch (e) {
      debugPrint(e.toString());
    }

    return null;
  }


}
