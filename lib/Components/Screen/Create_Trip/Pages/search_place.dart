import 'dart:convert';
import 'package:ai_travel_planner/Components/Screen/Create_Trip/Pages/select_traveller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import '../../../../Provider/CreateTripProvider.dart';

class SearchPlace extends StatefulWidget {
  static const String routeName = "/create-trip/search-place-screen";

  const SearchPlace({super.key});

  @override
  State<SearchPlace> createState() => _SearchPlaceState();
}

class _SearchPlaceState extends State<SearchPlace> {
  TextEditingController citynamecontroller = TextEditingController();
  List<dynamic> listOfLocation = [];

  @override
  void initState() {
    super.initState();
    citynamecontroller.addListener(() {
      _onChange();
    });
  }

  _onChange() {
    placeSuggestions(citynamecontroller.text);
  }

  String generatePhotoUrl(String photoReference) {
    String? apiKey = dotenv.env["Mapapikey"];
    return "https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=$photoReference&key=$apiKey";
  }


  void placeSuggestions(String input) async {
    String? apikey = dotenv.env["Mapapikey"];
    try {
      String baseurl =
          "https://maps.googleapis.com/maps/api/place/autocomplete/json";
      String req = "$baseurl?input=$input&key=$apikey";
      var response = await http.get(Uri.parse(req));
      var data = json.decode(response.body);

      if (response.statusCode == 200) {
        setState(() {
          listOfLocation =
              data['predictions'];
        });
      } else {
        throw Exception("Failed to fetch place suggestions");
      }
    } catch (e) {
      if (kDebugMode) print("Error fetching suggestions: $e");
    }
  }

  Future<void> fetchPlaceDetails(String placeId) async {
    String? apikey = dotenv.env["Mapapikey"];
    try {
      String baseurl =
          "https://maps.googleapis.com/maps/api/place/details/json";
      String req = "$baseurl?place_id=$placeId&key=$apikey";
      var response = await http.get(Uri.parse(req));
      var data = json.decode(response.body);
      if (response.statusCode == 200) {
        var geometry = data['result']['geometry']['location'];
        var photos = data['result']['photos'] ?? [];
        var photoReferences = photos
            .take(5)
            .map((photo) => generatePhotoUrl(photo['photo_reference']))
            .toList();

        var url = data['result']['url'];
        var name = data['result']['name'];
        Provider.of<TripProvider>(context, listen: false).setTripData(
          name: name,
          coordinates: geometry,
          url: url,
          photoReferences: photoReferences,
        );
        Navigator.pushNamed(context, SelectTraveller.routeName);
      } else {
        throw Exception("Failed to fetch place details");
      }
    } catch (e) {
      if (kDebugMode) print("Error fetching place details: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Search",
          style: TextStyle(fontSize: 25, color: Colors.black),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back),
          padding: const EdgeInsets.only(left: 16),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: citynamecontroller,
              decoration: const InputDecoration(
                hintText: "Search Place",
                prefixIcon: Icon(Icons.location_on_sharp),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: listOfLocation.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () async {
                      String placeId = listOfLocation[index]['place_id'];
                      await fetchPlaceDetails(placeId);
                    },
                    child: ListTile(
                      title: Text(listOfLocation[index]["description"]),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
