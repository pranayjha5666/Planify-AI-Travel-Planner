import 'package:ai_travel_planner/Common/widget/custom_button.dart';
import 'package:ai_travel_planner/Components/Screen/Splash_Screen/Services/splash_screen_services.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../../../responsive.dart';

class SplashScreen extends StatefulWidget {
  static const String routeName = "/splash-screen";
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _iconAnimation;
  late List<Animation<double>> _letterAnimations;
  late Animation<Offset> _slideUpAnimation;

  final String appName = "lanify";

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    _iconAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.2, curve: Curves.easeInOut),
    );

    _letterAnimations = List.generate(appName.length, (index) {
      return CurvedAnimation(
        parent: _controller,
        curve: Interval(0.3 + (index * 0.1), 0.3 + ((index + 1) * 0.1),
            curve: Curves.easeInOut),
      );
    });

    _slideUpAnimation = Tween<Offset>(
      begin: const Offset(0, 0.6),
      end: const Offset(0, 0),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              color: Colors.white,
            ),
          ),
          Positioned(
            top: 50,
            right: 20,
            child: Opacity(
              opacity: 1,
              child: Row(
                children: [
                  Image.asset(
                    "assets/appicon/iconn.png",
                    width: 15,
                    height: screenHeight * 0.02,
                  ),
                  Text(appName)
                ],
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FadeTransition(
                      opacity: _iconAnimation,
                      child: Image.asset(
                        "assets/appicon/iconn.png",
                        height: screenHeight * 0.065,
                      ),
                    ),
                    SizedBox(width: 2,),
                    Row(
                      children: List.generate(appName.length, (index) {
                        return FadeTransition(
                          opacity: _letterAnimations[index],
                          child: Text(
                            appName[index],
                            style: TextStyle(
                              fontSize: screenHeight * 0.045,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Outfit',
                              color: Colors.black87,
                              letterSpacing: 2,
                            ),
                          ),
                        );
                      }),
                    ),
                  ],
                ),
                SizedBox(height: screenHeight * 0.03),
                SlideTransition(
                  position: _slideUpAnimation,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
                    child: Text(
                      'Explore the world effortlessly with Planify!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: screenHeight * 0.022,
                        fontFamily: 'Outfit',
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.05),
                Lottie.asset(
                  "assets/animations/car2.json",
                  height: screenHeight * 0.25,
                  reverse: false,
                  repeat: false,
                ),
              ],
            ),
          ),
          Positioned(
            bottom: screenHeight * 0.05,
            left: screenWidth * 0.1,
            right: screenWidth * 0.1,
            child: SlideTransition(
              position: _slideUpAnimation,
              child: CustomButton(
                onTap: () async {
                  await SplashScreenServices().isLogin(context);
                },
                text: "Get Started",
                padding: Responsive.isMobile(context)
                    ? EdgeInsets.symmetric(vertical: screenWidth * 0.04)
                    : EdgeInsets.symmetric(vertical: screenWidth * 0.01),
                margin: EdgeInsets.only(top: screenHeight * 0.02),
                fontSize: !Responsive.isMobile(context) ? 35 : 16,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
