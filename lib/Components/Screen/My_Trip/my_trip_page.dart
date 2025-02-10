import 'package:ai_travel_planner/Components/Screen/My_Trip/widget/usertriplist.dart';
import 'package:ai_travel_planner/Components/Screen/Trip_Details/tripdetailspage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ai_travel_planner/Components/Screen/My_Trip/widget/startnewtripcard.dart';
import 'package:lottie/lottie.dart';

import '../../../Model/tripdetails_model.dart';
import '../Create_Trip/Pages/search_place.dart';
import 'Services/fetchdata.dart';

class MyTripPage extends StatefulWidget {
  static const String routeName = "/my-trip";
  const MyTripPage({super.key});

  @override
  State<MyTripPage> createState() => _MyTripPageState();
}

class _MyTripPageState extends State<MyTripPage> {
  final User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding:
            const EdgeInsets.only(top: 30, left: 25, right: 25, bottom: 25),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'My Trip',
                  style: TextStyle(
                    fontSize: 30,
                    fontFamily: 'Outfit',
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, SearchPlace.routeName);
                  },
                  icon: const Icon(Icons.add_circle,
                      size: 50, color: Colors.black),
                ),
              ],
            ),
            Expanded(
              child: StreamBuilder<List<TripDetails>>(
                stream: FetchData().getTrips() ,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return  Center(child: Lottie.asset(
                      'assets/animations/loading.json',
                      height: 350,
                      reverse: false,
                      repeat: true,
                      fit: BoxFit.cover,
                    ),  );
                  }

                  if (snapshot.hasError) {
                    print(snapshot.error);
                    return const Center(child: Text('Something went wrong!'));
                  }

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Startnewtripcard();
                  }

                  var trips = snapshot.data!;
                  return Usertriplist(trips: trips);

                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
