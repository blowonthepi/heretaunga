import 'package:flutter/material.dart';
import 'package:heretaunga/base.dart';
import 'package:heretaunga/tools/GlobalDataWrapper/GlobalDataWrapper.dart';
import 'package:heretaunga/tools/GlobalDataWrapper/ThemeDataWrapper.dart';

class Keys {
  static final accessGlobalData = new GlobalKey<GlobalDataWrapperState>();
  static final accessThemeData = new GlobalKey<ThemeDataWrapperState>();
  static final homeState = new GlobalKey<MyHomePageState>();
}