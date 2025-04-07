import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:paradise_gases/pages/auth/login.dart';
import 'package:paradise_gases/pages/settings/profile.dart';
import 'package:paradise_gases/pages/settings/settings.dart';
import 'package:provider/provider.dart';

import '../../AppState/database.dart';

class SideDrawer extends StatelessWidget {
  const SideDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    var dbclass = context.read<DataBase>();
    dbclass.getName();
    dbclass.getEmail();
    print(dbclass.name);
    print(dbclass.email);
    print(dbclass.avatar);
    return Drawer(
      child: Column(
        children: [
          // Drawer Header
          UserAccountsDrawerHeader(
            accountName: Text(dbclass.name, style: TextStyle(fontSize: 18)),
            accountEmail: Text(dbclass.email),
            currentAccountPicture: CircleAvatar(
              backgroundImage: CachedNetworkImageProvider(
                'https://bingo-agency.com/paradisegases.com/admin/' +
                    dbclass.avatar.toString(),
              ),
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
          ),

          // Drawer Items
          _buildDrawerItem(
            icon: Icons.dashboard,
            text: "Home",
            onTap: () {
              Navigator.pop(context);
              // Navigate to Dashboard screen
            },
          ),
          (dbclass.type == 'staff')
              ? _buildDrawerItem(
                  icon: FeatherIcons.alignJustify,
                  text: "Requests",
                  onTap: () {
                    Navigator.pop(context);

                    // Navigate to Orders screen
                  },
                )
              : Container(),
          _buildDrawerItem(
            icon: FeatherIcons.user,
            text: "Profile",
            onTap: () {
              Navigator.pop(context);
              // Navigate to Settings screen
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Profile(
                    id: dbclass.id,
                  ),
                ),
              );
            },
          ),
          _buildDrawerItem(
            icon: FeatherIcons.settings,
            text: "Settings",
            onTap: () {
              Navigator.pop(context);
              // Navigate to Settings screen
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Settings(
                    id: dbclass.id,
                  ),
                ),
              );
            },
          ),
          Divider(), // Separator
          _buildDrawerItem(
            icon: FeatherIcons.userX,
            text: "Logout",
            onTap: () async {
              dbclass.removeUser(); // Remove user session

              // Navigate to the login screen and clear the navigation stack
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => Login()),
                (route) => false, // Removes all previous routes
              );
            },
          ),
        ],
      ),
    );
  }

  // Drawer Item Builder
  Widget _buildDrawerItem(
      {required IconData icon,
      required String text,
      required VoidCallback onTap}) {
    return ListTile(
      leading: Icon(icon),
      title: Text(text, style: TextStyle(fontSize: 16)),
      onTap: onTap,
    );
  }
}
