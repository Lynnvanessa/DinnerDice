import 'package:diner_dice/data/providers/home_provider.dart';
import 'package:diner_dice/ui/widgets/restaurant_preview.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NearbyRestaurantsScreen extends StatefulWidget {
  const NearbyRestaurantsScreen({Key? key}) : super(key: key);

  @override
  State<NearbyRestaurantsScreen> createState() =>
      _NearbyRestaurantsScreenState();
}

class _NearbyRestaurantsScreenState extends State<NearbyRestaurantsScreen> {
  late ScrollController _scrollController;
  HomeProvider get _homeProvider => context.read<HomeProvider>();
  double previousScrollOffset = 0;

  void _loadMore() {
    if (_homeProvider.hasNextPage &&
        !_homeProvider.isLoadingMore &&
        _scrollController.position.extentAfter < 100) {
      _homeProvider.getMoreRestaurants();
    }
  }

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_loadMore);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Nearby restaurants"),
      ),
      body: Consumer<HomeProvider>(
        builder: (context, provider, child) {
          return ListView.builder(
            controller: _scrollController,
            itemCount: provider.restaurants.length + 1,
            itemBuilder: (_, index) {
              if (index >= provider.restaurants.length) {
                if (provider.isLoadingMore) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
                return const SizedBox();
              }
              return RestaurantPreview(provider.restaurants[index]);
            },
          );
          // return Column(
          //   children: [
          //     for (final restaurant in provider.restaurants)
          //       RestaurantPreview(restaurant)
          //   ],
          // );
        },
      ),
    );
  }
}
