import 'package:flutter/material.dart';

class GenericSettingsItem extends StatelessWidget {
  final Widget child;
  GenericSettingsItem({this.child});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: child,
    );
  }
}
