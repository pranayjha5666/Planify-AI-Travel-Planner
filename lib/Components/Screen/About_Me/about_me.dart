import 'package:ai_travel_planner/Common/widget/custom_button.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutMePage extends StatefulWidget {
  static const String routeName = "/about-me-screen";

  @override
  State<AboutMePage> createState() => _AboutMePageState();
}

class _AboutMePageState extends State<AboutMePage> {
  // Function to open the email client
  _launchPhone() async {
    final Uri emailLaunchUri = Uri(

      scheme: 'tel',
      path: '+91 8329432361',

    );
    try {
      if (await canLaunchUrl(emailLaunchUri)) {
        await launchUrl(emailLaunchUri);
      } else {
        throw 'Could not launch email client';
      }
    } catch (e) {
      print("Error launching email: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Picture
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: CircleAvatar(
                radius: 60,
                backgroundColor: Colors.grey[300], // Placeholder background color
                child: CachedNetworkImage(
                  imageUrl: "https://res.cloudinary.com/dqe9rpcml/image/upload/v1738787622/svydd0lnym3jog7ztlbu.jpg", // Example image URL
                  placeholder: (context, url) => _shimmerEffect(width: 100, height: 100),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                  imageBuilder: (context, imageProvider) => CircleAvatar(
                    radius: 60,
                    backgroundImage: imageProvider,
                  ),
                ),
              ),
            ),
            // About Card
            Card(
              elevation: 5,
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        'About Me',
                        style: const TextStyle(
                          fontFamily: 'OutFit',
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "I’m Pranay Jha, a dedicated mobile app developer with expertise in Flutter, Android, and backend technologies like Node.js and MongoDB. With over 2 years of Flutter and 3 years of Android development experience, I focus on building user-centric, scalable applications that make a real-world impact. I specialize in integrating AI features to enhance user experience, as seen in my projects like GeoVision (predicting business profitability based on location data), Telehealth (remote healthcare consultations), and E-commerce platforms. I’m passionate about creating innovative solutions that solve problems and provide value through intuitive and efficient technology.",

                      style: const TextStyle(
                      fontFamily: 'OutFit',
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                      textAlign: TextAlign.center,  // Apply justify alignment here


                      // maxLines: 4,
                      // overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),

            // Contact Me Button
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: CustomButton(
                onTap: _launchPhone,
                text: 'Contact Me',

              ),
            ),
          ],
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

