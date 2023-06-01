import 'dart:math';

import 'package:diner_dice/data/repositories/base_repo.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_place/google_place.dart';
import 'package:location/location.dart' as loc;

import '../../utils/functions.dart';

class HomeRepo extends BaseRepo {
  List<SearchResult> restaurants = [];
  SearchResult? selectedRestaurant;

  Future<Position> _getCurrentLocation() async {
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
      showToast(
          "The app has been denied permission to access location services.",
          length: Toast.LENGTH_LONG);
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    return await Geolocator.getCurrentPosition();
  }

  Future<void> getRestaurants() async {
    selectedRestaurant = null;
    final position = await _getCurrentLocation();
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
    restaurants = result.results ?? [];

    //get random restaurant from list
    if (restaurants.isNotEmpty) {
      final random = Random();
      final index = random.nextInt(restaurants.length - 1);
      selectedRestaurant = restaurants[index];
    }
  }
}
