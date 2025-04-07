import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

class CardBoxItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String image;

  const CardBoxItem({
    super.key,
    required this.icon,
    required this.title,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    // return Container(
    //   width: 180,
    //   height: 150, // Fixed width for each card
    //   padding: const EdgeInsets.all(16),
    //   margin: const EdgeInsets.only(top: 10, bottom: 10),
    //   decoration: BoxDecoration(
    //     color: Theme.of(context).colorScheme.surface,
    //     borderRadius: BorderRadius.circular(15),
    //     boxShadow: [
    //       BoxShadow(
    //         color: Colors.black.withOpacity(0.2),
    //         blurRadius: 6,
    //         offset: const Offset(3, 3), // Fading right and bottom
    //       ),
    //     ],
    //   ),
    //   child: Column(
    //     mainAxisAlignment: MainAxisAlignment.center,
    //     crossAxisAlignment: CrossAxisAlignment.start,
    //     children: [
    //       Icon(
    //         icon,
    //         size: 30,
    //         color: Theme.of(context).colorScheme.primary,
    //       ),
    //       const SizedBox(height: 10),
    //       Text(
    //         title,
    //         textAlign: TextAlign.left,
    //         style: Theme.of(context).textTheme.bodyLarge?.copyWith(
    //               fontWeight: FontWeight.bold,
    //             ),
    //       ),
    //       const Row(
    //         crossAxisAlignment: CrossAxisAlignment.end,
    //         mainAxisAlignment: MainAxisAlignment.end,
    //         verticalDirection: VerticalDirection.down,
    //         mainAxisSize: MainAxisSize.max,
    //         children: [Icon(FeatherIcons.arrowRight)],
    //       ),
    //     ],
    //   ),
    // );
    return Container(
      margin: const EdgeInsets.only(right: 3),
      width: 350,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey[20],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Stack(
        children: [
          SizedBox(
              width: 350,
              height: 350,
              child: SizedBox(
                width: 50,
                height: 10,
                child: CachedNetworkImage(
                  imageUrl: image,
                  fit: BoxFit.cover,
                ),
              )),
          Positioned(
            right: 15,
            top: 15,
            child: Card(
              color: Colors.grey[20],
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Icon(
                  icon,
                  size: 30,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              color: Theme.of(context).colorScheme.surface.withAlpha(150),
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 120,
                          height: 24,
                          child: Text(
                            title,
                            textAlign: TextAlign.left,
                            style:
                                Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .inverseSurface,
                                    ),
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    FeatherIcons.arrowRight,
                    color: Theme.of(context).colorScheme.primary,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
