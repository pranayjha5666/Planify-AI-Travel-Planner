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
      print("Profile name updated successfully!");

  }

  Future<void> updateProfileImage(XFile imageFile) async {
    String? imageUrl = await uploadImageToCloudinary(imageFile);
    print(imageUrl);

    if (imageUrl != null) {
      String uid = _auth.currentUser!.uid;

      await _db.collection('UserTrips')
          .doc(uid)
          .collection("Profile")
          .doc("profiledetails").update({
        'profileImage': imageUrl,
      });


      print("Profile image updated successfully!");
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
        'public_id': 'heyimg', // Custom image name
        // 'timestamp': timestamp,
      };
      String cloudinaryUrl = "https://api.cloudinary.com/v1_1/$cloudName/image/upload";
      var request = http.MultipartRequest('POST', Uri.parse(cloudinaryUrl))..fields.addAll(uploadParams) // Set in Cloudinary settings
      ..files.add(await http.MultipartFile.fromPath('file', imageFile.path));

      var response = await request.send();
      var responseData = await response.stream.bytesToString();
      var jsonData = json.decode(responseData);
      // print("Image upload successfull");
      // print(jsonData['secure_url']);
      return jsonData['secure_url']; // The uploaded image URL
    } catch (e) {
      print("Error uploading to Cloudinary: $e");
      return null;
    }
  }

  Future<void> deleteImage(String imageUrl) async {

    try {
      String uid = _auth.currentUser!.uid;

      String public = imageUrl.split("/").last.split(".")[0];
      // print(public);
      String publicId="profile/$uid/$public";
      // Generate a timestamp
      int timestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;

      // Create the signature
      String stringToSign = "public_id=$publicId&timestamp=$timestamp$apiSecret";
      String signature = sha1.convert(utf8.encode(stringToSign)).toString();

      // API endpoint
      String url = "https://api.cloudinary.com/v1_1/$cloudName/image/destroy";
      print(publicId);

      // Request body
      Map<String, String> body = {
        "public_id": publicId,
        "api_key": apiKey,
        "timestamp": timestamp.toString(),
        "signature": signature,
      };

      // Send the DELETE request
      var response = await http.post(Uri.parse(url), body: body);

      // Handle the response
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
