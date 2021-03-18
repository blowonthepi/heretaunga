import 'package:flutter/material.dart';

class PageInfo {
  PageInfo(this.name, this.englishIdentifier, this.page, this.selectedIcon, this.unselectedIcon);

  String name;
  final String englishIdentifier;
  final Widget page;
  final IconData unselectedIcon, selectedIcon;

  set updateName(String n) {
    this.name = n;
  }

  @override
  String toString() {
    return this.name;
  }
}