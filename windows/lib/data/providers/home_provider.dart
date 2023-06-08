import 'package:diner_dice/data/models/alert.dart';
import 'package:diner_dice/data/models/nearby_place.dart';
import 'package:diner_dice/data/repositories/home_repo.dart';
import 'package:diner_dice/ui/widgets/inputs/select_input.dart';
import 'package:flutter/material.dart';

class HomeProvider extends ChangeNotifier {
  final _repo = HomeRepo();
  void onChange() => notifyListeners();
  List<NearbyPlace> get restaurants => _repo.restaurants;
  NearbyPlace? get selectedRestaurant => _repo.suggestedRestaurant;
  bool get hasNextPage => _repo.nextPageToken != null;
  bool isLoadingMore = false;
  bool searching = false;

  List<Alert> get alerts => _repo.alerts;

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

  void setType(InputOption? option) {
    _repo.clear();
    _repo.type = option?.value ?? "restaurant";
    notifyListeners();
  }

  void clear() {
    _repo.clear();
    notifyListeners();
  }
}
