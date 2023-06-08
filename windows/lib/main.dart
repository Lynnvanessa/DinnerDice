import 'package:diner_dice/data/providers/home_provider.dart';
import 'package:diner_dice/ui/screens/home.dart';
import 'package:diner_dice/ui/screens/nearby_restaurants.dart';
import 'package:diner_dice/ui/theme/theme.dart';
import 'package:flutter/material.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // MobileAds.instance.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => HomeProvider(),
      child: MaterialApp(
        title: 'Diner Dice',
        theme: AppTheme.themeData,
        initialRoute: "/",
        routes: {
          "/": (context) => const HomeScreen(),
          "restaurants/nearby": (context) => const NearbyRestaurantsScreen(),
        },
      ),
    );
  }
}
