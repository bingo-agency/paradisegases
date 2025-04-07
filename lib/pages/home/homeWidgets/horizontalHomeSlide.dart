import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:paradise_gases/pages/inventory/inventory.dart';
import 'package:paradise_gases/pages/widgets/loadingWidgets/featuredLoading.dart';
import 'package:provider/provider.dart';
import '../../../AppState/database.dart';
import '../../../widgets/CardBoxItem.dart';
import '../../challan/Challan.dart';
import '../../staffScreens/Empties.dart';

class Horizontalhomeslide extends StatelessWidget {
  const Horizontalhomeslide({super.key});

  @override
  Widget build(BuildContext context) {
    var dbclass = context.read<DataBase>();

    dbclass.confirmUser();

    return SizedBox(
      height: 200.0, // Constrained height for the horizontal ListView
      child: Consumer<DataBase>(builder: (context, dbclass, child) {
        if (dbclass.isLoading) {
          return FeaturedLoading();
        } else {
          if (dbclass.type == 'staff') {
            return ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              children: [
                // First Item
                GestureDetector(
                  onTap: () {
                    print('View empties');
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Empties()),
                    );
                  },
                  child: CardBoxItem(
                    icon: FeatherIcons.thermometer,
                    title: 'View Empties',
                    image:
                        'https://paradisegases.com/images/nitrogenCylinder.png',
                  ),
                ),
                SizedBox(width: 16), // Spacing between cards
                // Second Item
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Challan(),
                      ),
                    );
                  },
                  child: CardBoxItem(
                    icon: FeatherIcons.checkCircle,
                    title: 'Challans',
                    image: 'https://paradisegases.com/images/oxygen.png',
                  ),
                ),
                SizedBox(width: 16), // Spacing between cards
                // Third Item
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Inventory(),
                      ),
                    );
                  },
                  child: CardBoxItem(
                    icon: FeatherIcons.layers,
                    title: 'Inventory',
                    image:
                        'https://bingo-agency.com/paradisegases.com/admin/images/allCylinders.jpg',
                  ),
                ),
              ],
            );
          } else {
            return ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              children: [
                // First Item
                GestureDetector(
                  onTap: () {
                    print('View empties');
                  },
                  child: CardBoxItem(
                    icon: Icons.visibility,
                    title: 'View Requests',
                    image:
                        'https://bingo-agency.com/paradisegases.com/admin/images/requestCylinders.jpg',
                  ),
                ),
                SizedBox(width: 16), // Spacing between cards
                // Second Item
                CardBoxItem(
                  icon: Icons.done_all,
                  title: 'Complete Challans',
                  image:
                      'https://bingo-agency.com/paradisegases.com/admin/images/completedRequests.png',
                ),
                SizedBox(width: 16), // Spacing between cards
                // Third Item
                CardBoxItem(
                  icon: Icons.group,
                  title: 'Payment History',
                  image:
                      'https://bingo-agency.com/paradisegases.com/admin/images/paymentHistory.jpeg',
                ),
              ],
            );
          }
        }
      }),
    );
  }
}
