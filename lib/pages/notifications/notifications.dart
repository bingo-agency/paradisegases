import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

class Notifications extends StatelessWidget {
  String id;
  Notifications({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    final List<String> notifications = [
      'one',
      'two',
      'three',
      'four',
      'five',
      'six',
      'seven',
      'eight'
    ];
    return Scaffold(
        appBar: AppBar(
          title: const Text('Notifications'),
        ),
        body: ListView.builder(
          itemCount: notifications.length,
          padding: const EdgeInsets.all(8.0),
          itemBuilder: (context, i) {
            return ListTile(
              leading: const Icon(FeatherIcons.activity),
              title: Text(notifications[i].toString()),
              subtitle: const Text('This is the detail of your notification'),
              trailing: const Icon(FeatherIcons.arrowRight),
            );
          },
        ));
  }
}
