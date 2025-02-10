import 'package:ai_travel_planner/Components/Screen/My_Trip/widget/Usertriplist_widget/otherhistory.dart';
import 'package:ai_travel_planner/Components/Screen/My_Trip/widget/Usertriplist_widget/recenthistory.dart';
import 'package:flutter/material.dart';

class Usertriplist extends StatefulWidget {
  final trips;
  const Usertriplist({super.key, required this.trips});

  @override
  State<Usertriplist> createState() => _UsertriplistState();
}

class _UsertriplistState extends State<Usertriplist> {

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Recenthistory(
            location: widget.trips[0].location.toString(),
            dates: widget.trips[0].startDate.toString(),
            whoistravelling: widget.trips[0].travelOption['title'],
            photourl: widget.trips[0].photoReference[0],
            trips: widget.trips,
          ),
          SizedBox(height: 10),
          ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: widget.trips.length - 1,
            itemBuilder: (context, index) {
              var trip = widget.trips[index + 1];
              return Column(
                children: [
                  Otherhistory(
                     location:  trip.location,
                     dates:  trip.startDate,
                     whoistravelling:  trip.travelOption['title'],
                     photourl:  trip.photoReference[0],
                     trips:  trip,
                    index: index,
                      ),
                  SizedBox(height: 10),
                ],
              );
            },
          )
        ],
      ),
    );
  }

}
