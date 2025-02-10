import 'package:flutter/material.dart';
import 'package:ai_travel_planner/Model/tripdetails_model.dart';
import '../Components/Screen/About_Me/about_me.dart';
import '../Components/Screen/Auth/Pages/change_password.dart';
import '../Components/Screen/Auth/Pages/login_page.dart';
import '../Components/Screen/Auth/Pages/signup_page.dart';
import '../Components/Screen/Create_Trip/Pages/generate_trip.dart';
import '../Components/Screen/Create_Trip/Pages/reveiew_trip.dart';
import '../Components/Screen/Create_Trip/Pages/select_budget.dart';
import '../Components/Screen/Create_Trip/Pages/search_place.dart';
import '../Components/Screen/Create_Trip/Pages/select_traveller.dart';
import '../Components/Screen/Create_Trip/Pages/travel_dates.dart';
import '../Components/Screen/Help_And_Support/help_and_support_screen.dart';
import '../Components/Screen/Home_Page/home_page.dart';
import '../Components/Screen/My_Trip/my_trip_page.dart';
import '../Components/Screen/Notification/notification_screen.dart';
import '../Components/Screen/Splash_Screen/splash_screen.dart';
import '../Components/Screen/Trip_Details/tripdetailspage.dart';

Route<dynamic> generateRoute(RouteSettings routeSettings) {
  switch(routeSettings.name){
    case LoginPage.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const LoginPage(),
      );
    case Home_Page.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const Home_Page(),
      );
    case SplashScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const SplashScreen(),
      );
    case SignupPage.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const SignupPage(),
      );
    case SearchPlace.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const SearchPlace(),
      );
    case SelectTraveller.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const SelectTraveller(),
      );
    case TravelDates.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const TravelDates(),
      );
    case SelectBudget.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const SelectBudget(),
      );
    case ReviewTrip.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const ReviewTrip(),
      );

    case GenerateTrip.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const GenerateTrip(),
      );
    case MyTripPage.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const MyTripPage(),
      );
    case TripDetailsPage.routeName:
      var tripdetails=routeSettings.arguments as TripDetails;
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => TripDetailsPage(tripDetails: tripdetails),
      );
    case ChangePasswordPage.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => ChangePasswordPage(),
      );
    case NotificationScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => NotificationScreen(),
      );
    case HelpAndSupportPage.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => HelpAndSupportPage(),
      );
    case AboutMePage.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => AboutMePage(),
      );
    default:
      return MaterialPageRoute(builder: (_) => const Scaffold(
        body: Center(
          child: Text("Screen Does Not Exits"),
        ),
      ),);
  }
}