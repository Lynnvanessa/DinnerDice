import 'package:cached_network_image/cached_network_image.dart';
import 'package:diner_dice/ui/theme/colors.dart';
import 'package:diner_dice/ui/theme/typography.dart';
import 'package:diner_dice/ui/widgets/rectangular_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_place/google_place.dart';
import 'package:maps_launcher/maps_launcher.dart';

class RestaurantPreview extends StatelessWidget {
  const RestaurantPreview(
    this.restaurant, {
    Key? key,
    this.isDiceSelected = false,
  }) : super(key: key);
  final SearchResult restaurant;

  /// [isDiceSelected] whether it has been selected by the dice roll
  final bool isDiceSelected;

  void _try() {
    MapsLauncher.launchCoordinates(
      restaurant.geometry?.location?.lat ?? 0,
      restaurant.geometry?.location?.lng ?? 0,
      restaurant.name,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(8),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: isDiceSelected ? AppColors.surfaceVariant : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey,
                    ),
                    borderRadius: RectangularBorderRadius(8)),
                child: CachedNetworkImage(
                  imageUrl: restaurant.icon ?? "",
                  width: 60,
                  height: 60,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        restaurant.name ?? "(UnNamed)",
                        style: AppTypography.bodySemiBold(),
                      ),
                      Text(restaurant.vicinity ?? ""),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              alignment: Alignment.centerLeft,
                              margin: const EdgeInsets.only(top: 8),
                              child: restaurant.rating == null
                                  ? const Text("No rating")
                                  : Wrap(
                                      children: [
                                        RatingBarIndicator(
                                          itemBuilder: (context, inedx) =>
                                              const Icon(
                                            Icons.star,
                                            color: Colors.amber,
                                          ),
                                          itemCount: 5,
                                          itemSize: 20,
                                          rating: restaurant.rating ?? 0.0,
                                        ),
                                        Text(
                                            "(${restaurant.rating})(${restaurant.userRatingsTotal})")
                                      ],
                                    ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(left: 8),
                            child: isDiceSelected
                                ? ElevatedButton(
                                    onPressed: _try,
                                    child: const Text(
                                      "Try it!",
                                      textAlign: TextAlign.center,
                                    ),
                                  )
                                : OutlinedButton(
                                    onPressed: _try,
                                    child: const Text(
                                      "Try it!",
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
