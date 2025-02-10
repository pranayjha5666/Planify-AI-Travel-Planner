class TripDetails {
  final String documentId;
  final String location;
  final String tripTitle;
  final String startDate;
  final String endDate;
  final String budget;
  final Map<String, dynamic> travelOption;
  final List<dynamic> photoReference;
  final List<dynamic> hotellist;
  final Map<String, dynamic> itinerary;
  final List<dynamic> placemustvisitlist;
  final String icondata;

  TripDetails(
      {required this.documentId, // Include in constructor
      required this.location,
      required this.tripTitle,
      required this.startDate,
      required this.endDate,
      required this.budget,
      required this.travelOption,
      required this.photoReference,
      required this.hotellist,
      required this.itinerary,
      required this.placemustvisitlist,
      required this.icondata});

  factory TripDetails.fromMap(Map<String, dynamic> data, String docId) {

    return TripDetails(
        documentId: docId, // Store Firestore document ID
        location: data['usertripdetails']['name'] ?? '',
        tripTitle: data['aitripdetails']['tripTitle'] ?? '',
        startDate:
            data['usertripdetails']['startDate'] ?? '', // Fixed key issue
        endDate: data['usertripdetails']['endDate'] ?? '',
        budget: data['usertripdetails']['budget']['title'] ?? '',
        travelOption: data['usertripdetails']['travelOption'] ?? {},
        photoReference: data['usertripdetails']['photoReference'] ?? {},
        hotellist: data['aitripdetails']['hotelOptions'] ?? {},
        itinerary: data['aitripdetails']['itinerary'] ?? {},
        placemustvisitlist: data['aitripdetails']['mustVisitPlaces'] ?? data['aitripdetails']['nearbyPlaces'] ?? data['aitripdetails']['nearbyAttractions'] ?? data['aitripdetails']['nearbyPlacesToVisit'] ?? [],
        icondata: data['usertripdetails']['budget']['icon'] ?? '');
  }
}
