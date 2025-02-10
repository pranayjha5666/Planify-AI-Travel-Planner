import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../../Common/widget/custom_button.dart';
import '../../../Trip_Details/tripdetailspage.dart';
class Recenthistory extends StatefulWidget {
  final String location;
  final String dates;
  final String whoistravelling;
  final String photourl;
  final trips;
  const Recenthistory({super.key, required this.location, required this.dates, required this.whoistravelling, required this.photourl,required this.trips});

  @override
  State<Recenthistory> createState() => _RecenthistoryState();
}

class _RecenthistoryState extends State<Recenthistory> {
  @override
  Widget build(BuildContext context) {
    DateTime date = DateTime.parse(widget.dates);
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
            imageUrl: widget.photourl,
            fit: BoxFit.cover,
            placeholder: (context, url) => _shimmerEffect(width: double.infinity, height: 240),
            errorWidget: (context, url, error) => Icon(Icons.error),
          ),
        ),
        SizedBox(height: 10),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.location,
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
                        widget.whoistravelling,
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
                  arguments: widget.trips[0],
                );
              },
              text: "See your plan",
            ),
          ],
        ),
      ],
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
