import 'dart:math';

import 'package:diner_dice/data/repositories/base_repo.dart';
import 'package:diner_dice/utils/consts.dart';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_place/google_place.dart';
import 'package:location/location.dart' as loc;
import 'package:package_info_plus/package_info_plus.dart';

import '../../utils/functions.dart';

class HomeRepo extends BaseRepo {
  List<SearchResult> restaurants = [];
  SearchResult? selectedRestaurant;
  String? nextPageToken;
  String type = "restaurant";
  final List<SearchResult> _previouslySelectedRestaurants = [];

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

  Future<List<SearchResult>> _getNearbyRestaurants({String? pageToken}) async {
    final position = await _getCurrentLocation();
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    Map<String, String> headers = <String, String>{
      if (defaultTargetPlatform == TargetPlatform.iOS)
        'x-ios-bundle-identifier': packageInfo.packageName,
      if (defaultTargetPlatform == TargetPlatform.android) ...{
        'x-android-package': packageInfo.packageName,
        'x-android-cert': SHA1_SIGNING_KEY,
      }
    };
    if (kDebugMode) {
      headers = {};
    }
    final googlePlace = GooglePlace(MAPS_API_KEY, headers: headers);
    final result = await googlePlace.search.getNearBySearch(
      kDebugMode
          ? Location(
              lat: 54.5181885,
              lng: -1.5675516,
            )
          : Location(
              lat: position.latitude,
              lng: position.longitude,
            ),
      5000,
      type: type,
      opennow: true,
      pagetoken: pageToken,
    );

    if (result == null) {
      if (pageToken != null) {
        //retry the fetch
        return await _getNearbyRestaurants(pageToken: pageToken);
      } else {
        showToast("Failed to process the request, please try again");
      }
      return [];
    }
    nextPageToken = result.nextPageToken;

    if ((result.results == null || result.results?.isEmpty == true) &&
        pageToken == null) {
      showToast("No restaurants found");
      return [];
    }
    return result.results ?? [];
  }

  Future<void> getRestaurants() async {
    selectedRestaurant = null;

    final fetchedRestaurants =
        await _getNearbyRestaurants(pageToken: nextPageToken);
    fetchedRestaurants.removeWhere((fetched) =>
        restaurants.indexWhere((existing) =>
            fetched.name == existing.name &&
            fetched.vicinity == existing.vicinity) !=
        -1);
    restaurants.addAll(fetchedRestaurants);

    //get random restaurant from list
    if (restaurants.isNotEmpty) {
      final random = Random();
      List<SearchResult> restaurantsClone = List.from(restaurants);
      restaurantsClone.removeWhere((res) => _previouslySelectedRestaurants
          .any((ps) => ps.placeId == res.placeId || ps.name == res.name));
      if (restaurantsClone.isEmpty) {
        restaurantsClone.addAll(_previouslySelectedRestaurants);
      }
      restaurantsClone.shuffle();
      final index = random.nextInt(restaurantsClone.length - 1);
      selectedRestaurant = restaurantsClone[index];
      _previouslySelectedRestaurants.add(selectedRestaurant!);
    }
  }

  Future<void> getMoreRestaurants() async {
    if (nextPageToken != null) {
      restaurants.addAll(await _getNearbyRestaurants(pageToken: nextPageToken));
    }
  }

  void clear() {
    _previouslySelectedRestaurants.clear();
    restaurants.clear();
    nextPageToken = null;
    selectedRestaurant = null;
  }
}
