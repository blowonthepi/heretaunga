import 'package:flutter/material.dart';
import 'package:heretaunga/components/Settings/GenericSettingsItem.dart';
import 'package:heretaunga/components/keys.dart';
import 'package:heretaunga/screens/settings.dart';

class ThemeModeSelector extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GenericSettingsItem(
            child: Text("Theme", style: Settings.headingStyle,),
          ),
          GenericSettingsItem(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return ToggleButtons(
                  renderBorder: false,
                  borderRadius: BorderRadius.circular(7),
                  constraints: BoxConstraints.expand(width: constraints.maxWidth / 3),
                  selectedColor: Theme.of(context).bottomNavigationBarTheme.selectedItemColor,
                  fillColor: Theme.of(context).bottomNavigationBarTheme.selectedItemColor.withOpacity(0.2),
                  children: <Widget>[
                    toggleButton(
                      icon: Icons.settings_applications_rounded,
                      label: "System",
                    ),
                    toggleButton(
                      icon: Icons.nightlight_round,
                      label: "Dark",
                    ),
                    toggleButton(
                      icon: Icons.wb_sunny_rounded,
                      label: "Light",
                    ),
                  ],
                  onPressed: (mode) {
                    Keys.accessThemeData.currentState.updateThemeMode(
                        mode: mode);
                  },
                  isSelected: Keys.accessThemeData.currentState
                      .getThemeModeBoolList(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget toggleButton({IconData icon, String label}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0, top: 8.0, bottom: 8.0),
          child: Icon(icon),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(label),
        ),
      ],
    );
  }
}
