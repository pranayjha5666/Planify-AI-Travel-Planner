import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shimmer/shimmer.dart';

class Placemustvisit extends StatefulWidget {
  final List mustVisitList; // Ensure type safety

  const Placemustvisit({super.key, required this.mustVisitList});

  @override
  State<Placemustvisit> createState() => _PlacemustvisitState();
}

class _PlacemustvisitState extends State<Placemustvisit> {

  final String? apiKey = dotenv.env["Mapapikey"];
  Map<String, String> placePhotos = {};

  @override
  void initState() {
    super.initState();
    fetchPlacePhotos();
  }

  Future<void> fetchPlacePhotos() async {
    for (var place in widget.mustVisitList) {
      String placename=place["placeName"]??place["name"];
      String? photoUrl = await getPlacePhoto(placename);
      if (photoUrl != null) {
        setState(() {
          placePhotos[placename] = photoUrl;
        });
      }
    }
  }

  Future<String?> getPlacePhoto(String placeName) async {
    final String url =
        'https://maps.googleapis.com/maps/api/place/findplacefromtext/json'
        '?input=$placeName&inputtype=textquery&fields=photos&key=$apiKey';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      if (jsonResponse['candidates'] != null &&
          jsonResponse['candidates'].isNotEmpty) {
        var photos = jsonResponse['candidates'][0]['photos'];
        if (photos != null && photos.isNotEmpty) {
          String photoReference = photos[0]['photo_reference'];
          return 'https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=$photoReference&key=$apiKey';
        }
      }
    }
    return null; // Return null if no photo found
  }

  @override
  Widget build(BuildContext context) {

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: List.generate(widget.mustVisitList.length, (index) {
          final place=widget.mustVisitList[index];
          String placeName=place["placeName"]??place["name"];
          String? imageUrl=placePhotos[placeName];


          return Container(
            margin: EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 120,
                  width: 180,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.black,
                  ),
                  clipBehavior: Clip.hardEdge,
                  child: imageUrl != null
                      ? CachedNetworkImage(
                    imageUrl: imageUrl,
                    fit: BoxFit.cover,
                    placeholder: (context, url) =>
                        _shimmerEffect(width: 180, height: 120),
                    errorWidget: (context, url, error) =>
                        Icon(Icons.error),
                  )
                      : _shimmerEffect(width: 180, height: 120),
                ),
                SizedBox(height: 5),
                Container(
                  width: 180,
                  child: Text(
                    placeName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 17,
                      fontFamily: 'Outfit',
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ),
                SizedBox(height: 2),
                Container(
                  width: 180,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          " 💸 ${place["ticketPricing"] != null
                              ? (place["ticketPricing"] == 0 ? "Free" : place["ticketPricing"])
                              : (place["nearbyAttractions"] != null && place["nearbyAttractions"].isNotEmpty
                              ? (place["nearbyAttractions"][0]["ticketPricing"] == 0 ? "Free" : place["nearbyAttractions"][0]["ticketPricing"])
                              : "NA")} ",
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 14),
                        ),
                      ),


                    ],
                  ),
                )





              ],
            ),
          );
        },),
      ),
    );
  }
  Widget _shimmerEffect({required double width, required double height}) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }

}
