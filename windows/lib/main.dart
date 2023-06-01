import 'package:diner_dice/data/providers/home_provider.dart';
import 'package:diner_dice/ui/screens/home.dart';
import 'package:diner_dice/ui/screens/nearby_restaurants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
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
        theme: ThemeData(
          fontFamily: "McLaren",
          primarySwatch: Colors.blue,
        ),
        initialRoute: "/",
        routes: {
          "/": (context) => const HomeScreen(),
          "restaurants/nearby": (context) => const NearbyRestaurantsScreen(),
        },
      ),
    );
  }
}
