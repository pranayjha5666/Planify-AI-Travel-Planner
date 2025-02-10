import 'package:ai_travel_planner/Components/Screen/My_Trip/widget/Usertriplist_widget/otherhistory.dart';
import 'package:ai_travel_planner/Components/Screen/Trip_Details/widget/hotel_info.dart';
import 'package:ai_travel_planner/Components/Screen/Trip_Details/widget/placemustvisit.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../../../Common/widget/custom_button.dart';
import '../../../Model/tripdetails_model.dart';
import '../../../Provider/addtofavprovider.dart';
import '../Itinerary/itenary_page.dart';

class TripDetailsPage extends StatefulWidget {
  static const String routeName = "/tripdetails";
  final TripDetails tripDetails;


  TripDetailsPage({required this.tripDetails});

  @override
  State<TripDetailsPage> createState() => _TripDetailsPageState();
}

class _TripDetailsPageState extends State<TripDetailsPage> {
  int _currentIndex = 0;
  bool isFavorite = false;


  @override
  void initState() {
    super.initState();
    _fetchFavoriteStatus();
  }

  void _fetchFavoriteStatus() async {
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection('UserTrips')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection("Places")
        .doc(widget.tripDetails.documentId)
        .get();
    if (doc.exists && doc.data() != null) {
      setState(() {
        isFavorite = doc["isFav"] ?? false;
      });
    }
  }

  void _toggleFavorite() async {
    setState(() {
      isFavorite = !isFavorite;

    });
    await FirebaseFirestore.instance
        .collection('UserTrips')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection("Places")
        .doc(widget.tripDetails.documentId)
        .update({"isFav": isFavorite});



  }

  String formatDate(String date) {
    DateTime dateTime = DateTime.parse(date);
    return DateFormat('dd MMM yyyy').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    // print(widget.tripDetails);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    CarouselSlider(
                      items: widget.tripDetails.photoReference.map((imageUrl) {
                        return CachedNetworkImage(
                          imageUrl: imageUrl,
                          fit: BoxFit.cover,
                          height: 330,
                          width: double.infinity,
                          placeholder: (context, url) =>
                              _shimmerEffect(width: double.infinity, height: 330),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error, size: 50, color: Colors.red),
                        );
                      }).toList(),
                      options: CarouselOptions(
                        height: 330,
                        viewportFraction: 1.0,
                        enableInfiniteScroll: true,
                        autoPlay: true,
                        autoPlayInterval: Duration(seconds: 4),
                        onPageChanged: (index, reason) {
                          setState(() {
                            _currentIndex = index;
                          });
                        },
                      ),
                    ),
                    Positioned(
                      top: 40,
                      right: 20,
                      child: GestureDetector(
                        onTap: () async {
                          setState(() {
                            isFavorite = !isFavorite;
                          });

                          // Update favorite status in Firestore database
                          await FirebaseFirestore.instance
                              .collection('UserTrips')
                              .doc(FirebaseAuth.instance.currentUser?.uid)
                              .collection("Places")
                              .doc(widget.tripDetails.documentId)
                              .update({"isFav": isFavorite});

                          // Update the favorite status in the provider
                          Provider.of<FavoriteStatusProvider>(context, listen: false)
                              .updateFavoriteStatus(isFavorite);
                        },
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          child: Icon(
                            isFavorite ? Icons.favorite : Icons.favorite_border,
                            color: isFavorite ? Colors.red : Colors.grey,
                          ),
                        ),
                      ),

                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.tripDetails.location,
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "${formatDate(widget.tripDetails.startDate)} - ${formatDate(widget.tripDetails.endDate)}",
                        style: TextStyle(
                          fontSize: 17,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "🚌 ${widget.tripDetails.travelOption['title']}",
                        style: TextStyle(
                          fontSize: 17,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "🏩 Hotel Recommendation",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 10),
                      HotelInfo(
                        hotelList: widget.tripDetails.hotellist,
                      ),
                      SizedBox(height: 10),
                      Text(
                        "🌏 Place Must Visit",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 10),
                      Placemustvisit(
                        mustVisitList: widget.tripDetails.placemustvisitlist,
                      ),
                      SizedBox(height: 10),
                      CustomButton(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ItenaryPage(
                                tripTitle: widget.tripDetails.tripTitle,
                                itinerary: widget.tripDetails.itinerary,
                              ),
                            ),
                          );
                        },
                        text: "Show Itinerary",
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
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
