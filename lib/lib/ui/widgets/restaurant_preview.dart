import 'package:cached_network_image/cached_network_image.dart';
import 'package:diner_dice/ui/widgets/rectangular_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_place/google_place.dart';

class RestaurantPreview extends StatelessWidget {
  const RestaurantPreview(this.restaurant, {Key? key}) : super(key: key);
  final SearchResult restaurant;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      child: InkWell(
        onTap: () {},
        radius: 12,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(8),
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(restaurant.name ?? "No name"),
                          Text(
                            restaurant.openingHours?.openNow ?? false
                                ? "Open Now"
                                : "Closed",
                          ),
                          Container(
                            alignment: Alignment.centerRight,
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
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              ElevatedButton(
                  onPressed: () {},
                  child: const SizedBox(
                    child: Text(
                      "Try it!",
                      textAlign: TextAlign.center,
                    ),
                    width: double.infinity,
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
