import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../AppState/database.dart';
import '../../AppState/themeNotifier.dart';
import '../../AppState/themeToggleButton.dart';
import '../auth/login.dart';
import '../notifications/notifications.dart';
import '../settings/settings.dart';

class CustomizedAppBar extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey; // Strongly typed

  const CustomizedAppBar(
      {super.key, required this.scaffoldKey}); // Simplified constructor

  @override
  Widget build(BuildContext context) {
    var dbclass = context.read<DataBase>();

    final themeNotifier =
        context.watch<ThemeNotifier>(); // Watch for theme changes

    // Determine the image based on the current theme
    String imagePath = themeNotifier.isDarkMode
        ? 'assets/images/ltr_invert.png'
        : 'assets/images/ltr.png';

    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 2,
      title: Image.asset(
        imagePath, // Directly use the determined image path
        width: 200,
      ),
      leading: IconButton(
        icon: SvgPicture.asset(
          'assets/icons/menu.svg',
          color: Theme.of(context).primaryColor,
        ),
        onPressed: () => scaffoldKey.currentState!.openDrawer(),
      ),
      actions: [
        // (dbclass.id == "")
        //     ? InkWell(
        //         onTap: () {
        //           Navigator.of(context).push(MaterialPageRoute(
        //               builder: (BuildContext context) =>
        //                   Notifications(id: dbclass.id)));
        //         },
        //         child: const Icon(
        //           FeatherIcons.bell,
        //           // size: 30,
        //           color: Color(0xFFED1C24),
        //         ),
        //       )
        //     : Container(),
        const SizedBox(
          width: 4.0,
        ),
        // FutureBuilder(
        //   future: dbclass.getEmail(),
        //   initialData: const Center(
        //     child: CircularProgressIndicator(),
        //   ),
        //   builder: (BuildContext context, AsyncSnapshot snapshot) {
        //     return GestureDetector(
        //       onTap: () async {
        //         if (dbclass.id == "") {
        //           // print(dbclass.email);
        //           Navigator.of(context).push(MaterialPageRoute(
        //               builder: (BuildContext context) => const Login()));
        //         } else {
        //           // print(dbclass.email);
        //           Navigator.of(context).push(MaterialPageRoute(
        //               builder: (BuildContext context) =>
        //                   Settings(id: dbclass.id)));
        //         }
        //       },
        //       child: const Icon(
        //         FeatherIcons.user,
        //         // size: 35,
        //         color: Color(0xFFED1C24),
        //       ),
        //     );
        //   },
        // ),
        GestureDetector(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => Settings(id: dbclass.id)));
          },
          child: Icon(
            color: Theme.of(context).primaryColor,
            FeatherIcons.settings,
          ),
        ),
        const SizedBox(
          width: 8.0,
        ),
      ],
    );
  }
}
