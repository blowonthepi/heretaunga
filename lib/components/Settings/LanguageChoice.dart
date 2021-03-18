import 'package:flutter/material.dart';
import 'package:heretaunga/components/Main/language_chips.dart';
import 'package:heretaunga/components/keys.dart';
import 'package:heretaunga/screens/settings.dart';

/// Returns a dropdown widget and handles language switching
class LanguageChoice extends StatelessWidget {
  final ValueChanged onChanged;

  LanguageChoice({@required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Text(
              "Labels Language",
              style: Settings.headingStyle,
            ),
          ),
          LanguageChips(
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
