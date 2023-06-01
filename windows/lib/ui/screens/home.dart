import 'package:diner_dice/utils/consts.dart';
import 'package:diner_dice/utils/functions.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_place/google_place.dart';
import 'package:location/location.dart' as loc;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      final location = loc.Location();
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        //Location services are not enabled
        showToast("Location services are not enabled");
        return Future.error('Location services are not enabled.');
      }
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  Future<void> determinePosition() async {
    final position = await _determinePosition();
    print(position.toJson());
  }

  Future<void> getNearbyRestaurants() async {
    await _determinePosition()
        .catchError(
      (stackTrrace) {},
    )
        .then((position) async {
      final googlePlace = GooglePlace(MAPS_API_KEY);
      final result = await googlePlace.search.getNearBySearch(
        Location(
          lat: position.latitude,
          lng: position.longitude,
        ),
        1500,
        type: "restaurant",
      );
      if (result == null) {
        showToast("Failed to process the request, please try again");
        return;
      }
      if (result.results == null || result.results?.isEmpty == true) {
        showToast("No restaurants found");
        return;
      }
      //select random restaurant
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: InkWell(
          onTap: getNearbyRestaurants,
          child: const Text("Roll Dice"),
        ),
      ),
    );
  }
}
