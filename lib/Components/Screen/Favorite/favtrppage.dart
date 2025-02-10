import 'package:ai_travel_planner/Components/Screen/My_Trip/widget/Usertriplist_widget/otherhistory.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ai_travel_planner/Model/tripdetails_model.dart';
import 'package:lottie/lottie.dart';

class FavoriteTripsPage extends StatelessWidget {
  final User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("Favorite Trips",style: TextStyle(
          fontSize: 30,
          fontFamily: 'Outfit',
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('UserTrips')
            .doc(user?.uid)
            .collection('Places')
            .where('isFav', isEqualTo: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Lottie.asset(
                  'assets/animations/no_data.json',
                  height: 240,
                  reverse: true,
                  repeat: true,
                  fit: BoxFit.cover,
                ),
                Center(child: Text("No favorite trips found.",style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'Outfit',
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),)),
              ],
            );
          }

          var trips = snapshot.data!.docs.map((doc) {
            var data = doc.data() as Map<String, dynamic>;
            return TripDetails.fromMap(data, doc.id);
          }).toList();

          return Padding(
            padding: const EdgeInsets.only(left: 15.0,right: 15),
            child: ListView.builder(
              itemCount: trips.length,
              itemBuilder: (context, index) {
                // return ListTile(
                //   title: Text(trips[index].location),
                //   subtitle: Text("${trips[index].startDate} - ${trips[index].endDate}"),
                //   trailing: Icon(Icons.favorite, color: Colors.red),
                //   onTap: () {
                //     Navigator.push(
                //       context,
                //       MaterialPageRoute(
                //         builder: (context) => TripDetailsPage(tripDetails: trips[index]),
                //       ),
                //     );
                //   },
                // );
                return Column(
                  children: [
                    Otherhistory(location: trips[index].location, dates: trips[index].startDate, whoistravelling: trips[index].travelOption['title'], photourl: trips[index].photoReference[0], trips: trips[index], index: index),
                    SizedBox(height: 10),
                  ],
                );
              },

            ),
          );
        },
      ),
    );
  }
}
