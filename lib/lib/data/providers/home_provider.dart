import 'package:diner_dice/data/repositories/home_repo.dart';
import 'package:flutter/material.dart';
import 'package:google_place/google_place.dart';

class HomeProvider extends ChangeNotifier {
  final _repo = HomeRepo();
  List<SearchResult> get restaurants => _repo.restaurants;
  SearchResult? get selectedRestaurant => _repo.selectedRestaurant;
  bool get hasNextPage => _repo.nextPageToken != null;
  bool isLoadingMore = false;
  bool searching = false;

  Future<void> getRestaurants() async {
    searching = true;
    notifyListeners();

    try {
      await _repo.getRestaurants();
    } catch (e) {}

    searching = false;
    notifyListeners();
  }

  Future<void> getMoreRestaurants() async {
    if (!hasNextPage) {
      return;
    }
    isLoadingMore = true;
    notifyListeners();

    try {
      await _repo.getMoreRestaurants();
    } catch (e) {}

    isLoadingMore = false;
    notifyListeners();
  }
}
