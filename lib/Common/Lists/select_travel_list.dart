import 'package:ai_travel_planner/Model/travel_option_model.dart';
import 'package:flutter/material.dart';

  List<TravelOption> selectTravelList=[
   TravelOption(
     id: 1,
     title: "Just Me",
     icon: Icon(Icons.add,size: 40,color: Colors.blue,),
     people: "1",
     desc: "A sole traveler in exploration",
   ),
    TravelOption(
        id: 2,
        title: "A Couple",
        icon: Icon(Icons.celebration,size: 40,color: Colors.orange,),
        people: "2",
        desc: 'Two Travel In Tadem'
    ),
    TravelOption(
        id: 3,
        title: "Family",
        icon: Icon(Icons.home,size: 40,color: Colors.green,),
        people: "3 to 5 People",
        desc: 'Happy Family Time'
    ),
    TravelOption(
        id:4,
        title: "Friends",
        icon: Icon(Icons.groups,size: 40,color: Colors.red,),
        people: "1",
        desc: 'A bunch of thrill-seekes'
    ),
 ];