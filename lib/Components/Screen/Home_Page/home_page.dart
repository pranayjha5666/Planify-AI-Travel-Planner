import 'package:ai_travel_planner/Components/Screen/My_Trip/my_trip_page.dart';
import 'package:ai_travel_planner/Components/Screen/Profile/profile_page.dart';
import 'package:flutter/material.dart';
import '../Favorite/favtrppage.dart';

class Home_Page extends StatefulWidget {
  static const String routeName = "/home-screen";

  const Home_Page({super.key});

  @override
  State<Home_Page> createState() => _Home_PageState();
}

class _Home_PageState extends State<Home_Page> {
  List<Widget> pages = [
    MyTripPage(),
    FavoriteTripsPage(),
    ProfilePage(),
  ];

  int idx = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        onTap: (index) {
          setState(() {
            idx = index;
          });
        },

        selectedItemColor: Colors.black,
        currentIndex: idx,
        items: [
          BottomNavigationBarItem(
            backgroundColor: Colors.white,
            icon: Icon(
              Icons.location_on_sharp,
              color: idx == 0 ? Colors.black : Colors.grey,
            ),
            label: "My Trip",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              idx == 1 ? Icons.favorite : Icons.favorite_border_outlined,
              color: idx == 1 ? Colors.red : Colors.grey,
            ),
            label: "Favorite",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              idx == 2 ? Icons.person : Icons.person_outline,
              color: idx == 2 ? Colors.black : Colors.grey,
            ),
            label: "Profile",
          ),
        ],
      ),
      body: IndexedStack(
        children: pages,
        index: idx,
      ),
    );
  }
}
