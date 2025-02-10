import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

class ItenaryPage extends StatefulWidget {
  // final String day;
  final Map<String, dynamic> itinerary;
  final String tripTitle;

  const ItenaryPage(
      {super.key, required this.itinerary, required this.tripTitle});

  @override
  State<ItenaryPage> createState() => _ItenaryPageState();
}

class _ItenaryPageState extends State<ItenaryPage> {
  int selectedDay = 0;

  @override
  Widget build(BuildContext context) {
    String selectedDayKey = 'day${selectedDay + 1}';
    var dailyItinerary = widget.itinerary[selectedDayKey]['plan'] ?? [];
    print(dailyItinerary);

    List<String> days = widget.itinerary.keys.toList();
    days.sort((a, b) {
      int dayA = int.parse(a.replaceAll(RegExp(r'[^0-9]'), ''));
      int dayB = int.parse(b.replaceAll(RegExp(r'[^0-9]'), ''));
      return dayA.compareTo(dayB);
    });
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(widget.tripTitle),
      ),
      body: Padding(
        padding: EdgeInsets.only(left: 10,right: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Horizontal Scrollable Tabs
            SizedBox(
              height: 50,
              child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: days.length,
                itemBuilder: (context, index) {
                  String day = days[index];
                  String formattedDay =
                      'Day ${int.parse(day.replaceAll(RegExp(r'[^0-9]'), ''))}';
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedDay = index;
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      margin: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color:
                        selectedDay == index ? Colors.black : Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(child: Text(formattedDay,style: TextStyle(color: selectedDay == index?Colors.white:Colors.black),)),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 10),
            // Display Theme
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 10,right: 10,bottom: 10),
                      child: Text(
                        "Day Theme:${widget.itinerary[selectedDayKey]?['theme'] ?? 'No Theme Available'}",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    // Activities List
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: dailyItinerary.length,
                      itemBuilder: (context, index) {
                        var activity = dailyItinerary[index];
                        print("Hello");
                        var ans=activity['ticketPricing']??activity['cost'];
                        print(ans.toString());
                        return Card(
                          color: Colors.black,
                          margin: EdgeInsets.only(left: 10,right: 10,bottom: 10),
                          child: Padding(
                            padding: EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Lottie.asset(
                                      'assets/animations/time.json',
                                      height: 28,
                                      reverse: true,
                                      repeat: true,
                                      fit: BoxFit.cover,
                                    ),

                                    Text(activity['time'] ?? '',
                                        style: TextStyle(color: Colors.white)),
                                  ],
                                ),
                                SizedBox(height: 5),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Lottie.asset(
                                      'assets/animations/location.json',
                                      height: 28,
                                      reverse: true,
                                      repeat: true,
                                      fit: BoxFit.cover,
                                    ),
                                    Flexible(
                                      child: Text(activity['activity'] ?? '',
                                          style: TextStyle(
                                              fontSize: 16, fontWeight: FontWeight.bold,color: Colors.grey[300])),
                                    ),
                                  ],
                                ),
                                if((activity['ticketPricing']!=null) || (activity['cost']!=null))
                                  SizedBox(height: 5),
                                if((activity['ticketPricing']!=null) || (activity['cost']!=null))
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Lottie.asset(
                                        'assets/animations/moneybag.json',
                                        height: 32,
                                        reverse: true,
                                        repeat: true,
                                        fit: BoxFit.cover,
                                      ),
                                      // Icon(Icons.timelapse_rounded, color: Colors.red),
                                      SizedBox(width: 5),
                                      Flexible(
                                          child: Text(ans.toString(),style: TextStyle(color: Colors.grey[300]),)),
                                    ],
                                  ),
                                if(activity['travelTime']!=null)
                                  SizedBox(height: 5),
                                if(activity['travelTime']!=null)
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Lottie.asset(
                                        'assets/animations/car2.json',
                                        height: 32,
                                        reverse: false,
                                        repeat: true,
                                        fit: BoxFit.cover,
                                      ),                                      SizedBox(width: 5),
                                      Expanded(child: Text("Travel Time: ${activity['travelTime']}",style: TextStyle(color: Colors.grey[300]),)),
                                    ],
                                  ),
                                if(activity['details']!=null)
                                  SizedBox(height: 5),
                                if(activity['details']!=null)
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Lottie.asset(
                                        'assets/animations/message.json',
                                        height: 32,
                                        reverse: true,
                                        repeat: true,
                                        fit: BoxFit.cover,
                                      ),                                       SizedBox(width: 5),
                                      Expanded(
                                        child: Text(activity['details'],
                                            style: TextStyle(color: Colors.white)),
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

