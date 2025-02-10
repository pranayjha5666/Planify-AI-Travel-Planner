import 'package:ai_travel_planner/Model/budget_model.dart';
import 'package:flutter/material.dart';
import '../Model/travel_option_model.dart';

class TripProvider extends ChangeNotifier {
  Map<String, dynamic> _tripData = {};
  Map<String, dynamic> get tripData => _tripData;

  void setTripData({
    String? name,
    Map<String, dynamic>? coordinates,
    List<dynamic>? photoReferences,
    String? url,
    // TravelOption? travelOption,
    Map<String,dynamic>?travelOption,
    String? startDate,
    String? endDate,
    int? totalNoOfDays ,
    Map<String,dynamic>? budget,

  }) {
    // Create a new map with existing data
    Map<String, dynamic> newTripData = Map.from(_tripData);

    // Only update fields that are not null
    if (name != null) newTripData['name'] = name;
    if (coordinates != null) newTripData['coordinates'] = coordinates;
    if (travelOption != null) newTripData['travelOption'] = travelOption;
    if (photoReferences != null) newTripData['photoReference'] = photoReferences;
    if (url != null) newTripData['url'] = url;
    if (startDate != null) newTripData['startDate'] = startDate;
    if (endDate != null) newTripData['endDate'] = endDate;
    if (totalNoOfDays != null) newTripData['totalNoOfDays'] = totalNoOfDays;
    if(budget!=null) newTripData['budget'] = budget;
    // Update the _tripData with the new map
    _tripData = newTripData;
    notifyListeners();
  }
}