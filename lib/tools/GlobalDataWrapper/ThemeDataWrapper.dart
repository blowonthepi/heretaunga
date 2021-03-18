import 'package:flutter/material.dart';
import 'package:heretaunga/components/keys.dart';
import 'package:shared_preferences/shared_preferences.dart';

typedef ThemeDataWidgetBuilder = Widget Function(BuildContext context);

enum ThemeOption {
  System,
  Dark,
  Light
}
const int _TO_SYS = 0;
const int _TO_DARK = 1;
const int _TO_LIGHT = 2;

class ThemeDataWrapper extends StatefulWidget {
  ThemeDataWrapper({this.themeDataWidgetBuilder});
  final ThemeDataWidgetBuilder themeDataWidgetBuilder;

  @override
  ThemeDataWrapperState createState() => ThemeDataWrapperState();

  static ThemeDataWrapperState of(BuildContext context) {
    return context.findAncestorStateOfType<State<ThemeDataWrapper>>();
  }

  static int getThemeOption(ThemeOption option) {
    switch(option) {
      case ThemeOption.System:
        return _TO_SYS;
      case ThemeOption.Dark:
        return _TO_DARK;
      case ThemeOption.Light:
        return _TO_LIGHT;
      default:
        return _TO_SYS;
    }
  }

  @override
  Key get key => Keys.accessThemeData;
}

class ThemeDataWrapperState extends State<ThemeDataWrapper> {
  Future _future;
  SharedPreferences prefs;

  @override
  void initState() {
    _future = _initGlobals();
    super.initState();
  }

  refreshGlobals() {
    setState(() {
      _future = _initGlobals();
    });
  }

  _initGlobals() async {
    prefs = await SharedPreferences.getInstance();
    updateThemeMode(); // Leave EMPTY to get from SharedPreferences

    // UPDATES STATE ONCE EVERYTHING IS READY
    setState(() {});
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _future.asStream(),
        builder: (context, snapshot) {
          return widget.themeDataWidgetBuilder(this.context);
        }
    );
  }

  // THEME MODE STARTS
  ThemeMode _themeMode;

  ThemeMode getThemeMode() {
    return _themeMode;
  }

  List<bool> getThemeModeBoolList() {
    List<bool> result = [];
    for (int i = 0; i < 3; i++) {
      result.add((prefs.getInt("ThemeMode") ?? ThemeDataWrapper.getThemeOption(ThemeOption.System)) == i);
    }
    return result;
  }

  updateThemeMode({int mode}) {
    if (mode == null) {
      var mode = prefs.getInt("ThemeMode");
      loadThemeMode(mode);
    } else {
      prefs.setInt("ThemeMode", mode);
      loadThemeMode(mode);
    }
  }

  /// Loads saved theme mode
  /// 0 = Dark Mode
  /// 1 = Light Mode
  /// 2 = System (DEFAULT)
  void loadThemeMode(int mode) {
    setState(() {
      switch (mode ?? 0) {
        case _TO_SYS:
          _themeMode = ThemeMode.system;
          break;
        case _TO_DARK:
          _themeMode = ThemeMode.dark;
          break;
        case _TO_LIGHT:
          _themeMode = ThemeMode.light;
          break;
        default:
          _themeMode = ThemeMode.system;
          break;
      }
    });
  }
// THEME MODE ENDS
}
