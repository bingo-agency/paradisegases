import 'package:antdesign_icons/antdesign_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:paradise_gases/AppState/database.dart';
import 'package:paradise_gases/pages/challan/Challan.dart';
import 'package:paradise_gases/pages/home/home.dart';
import 'package:paradise_gases/pages/settings/settings.dart';
import 'package:paradise_gases/pages/staffScreens/Empties.dart';
import 'package:provider/provider.dart';

class CustomBottomAppBar extends StatelessWidget {
  final int currentIndex;

  const CustomBottomAppBar(ScrollController scrollController,
      {super.key, required this.currentIndex});

  void _onItemTapped(BuildContext context, int index) {
    var dbclass = context.read<DataBase>();
    dbclass.getName();
    if (index == currentIndex) return; // Prevents reloading the same screen

    Widget page;
    switch (index) {
      case 0:
        page = Home();
        break;
      case 1:
        page = Challan();
        break;
      case 2:
        page = Empties();
        break;
      case 3:
        page = Settings(
          id: dbclass.id,
        );
        break;
      default:
        return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      onTap: (index) => _onItemTapped(context, index),
      backgroundColor: Theme.of(context).colorScheme.surface,
      currentIndex: currentIndex,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Theme.of(context).colorScheme.secondary,
      unselectedItemColor:
          Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
      selectedLabelStyle: Theme.of(context)
          .textTheme
          .bodyMedium
          ?.copyWith(fontWeight: FontWeight.bold),
      unselectedLabelStyle: Theme.of(context)
          .textTheme
          .bodyMedium
          ?.copyWith(fontWeight: FontWeight.w500),
      items: const [
        BottomNavigationBarItem(
          icon: Icon(FeatherIcons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(AntIcons.unorderedListOutlined),
          label: 'Challans',
        ),
        BottomNavigationBarItem(
          icon: Icon(AntIcons.apartmentOutlined),
          label: 'Empties',
        ),
        BottomNavigationBarItem(
          icon: Icon(AntIcons.settingOutlined),
          label: 'Settings', // Changed from Settings to Profile
        ),
      ],
    );
  }
}
