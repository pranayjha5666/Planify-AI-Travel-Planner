import 'package:ai_travel_planner/Common/widget/custom_button.dart';
import 'package:ai_travel_planner/Components/Screen/My_Trip/widget/Usertriplist_widget/otherhistory.dart';
import 'package:ai_travel_planner/Components/Screen/My_Trip/widget/Usertriplist_widget/recenthistory.dart';
import 'package:ai_travel_planner/Components/Screen/Trip_Details/tripdetailspage.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

class Usertriplist extends StatefulWidget {
  final trips;
  const Usertriplist({super.key, required this.trips});

  @override
  State<Usertriplist> createState() => _UsertriplistState();
}

class _UsertriplistState extends State<Usertriplist> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool isFav = false;
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

  Widget _recenttriphistory(String location, String dates,
      String whoistravelling, String photourl, var trips) {
    DateTime date = DateTime.parse(dates);
    String formattedDate = DateFormat('dd MMM yyyy').format(date);
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 240,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
          ),
          clipBehavior: Clip.hardEdge,
          child: CachedNetworkImage(
            imageUrl: photourl,
            fit: BoxFit.cover,
            placeholder: (context, url) =>
                _shimmerEffect(width: double.infinity, height: 240),
            errorWidget: (context, url, error) => Icon(Icons.error),
          ),
        ),
        SizedBox(height: 10),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              location,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 20,
                fontFamily: 'Outfit',
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade800,
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    formattedDate,
                    style: TextStyle(
                      fontSize: 17,
                      fontFamily: 'Outfit',
                      fontWeight: FontWeight.w200,
                      color: Colors.black,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        "🚌",
                        style: TextStyle(
                          fontSize: 17,
                          fontFamily: 'Outfit',
                          fontWeight: FontWeight.w200,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(width: 5),
                      Text(
                        whoistravelling,
                        style: TextStyle(
                          fontSize: 17,
                          fontFamily: 'Outfit',
                          fontWeight: FontWeight.w200,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            CustomButton(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  TripDetailsPage.routeName,
                  arguments: trips[0],
                );
              },
              text: "See your plan",
            ),
          ],
        ),
      ],
    );
  }

  Widget _othertriphistory(
      String location,
      String dates,
      String whoistravelling,
      String photourl,
      var trips,
      int index,
      bool isFavd) {
    DateTime date = DateTime.parse(dates);
    String formattedDate = DateFormat('dd MMM yyyy').format(date);
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          TripDetailsPage.routeName,
          arguments: trips,
        );
      },
      child: Stack(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                ),
                clipBehavior: Clip.hardEdge,
                child: CachedNetworkImage(
                  imageUrl: photourl,
                  fit: BoxFit.cover,
                  placeholder: (context, url) =>
                      _shimmerEffect(width: 100, height: 100),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
              SizedBox(width: 10),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    location,
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: 'Outfit',
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.shade800,
                    ),
                  ),
                  Text(
                    formattedDate,
                    style: TextStyle(
                      fontSize: 17,
                      fontFamily: 'Outfit',
                      fontWeight: FontWeight.w200,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    "Traveller: $whoistravelling",
                    style: TextStyle(
                      fontSize: 17,
                      fontFamily: 'Outfit',
                      fontWeight: FontWeight.w200,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Positioned(
            right: 10,
            top: 10,
            child: IconButton(
              icon: Icon(
                isFavd ? Icons.favorite : Icons.favorite_border,
                color: isFavd ? Colors.red : Colors.grey,
              ),
              onPressed: () {
                setState(() {
                  isFavd = !isFavd;
                });
              },
            ),
          ),
        ],
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
