import 'package:ai_travel_planner/Common/widget/custom_button.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

class HelpAndSupportPage extends StatefulWidget {
  static const String routeName = "/help-and-support-screen";

  const HelpAndSupportPage({Key? key}) : super(key: key);

  @override
  _HelpAndSupportPageState createState() => _HelpAndSupportPageState();
}

class _HelpAndSupportPageState extends State<HelpAndSupportPage> {
  TextEditingController _feedbackController=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("Help & Support"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildHelpInfoSection(),
              _buildContactSection(),
              _buildFeedbackSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHelpInfoSection() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "Need help or have questions?\nWe're here for you! Feel free to reach out to us with any queries or issues you might have, and we'll assist you as soon as possible.",
            style: const TextStyle(
              fontFamily: 'OutFit',
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: Colors.black,
            ),
            textAlign: TextAlign.start,
          ),
        ),
        SizedBox(height: 20),
        Text(
          "FAQs",
          style: const TextStyle(
            fontFamily: 'OutFit',
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 10),
        ExpansionTile(
          title: Text("What is the AI-powered travel planner app?"),
          children: [
            ListTile(title: Text("Our AI-powered travel planner app helps users plan personalized trips based on their preferences, such as the number of travelers, type of trip (family or friends), duration, budget, and more. The app provides tailored suggestions for top places to visit, recommended accommodations, restaurants, activities, and even generates a travel guide based on your inputs, ensuring your travel experience is seamless and enjoyable.",
            style: const TextStyle(
              fontFamily: 'OutFit',
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),)),
          ],
        ),
        ExpansionTile(
          title: Text("How does the AI suggest the best destinations?"),
          children: [
            ListTile(title: Text("The AI uses advanced algorithms and data from various sources to recommend destinations that best match your preferences. By analyzing your input (e.g., trip type, travel duration, budget), the AI curates a list of places that fit your travel needs. Additionally, it learns from user behavior to improve future suggestions, providing you with more accurate and relevant recommendations.",
              style: const TextStyle(
                fontFamily: 'OutFit',
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),)),
          ],
        ),
        ExpansionTile(
          title: Text("Will the app provide information on local attractions and activities?"),
          children: [
            ListTile(title: Text("Absolutely! The AI suggests top places to visit, local attractions, activities, and experiences based on your interests and destination. Whether you're looking for cultural landmarks, adventurous activities, or hidden gems, the app curates recommendations to enhance your trip, along with detailed descriptions, photos, and reviews.",
              style: const TextStyle(
                fontFamily: 'OutFit',
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),)),
          ],
        ),
        ExpansionTile(
          title: Text("Is the travel guide personalized for each user?"),
          children: [
            ListTile(title: Text("Yes, the travel guide is completely personalized! The app generates a custom travel guide based on your preferences, such as the number of travelers, type of trip, and duration. It includes personalized recommendations for places to visit, things to do, restaurants, and even a day-by-day itinerary to make sure your trip is organized and stress-free.",
              style: const TextStyle(
                fontFamily: 'OutFit',
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),)),
          ],
        ),

      ],
    );
  }

  Widget _buildContactSection() {
    return GestureDetector(
      onTap: () {
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 150,
                width: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                ),
                clipBehavior: Clip.hardEdge,
                child: CachedNetworkImage(
                  imageUrl: "https://res.cloudinary.com/dqe9rpcml/image/upload/v1738787622/svydd0lnym3jog7ztlbu.jpg",
                  fit: BoxFit.cover,
                  placeholder: (context, url) => _shimmerEffect(width: 100, height: 150),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
              SizedBox(width: 10),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Contact Us",
                    style: TextStyle(fontSize: 20, fontFamily: 'Outfit', fontWeight: FontWeight.w800, color: Colors.grey.shade800),
                  ),
                  Text(
                    "Email Support:",
                    style: TextStyle(fontSize: 17, fontFamily: 'Outfit', fontWeight: FontWeight.w200, color: Colors.black),
                  ),
                  Text(
                    "pranayjha361@gmail.com",
                    style: TextStyle(fontSize: 17, fontFamily: 'Outfit', fontWeight: FontWeight.bold, color: Colors.green),
                  ),
                  SizedBox(height: 5),
                  Text(
                    "Phone Support:",
                    style: TextStyle(fontSize: 17, fontFamily: 'Outfit', fontWeight: FontWeight.w200, color: Colors.black),
                  ),
                  Text(
                    "+91 8329432361",
                    style: TextStyle(fontSize: 17, fontFamily: 'Outfit', fontWeight: FontWeight.bold, color: Colors.green),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeedbackSection() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20),
          TextFormField(
            controller: _feedbackController,
            decoration: InputDecoration(
              labelText: "Enter your feedback",
              hintText: "Write your feedback here...",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              contentPadding: EdgeInsets.all(10),
            ),
            maxLines: 5,
          ),

          SizedBox(height: 20),
          CustomButton(
            onTap: () {
              String feedbackText = _feedbackController.text.trim();
              if (feedbackText.isNotEmpty) {
                _saveFeedback(feedbackText);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Please enter some feedback")),
                );
              }
            },
            text: "Submit Feedback",
          ),
        ],
      ),
    );
  }

  Future<void> _saveFeedback(String feedbackText) async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    String email = FirebaseAuth.instance.currentUser!.email ?? 'anonymous@example.com';

    try {
      await FirebaseFirestore.instance.collection('feedback').doc(uid).set({
        'Feedback': feedbackText,
        'email': email,
        'timestamp': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Thank you for your feedback!")),
      );
    } catch (e) {
      print("Error saving feedback: $e");
    }
  }


Widget _shimmerEffect({required double width, required double height}) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }
}
