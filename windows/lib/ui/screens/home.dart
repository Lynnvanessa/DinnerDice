import 'package:diner_dice/data/providers/home_provider.dart';
import 'package:diner_dice/ui/widgets/restaurant_preview.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<HomeProvider>(builder: (context, provider, child) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: OutlinedButton(
                onPressed: provider.searching ? null : provider.getRestaurants,
                child: const Text("Roll the Dice"),
              ),
            ),
            Center(
              child: Visibility(
                visible: provider.searching,
                child: Image.asset(
                  "assets/icons/dice.gif",
                  width: 80,
                  height: 80,
                ),
              ),
            ),
            if (provider.selectedRestaurant != null && !provider.searching)
              RestaurantPreview(provider.selectedRestaurant!),
            if (provider.restaurants.isNotEmpty && !provider.searching)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                alignment: Alignment.center,
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed("restaurants/nearby");
                  },
                  child: const Text("try other nearby restaurants"),
                ),
              )
          ],
        );
      }),
    );
  }
}
