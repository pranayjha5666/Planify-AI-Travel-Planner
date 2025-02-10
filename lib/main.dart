import 'package:ai_travel_planner/Provider/CreateTripProvider.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'Components/Screen/Notification/Services/notification_services.dart';
import 'Components/Screen/Splash_Screen/splash_screen.dart';
import 'Provider/addtofavprovider.dart';
import 'Route/route.dart';
import 'firebase_options.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  WidgetsFlutterBinding.ensureInitialized(); // Ensures proper binding for async calls
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, // For Web, iOS, Android
  );
  NotificationServices().initalized();

  runApp(
      const MyApp());
}

class MyApp extends StatelessWidget {

  const MyApp({super.key});


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context)=>TripProvider()),
        ChangeNotifierProvider(create: (context) => FavoriteStatusProvider(),)
      ],
      child: MaterialApp(
        navigatorKey: navigatorKey, // Set the navigatorKey
        debugShowCheckedModeBanner: false,
        title: 'Travel Planner',
        onGenerateRoute: (settings)=>generateRoute(settings),
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const SplashScreen(),
      ),
    );
  }
}
