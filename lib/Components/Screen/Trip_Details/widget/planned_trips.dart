// import 'package:ai_travel_planner/Components/Screen/Itinerary/itenary_page.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
//
// class PlannedTrips extends StatefulWidget {
//   final Map<String, dynamic> itinerary;
//
//   const PlannedTrips({super.key, required this.itinerary});
//
//   @override
//   State<PlannedTrips> createState() => _PlannedTripsState();
// }
//
// class _PlannedTripsState extends State<PlannedTrips> {
//   @override
//   Widget build(BuildContext context) {
//     // Extract days and sort them numerically (assuming days are named like 'day1', 'day2', etc.)
//     List<String> days = widget.itinerary.keys.toList();
//     days.sort((a, b) {
//       int dayA = int.parse(a.replaceAll(RegExp(r'[^0-9]'), ''));
//       int dayB = int.parse(b.replaceAll(RegExp(r'[^0-9]'), ''));
//       return dayA.compareTo(dayB);
//     });
//     return ListView.builder(
//       physics: BouncingScrollPhysics(),
//       shrinkWrap: true,
//       itemCount: days.length, // Dynamic count based on the number of days
//       itemBuilder: (context, index) {
//         String day = days[index];
//
//         // Extract the day number and format it as "Day 1", "Day 2", etc.
//         String formattedDay =
//             'Day ${int.parse(day.replaceAll(RegExp(r'[^0-9]'), ''))}';
//
//         return GestureDetector(
//           onTap: () {
//             // Navigate to the detailed page when the card is tapped
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => ItenaryPage(
//                   day: day,
//                   itinerary: widget.itinerary,
//                 ),
//               ),
//             );
//           },
//           child: Card(
//             margin: EdgeInsets.only(bottom: 16),
//             shape:
//                 RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//             elevation: 6,
//             color: Colors.white,
//             child: Container(
//               padding: EdgeInsets.all(20),
//               decoration: BoxDecoration(
//                 color: Colors.grey[500],
//                 borderRadius: BorderRadius.circular(20),
//               ),
//               child: Row(
//                 children: [
//                   Text(
//                     formattedDay, // Displaying day as "Day 1", "Day 2", etc.
//                     style: TextStyle(
//                       fontSize: 22,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.black,
//                     ),
//                     textAlign: TextAlign.center,
//                   ),
//                   Spacer(),
//                   Text(
//                     "📍", // Displaying day like "day 1", "day 2"
//                     style: TextStyle(
//                       fontSize: 22,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.white,
//                     ),
//                     textAlign: TextAlign.center,
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
//
//
