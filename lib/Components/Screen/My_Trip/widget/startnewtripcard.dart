import 'package:ai_travel_planner/Common/widget/custom_button.dart';
import 'package:ai_travel_planner/Components/Screen/Create_Trip/Pages/search_place.dart';
import 'package:flutter/material.dart';

class Startnewtripcard extends StatelessWidget {
  const Startnewtripcard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20.0),
      child: Container(
        margin: EdgeInsets.only(top: 50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.location_on_sharp,
              size: 40,
              color: Colors.black,
            ),
            SizedBox(height: 20,),
            Text(
              "No Trip Planned Yet",
              style: TextStyle(
                fontSize: 25, // 5% of screen height
                fontFamily: 'Outfit',
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 20,),
            Text(
              "Looks like its time to plan a new travel exoerience Get started below.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20, // 5% of screen height
                fontFamily: 'Outfit',
                color: Colors.grey.shade700,
              ),
            ),
            SizedBox(height: 20,),
            CustomButton(onTap: (){
              Navigator.pushNamed(context, SearchPlace.routeName);
            }, text: "Start a new trip",borderRadius: BorderRadius.circular(20),)
          ],
        ),
      ),
    );
  }
}
