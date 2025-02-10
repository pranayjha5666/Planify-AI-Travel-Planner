import 'package:ai_travel_planner/Common/widget/custom_button.dart';
import 'package:ai_travel_planner/Components/Screen/Create_Trip/Pages/generate_trip.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../../Provider/CreateTripProvider.dart';

class ReviewTrip extends StatefulWidget {
  static const String routeName = "/create-trip/review-screen";

  const ReviewTrip({super.key});

  @override
  State<ReviewTrip> createState() => _ReviewTripState();
}

class _ReviewTripState extends State<ReviewTrip> {
  @override
  String formattedDateRange="";

  @override
  Widget build(BuildContext context) {
    final tripData =
        Provider.of<TripProvider>(context, listen: false).tripData;

    final DateTime startDate =DateTime.parse(tripData['startDate']) ;

    final DateTime endDate = DateTime.parse(tripData['endDate']);
    formattedDateRange =
        "${DateFormat('MMM dd').format(startDate)} - ${DateFormat('MMM dd').format(endDate)}";


    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Review Your Trip",
              style: TextStyle(
                fontSize: 35,
                fontFamily: 'Outfit',
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Before generating your trip please review your selection',
              style: TextStyle(
                fontSize: 20,
                fontFamily: 'Outfit',
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 20),
            _rowWidget("🚀", "Destination", tripData['name']),
            const SizedBox(height: 20),
              _rowWidget("🗓️", "Travel Date", formattedDateRange,total: tripData['totalNoOfDays']),
            const SizedBox(height: 20),
            _rowWidget("🧳", "Who is Travelers", tripData['travelOption']['title']),
            const SizedBox(height: 20),
            _rowWidget("💰", "Budget", tripData['budget']['title']),
            Spacer(),
            CustomButton(onTap: (){
              Navigator.pushNamedAndRemoveUntil(context, GenerateTrip.routeName,(route) => false);
            }, text: "Build My Trip")

          ],
        ),
      ),
    );
  }

  Widget _rowWidget(String emoji, String title, String detail, {int ? total}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          margin: const EdgeInsets.only(right: 12),
          child: Text(
            emoji,
            style: const TextStyle(fontSize: 30),
          ),
        ),
        SizedBox(width: 10,),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 20,
                fontFamily: 'Outfit',
                fontWeight: FontWeight.w200,
                color: Colors.grey.shade800,
              ),
            ),
            Text(
              total != null ? "$detail ($total days) " : detail,
              style: TextStyle(
                fontSize: 20,
                fontFamily: 'Outfit',
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
