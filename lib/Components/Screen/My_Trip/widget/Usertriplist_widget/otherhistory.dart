import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../Provider/addtofavprovider.dart';
import '../../../Trip_Details/tripdetailspage.dart';

class Otherhistory extends StatefulWidget {
  final String location;
  final String dates;
  final String whoistravelling;
  final String photourl;
  final trips;
  final int index;
  final Function? onFavoriteUpdated; // Add callback here

  const Otherhistory({
    super.key,
    required this.location,
    required this.dates,
    required this.whoistravelling,
    required this.photourl,
    required this.trips,
    required this.index,
    this.onFavoriteUpdated,
  });

  @override
  State<Otherhistory> createState() => _OtherhistoryState();
}

class _OtherhistoryState extends State<Otherhistory> {
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    // _fetchFavoriteStatus();
  }

  // void _fetchFavoriteStatus() async {
  //   DocumentSnapshot doc = await FirebaseFirestore.instance
  //       .collection('UserTrips')
  //       .doc(FirebaseAuth.instance.currentUser?.uid)
  //       .collection("Places")
  //       .doc(widget.trips.documentId)
  //       .get();
  //   if (doc.exists && doc.data() != null) {
  //     setState(() {
  //       isFavorite = doc["isFav"] ?? false;
  //     });
  //   }
  // }


  // void _toggleFavorite() async {
  //   setState(() {
  //     isFavorite = !isFavorite;
  //   });
  //   await FirebaseFirestore.instance
  //       .collection('UserTrips')
  //       .doc(FirebaseAuth.instance.currentUser?.uid)
  //       .collection("Places")
  //       .doc(widget.trips.documentId)
  //       .update({"isFav": isFavorite});
  //   if (widget.onFavoriteUpdated != null) {
  //     widget.onFavoriteUpdated!(); // Call callback to notify the parent screen
  //   }
  // }


  void _deleteTrip() async {
    bool? confirmDelete = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Confirm Deletion"),
        content: Text("Are you sure you want to delete this trip?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false), // Cancel
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true), // Confirm
            child: Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmDelete == true) {
      try {
        await FirebaseFirestore.instance
            .collection('UserTrips')
            .doc(FirebaseAuth.instance.currentUser?.uid)
            .collection("Places")
            .doc(widget.trips.documentId)
            .delete();

        if (widget.onFavoriteUpdated != null) {
          widget.onFavoriteUpdated!(); // Notify parent screen
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Trip deleted successfully!")),
        );
      } catch (error) {
        print("Error deleting trip: $error");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to delete trip")),
        );
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    // print(widget.trips.icondata);

    DateTime date = DateTime.parse(widget.dates);
    String formattedDate = DateFormat('dd MMM yyyy').format(date);

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          TripDetailsPage.routeName,
          arguments: widget.trips,
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                ),
                clipBehavior: Clip.hardEdge,
                child: CachedNetworkImage(
                  imageUrl: widget.photourl,
                  fit: BoxFit.cover,
                  placeholder: (context, url) =>
                      _shimmerEffect(width: 100, height: 100),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
              SizedBox(width: 10),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.location,
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: 'Outfit',
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.shade800,
                    ),
                  ),
                  Text(
                    formattedDate,
                    style: TextStyle(
                      fontSize: 17,
                      fontFamily: 'Outfit',
                      fontWeight: FontWeight.w200,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    "Traveller: ${widget.whoistravelling}",
                    style: TextStyle(
                      fontSize: 17,
                      fontFamily: 'Outfit',
                      fontWeight: FontWeight.w200,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              Spacer(),
              CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.black,
                  child: IconButton(
                    onPressed: () {
                      _deleteTrip();
                    },
                    icon: Icon(
                      Icons.delete,
                      color: Colors.white,
                      size: 30,
                    ),
                  ))
              // Text("✈︎",style: TextStyle(fontSize: 25),),
            ],
          ),
        ),
      ),
    );
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
