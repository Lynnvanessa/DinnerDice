import 'dart:math';

import 'package:diner_dice/data/models/alert.dart';
import 'package:diner_dice/data/repositories/base_repo.dart';
import 'package:diner_dice/utils/consts.dart';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_place/google_place.dart';
import 'package:location/location.dart' as loc;
import 'package:package_info_plus/package_info_plus.dart';

import '../../utils/functions.dart';

class HomeRepo extends BaseRepo {
  List<SearchResult> restaurants = [];
  SearchResult? suggestedRestaurant;
  String? nextPageToken;
  String type = "restaurant";
  final List<SearchResult> _previouslySuggestedRestaurants = [];

  List<Alert> alerts = [];

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
        alerts.add(
          Alert(
              message: "Location services are not enabled",
              type: AlertType.error),
        );
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
        alerts.add(
          Alert(
              message:
                  "The app has been denied permission to access location services.",
              type: AlertType.error),
        );
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      alerts.add(
        Alert(
            message:
                "The app has been denied permission to access location services.",
            type: AlertType.error),
      );
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
        // was a fetch more request
        // retry the fetch
        return await _getNearbyRestaurants(pageToken: pageToken);
      } else {
        alerts.add(
          Alert(
            message: "Failed to process the request, please try again",
            type: AlertType.error,
          ),
        );
        return [];
      }
    }
    nextPageToken = result.nextPageToken;

    if (result.results!.isEmpty && pageToken == null) {
      showToast("No restaurants found");
      return [];
    }
    return result.results ?? [];
  }

  Future<void> getRestaurants() async {
    suggestedRestaurant = null;

    final fetchedRestaurants =
        await _getNearbyRestaurants(pageToken: nextPageToken);
    final resultsInitiallyEmpty = fetchedRestaurants.isEmpty;

    // remove duplicates
    fetchedRestaurants.removeWhere((fetchedRestaurant) =>
        restaurants.indexWhere((initiallyFetchedRestaurant) =>
            fetchedRestaurant.placeId == initiallyFetchedRestaurant.placeId) !=
        -1);
    restaurants.addAll(fetchedRestaurants);

    /*suggesting a random restaurant */
    final restaurantSuggestions = [...restaurants];
    // remove restaurants with similar names even if the vicinity is different
    final cleanedSuggestions = [...restaurantSuggestions];
    for (final suggestion in restaurantSuggestions) {
      while (
          cleanedSuggestions.where((it) => it.name == suggestion.name).length >
              1) {
        cleanedSuggestions.removeWhere((it) => it.name == suggestion.name);
      }
    }
    restaurantSuggestions
      ..clear()
      ..addAll(cleanedSuggestions);

    // remove initially suggested
    restaurantSuggestions.removeWhere((suggestion) =>
        _previouslySuggestedRestaurants.indexWhere(
            (previouslySuggestedRestaurant) =>
                previouslySuggestedRestaurant.placeId == suggestion.placeId) !=
        -1);
    if (restaurantSuggestions.isEmpty && !resultsInitiallyEmpty) {
      alerts.add(
        Alert(
          message:
              "All open places have been recommended, the app may show duplicate suggestions onwards",
          type: AlertType.warning,
          duration: const Duration(seconds: 7),
        ),
      );
      _previouslySuggestedRestaurants.clear();
      restaurantSuggestions.addAll(restaurants);
    }

    // select a random restaurant
    final randomIndex = Random().nextInt(restaurantSuggestions.length);
    suggestedRestaurant = restaurantSuggestions[randomIndex];
    _previouslySuggestedRestaurants.add(suggestedRestaurant!);
  }

  Future<void> getMoreRestaurants() async {
    if (nextPageToken != null) {
      restaurants.addAll(await _getNearbyRestaurants(pageToken: nextPageToken));
    }
  }

  void clear() {
    _previouslySuggestedRestaurants.clear();
    restaurants.clear();
    nextPageToken = null;
    suggestedRestaurant = null;
  }
}
