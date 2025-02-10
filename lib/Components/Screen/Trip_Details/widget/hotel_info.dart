import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shimmer/shimmer.dart';


class HotelInfo extends StatefulWidget {
  final List hotelList;

  const HotelInfo({super.key, required this.hotelList});

  @override
  State<HotelInfo> createState() => _HotelInfoState();
}

class _HotelInfoState extends State<HotelInfo> {
  Map<String, String> hotelPhotos = {};
  final String? apiKey = dotenv.env["Mapapikey"];

  @override
  void initState() {
    super.initState();
    fetchHotelPhotos();
  }

  Future<void> fetchHotelPhotos() async {
    for (var hotel in widget.hotelList) {
      String hotelName = hotel["hotelName"];
      String? photoUrl = await getHotelPhoto(hotelName);
      if (photoUrl != null) {
        setState(() {
          hotelPhotos[hotelName] = photoUrl;
        });
      }
    }
  }

  Future<String?> getHotelPhoto(String hotelName) async {
    final String url =
        'https://maps.googleapis.com/maps/api/place/findplacefromtext/json'
        '?input=$hotelName&inputtype=textquery&fields=photos&key=$apiKey';

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
    return null;
  }

  String processPrice(String price) {
    List<String> characters = price.split('');
    String minPrice = '';
    String maxPrice = '';
    bool isMinPrice = true;

    for (var char in characters) {
      if (char == '-' || char == ' ' || (int.tryParse(char) != null)) {
        if (char != ' ' && char != '-') {
          if (isMinPrice) {
            minPrice += char;
          } else {
            maxPrice += char;
          }
        } else if (char == '-') {
          isMinPrice = false;
        }
      }
    }

    return '$minPrice-$maxPrice₹';
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: List.generate(
          widget.hotelList.length,
              (index) {
            final hotel = widget.hotelList[index];
            String hotelName = hotel["hotelName"];
            String? imageUrl = hotelPhotos[hotelName];

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
                      hotelName,
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
                        Text("⭐ ${hotel["rating"]}"),
                        hotel["priceRange"]!=null ? Text("💰${processPrice(hotel["priceRange"])}"):Text("💰${processPrice(hotel["price"])}"),
                ],
                    ),
                  )
                ],
              ),
            );
          },
        ),
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
