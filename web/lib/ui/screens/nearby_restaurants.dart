import 'package:diner_dice/data/providers/home_provider.dart';
import 'package:diner_dice/ui/theme/colors.dart';
import 'package:diner_dice/ui/widgets/restaurant_preview.dart';
import 'package:flutter/material.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';
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
  // final topBanner = BannerAd(
  //   size: AdSize.banner,
  //   adUnitId: BANNER_AD_UNIT_ID,
  //   listener: const BannerAdListener(),
  //   request: const AdRequest(),
  // );
  // final bottomBanner = BannerAd(
  //   size: AdSize.banner,
  //   adUnitId: BANNER_AD_UNIT_ID,
  //   listener: const BannerAdListener(),
  //   request: const AdRequest(),
  // );

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
    // topBanner.load();
    // bottomBanner.load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Nearby restaurants"),
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.onSurface,
        elevation: 1,
      ),
      body: Consumer<HomeProvider>(
        builder: (context, provider, child) {
          return Column(
            children: [
              // SizedBox(
              //   child: AdWidget(ad: topBanner),
              //   height: topBanner.size.height.toDouble(),
              // ),
              Expanded(
                child: ListView.builder(
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
                ),
              ),
              // SizedBox(
              //   child: AdWidget(ad: bottomBanner),
              //   height: bottomBanner.size.height.toDouble(),
              // ),
            ],
          );
        },
      ),
    );
  }
}
