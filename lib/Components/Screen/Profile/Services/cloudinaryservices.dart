import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';
import 'package:image_picker/image_picker.dart';

class CloudinaryService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

   String cloudName = dotenv.env["CloudinarycloudName"] ?? "";
   String apiKey = dotenv.env["CloudinaryapiKey"] ?? "";
   String apiSecret = dotenv.env["CloudinaryapiSecret"] ?? "";
   final String uploadPreset = dotenv.env["CloudinaryuploadPreset"] ?? "";




  Future<void> updateProfile(String name) async {
      String uid = _auth.currentUser!.uid;
      await _db.collection('UserTrips')
          .doc(uid)
          .collection("Profile")
          .doc("profiledetails").update({
        'name':name
      });
  }

  Future<void> updateProfileImage(XFile imageFile) async {
    String? imageUrl = await uploadImageToCloudinary(imageFile);
    if (imageUrl != null) {
      String uid = _auth.currentUser!.uid;

      await _db.collection('UserTrips')
          .doc(uid)
          .collection("Profile")
          .doc("profiledetails").update({
        'profileImage': imageUrl,
      });
    } else {
      print("Failed to upload image");
    }
  }

  Future<String?> uploadImageToCloudinary(XFile imageFile) async {
    try {
      String uid = _auth.currentUser!.uid;

      await CloudinaryService().deleteImage("https://res.cloudinary.com/dqe9rpcml/image/upload/v1738761403/profile/$uid/heyimg.jpg");
      Map<String, String> uploadParams = {
        'upload_preset': uploadPreset,
        'folder': 'profile/$uid',
        'public_id': 'heyimg',
      };
      String cloudinaryUrl = "https://api.cloudinary.com/v1_1/$cloudName/image/upload";
      var request = http.MultipartRequest('POST', Uri.parse(cloudinaryUrl))..fields.addAll(uploadParams) // Set in Cloudinary settings
      ..files.add(await http.MultipartFile.fromPath('file', imageFile.path));

      var response = await request.send();
      var responseData = await response.stream.bytesToString();
      var jsonData = json.decode(responseData);
      return jsonData['secure_url'];
    } catch (e) {
      print("Error uploading to Cloudinary: $e");
      return null;
    }
  }

  Future<void> deleteImage(String imageUrl) async {

    try {
      String uid = _auth.currentUser!.uid;

      String public = imageUrl.split("/").last.split(".")[0];
      String publicId="profile/$uid/$public";
      int timestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      String stringToSign = "public_id=$publicId&timestamp=$timestamp$apiSecret";
      String signature = sha1.convert(utf8.encode(stringToSign)).toString();
      String url = "https://api.cloudinary.com/v1_1/$cloudName/image/destroy";
      Map<String, String> body = {
        "public_id": publicId,
        "api_key": apiKey,
        "timestamp": timestamp.toString(),
        "signature": signature,
      };
      var response = await http.post(Uri.parse(url), body: body);
      if (response.statusCode == 200) {
        print("Image deleted successfully");
      } else {
        print("Failed to delete image: ${response.body}");
      }
    } catch (e) {
      print("Error deleting image: $e");
    }
  }
}
