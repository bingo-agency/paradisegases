import 'package:flutter/material.dart';
import 'package:flutter_scrolling_fab_animated/flutter_scrolling_fab_animated.dart';
import 'package:provider/provider.dart';
import '../../AppState/database.dart';
import '../auth/login.dart';
import '../../AppState/themeNotifier.dart';
import '../challan/NewSaleScreen.dart';

class CustomFabButton extends StatelessWidget {
  final ScrollController scrollController;

  const CustomFabButton({super.key, required this.scrollController});

  @override
  Widget build(BuildContext context) {
    var dbclass = context.read<DataBase>();
    final themeNotifier =
        context.watch<ThemeNotifier>(); // Watch for theme changes

    return ScrollingFabAnimated(
      icon: Icon(
        Icons.add,
        color: themeNotifier.isDarkMode
            ? Colors.white // Dark mode icon color
            : Theme.of(context).colorScheme.onPrimary, // Light mode icon color
      ),
      text: Text(
        'Add',
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: themeNotifier.isDarkMode
                  ? Colors.white // Dark mode text color
                  : Theme.of(context)
                      .colorScheme
                      .onPrimary, // Light mode text color
              fontSize: 16.0,
            ),
      ),
      onPress: () async {
        if (dbclass.id == "") {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (BuildContext context) => const Login(),
            ),
          );
        } else {
          print(dbclass.email);
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (BuildContext context) => NewSaleScreen(),
            ),
          );
          // dbclass.add_new_erc(dbclass.id);
        }
      },
      scrollController: scrollController,
      animateIcon: true,
      curve: Curves.easeInOut,
      inverted: false,
      radius: 10.0,
    );
  }
}
