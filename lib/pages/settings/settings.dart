import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:paradise_gases/AppState/themeToggleButton.dart';

class Settings extends StatefulWidget {
  final String id;
  Settings({super.key, required this.id});

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings',
          style: GoogleFonts.poppins(fontSize: 22.0),
        ),
      ),
      body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              ListTile(
                title: Text('Update Default Theme'),
                trailing: ThemeToggleButton(),
              ),
              Divider(),
              ListTile(
                title: Text('Sounds & Notifications'),
                trailing: ElevatedButton(onPressed: () {}, child: Text('Off')),
              ),
              Divider(),
              ListTile(
                title: Text('Background Tasks'),
                trailing: ElevatedButton(onPressed: () {}, child: Text('Off')),
              ),
            ],
          )),
    );
  }
}
