import 'dart:convert';

import 'package:ai_travel_planner/Common/widget/custom_button.dart';
import 'package:ai_travel_planner/Components/Screen/Create_Trip/Pages/travel_dates.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../Common/Lists/select_travel_list.dart';
import '../../../../Model/travel_option_model.dart';
import '../../../../Provider/CreateTripProvider.dart';

class SelectTraveller extends StatefulWidget {
  static const String routeName = "/create-trip/select-traveller-screen";
  const SelectTraveller({super.key});

  @override
  State<SelectTraveller> createState() => _SelectTravellerState();
}

class _SelectTravellerState extends State<SelectTraveller> {
  int? _selectedIndex; // Tracks the selected card index

  @override
  Widget build(BuildContext context) {
    final isButtonEnabled = _selectedIndex != null;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back),
          padding: const EdgeInsets.only(left: 16),
        ),
      ),
      body: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Who's Travelling",
            style: TextStyle(
              fontSize: 35, // 5% of screen height
              fontFamily: 'Outfit',
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Choose your travellers',
            style: TextStyle(
              fontSize: 23,
              fontFamily: 'Outfit',
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: selectTravelList.length,
              itemBuilder: (context, index) {
                final option = selectTravelList[index];
                final isSelected = _selectedIndex == index; // Check if selected
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedIndex = index; // Update the selected index
                    });
                    // print("Selected: ${option.title}");
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      border: isSelected
                          ? Border.all(color: Colors.black, width: 2) // Black outline for selected
                          : Border.all(color: Colors.transparent), // No outline for unselected
                      color: Color(0xffe7e7e7), // Card background
                    ),
                    margin: const EdgeInsets.symmetric(vertical: 10), // Add spacing here
                    padding: const EdgeInsets.all(14.0),
                    child: ListTile(
                      title: Text(
                        option.title,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: Text(
                        option.desc,
                        style: const TextStyle(fontSize: 17),
                      ),
                      trailing: option.icon,
                    ),
                  ),
                );
              },
            ),
          ),
          if (isButtonEnabled)
            CustomButton(
              onTap: () {
                if (_selectedIndex != null) {
                  final selectedOption = selectTravelList[_selectedIndex!];

                  Provider.of<TripProvider>(context, listen: false).setTripData(
                    travelOption: TravelOption(id: selectedOption.id, title: selectedOption.title, desc: selectedOption.desc, icon: selectedOption.icon, people: selectedOption.people).toMap()
                  );                  // Navigate to TravelDates screen
                  Navigator.pushNamed(context, TravelDates.routeName);
                } else {
                  print("No option selected.");
                }
              },
              text: "Continue",
            )

        ],
      ),
    ),
    );
  }
}