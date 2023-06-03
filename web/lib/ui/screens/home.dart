import 'package:diner_dice/data/providers/home_provider.dart';
import 'package:diner_dice/ui/theme/colors.dart';
import 'package:diner_dice/ui/theme/typography.dart';
import 'package:diner_dice/ui/widgets/buttons/filled_btn.dart';
import 'package:diner_dice/ui/widgets/restaurant_preview.dart';
// import 'package:diner_dice/utils/consts.dart';
import 'package:flutter/material.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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

  @override
  void initState() {
    super.initState();
    // topBanner.load();
    // bottomBanner.load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: Center(
        child: Consumer<HomeProvider>(builder: (context, provider, child) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.only(top: 100),
                child: Image.asset(
                  "assets/icons/logo.png",
                  width: 100,
                ),
              ),
              Text(
                "Diner Dice",
                style: AppTypography.headline(
                  color: AppColors.primary,
                ),
              ),
              // Container(
              //   margin: const EdgeInsets.only(bottom: 40),
              //   child: AdWidget(ad: topBanner),
              //   height: topBanner.size.height.toDouble(),
              // ),
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  "Let The Dice Decide Dinner",
                  textAlign: TextAlign.center,
                  style: AppTypography.subHeadline(),
                ),
              ),
              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Visibility(
                          visible: provider.selectedRestaurant != null,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 20, left: 12, right: 12),
                                child: Text(
                                  "Dice's pick",
                                  style: AppTypography.bodyBold(
                                      color: AppColors.primary),
                                ),
                              ),
                              if (provider.selectedRestaurant != null)
                                RestaurantPreview(
                                  provider.selectedRestaurant!,
                                  isDiceSelected: true,
                                ),
                            ],
                          ),
                          replacement: Image.asset(
                            "assets/icons/double_dice.jpeg",
                            width: 200,
                          ),
                        ),
                        Visibility(
                          visible: provider.restaurants.isNotEmpty &&
                              !provider.searching,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            alignment: Alignment.center,
                            child: OutlinedButton(
                              onPressed: () {
                                Navigator.of(context)
                                    .pushNamed("restaurants/nearby");
                              },
                              child: Text(
                                  "see ${provider.restaurants.length - 1}+ other nearby restaurants"),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                margin: const EdgeInsets.only(bottom: 60),
                child: FilledBtn(
                  onClicked: () => provider.getRestaurants(),
                  text: "Roll the Dice",
                  loading: provider.searching,
                ),
              ),
              // Center(
              //   child: Visibility(
              //     visible: provider.searching,
              //     child: Image.asset(
              //       "assets/icons/dice_rolling.gif",
              //       width: 80,
              //       height: 80,
              //     ),
              //   ),
              // ),
              // Container(
              //   margin: const EdgeInsets.only(top: 40),
              //   child: AdWidget(ad: bottomBanner),
              //   height: bottomBanner.size.height.toDouble(),
              // ),
            ],
          );
        }),
      ),
    );
  }
}
