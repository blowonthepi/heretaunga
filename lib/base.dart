import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:heretaunga/components/Main/CustomAppBar.dart';
import 'package:heretaunga/components/keys.dart';
import 'package:heretaunga/screens/results.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:heretaunga/screens/map.dart';
import 'package:heretaunga/screens/notices.dart';
import 'package:heretaunga/screens/timetable.dart';
import 'package:heretaunga/screens/today.dart';
import 'package:heretaunga/tools/CheckIsConnected.dart';
import 'package:heretaunga/tools/constructors/page.dart';
import 'package:heretaunga/components/Main/SplashScreen.dart';

class MyHomePage extends StatefulWidget {

  @override
  MyHomePageState createState() => MyHomePageState();

  @override
  Key get key => Keys.homeState;
}

class MyHomePageState extends State<MyHomePage> {
  Future _appData;
  int _currentIndex = 0;
  bool isLoading = true;

  StreamSubscription _connectivitySubscription;
  bool isNetworkConnected = false;

  SharedPreferences prefs;
  Map<String, String> language;

  @override
  void initState() {
    super.initState();
    _appData = loadApplicationData();
    _connectivitySubscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      checkInternet();
    });
  }

  Future<bool> loadApplicationData() async {
    isNetworkConnected = await isConnected;
    prefs = await SharedPreferences.getInstance();
    if(prefs.getBool("isLoggedIn") ?? false) {
      language = Keys.accessGlobalData.currentState.getLanguage();
      loadAppScreens(isNetworkConnected);
      return true;
    } else {
      Navigator.of(context).pushReplacementNamed("/login");
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _appData,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return SplashScreen();
        } else if (snapshot.data == false) {
          return Container(color: Colors.white,);
        }

        // Update current tab if [_currentIndex] is out of range
        checkTabInRange();

        return Scaffold(
          appBar: CustomAppBar(
            pageTitle: _appScreens[_currentIndex].name,
            isConnected: isNetworkConnected,
            prefs: prefs,
            profileImage:
            Keys.accessGlobalData.currentState.getProfilePicture(),
          ),
          body: IndexedStack(
            index: _currentIndex,
            children: [for (PageInfo w in _appScreens) w.page],
          ),
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            onTap: moveToTab,
            currentIndex: _currentIndex,
            items: [
              for (PageInfo p in _appScreens)
                BottomNavigationBarItem(
                  label: p.name,
                  icon: Icon(p.unselectedIcon),
                  activeIcon: Icon(p.selectedIcon),
                ),
            ],
          ),
        );
      },
    );
  }

  // Prepare app screens
  List<PageInfo> _appScreens;

  loadAppScreens(bool connected) {
    _appScreens = [
      PageInfo(language['today'], "today", Today(), Icons.ad_units,
          Icons.ad_units_outlined),
      PageInfo(language['timetable'], "timetable", Timetable(),
          Icons.calendar_view_day, Icons.calendar_view_day_outlined),
      PageInfo(language['notices'], "notices", Notices(), Icons.inbox,
          Icons.inbox_outlined),
      PageInfo(language['results'], "results", ResultsScreen(),
          Icons.insert_chart, Icons.insert_chart_outlined),
      PageInfo(
          language['map'], "map", MapScreen(), Icons.map, Icons.map_outlined),
    ];
  }

  // SUPPORT METHODS
  @override
  void didUpdateWidget(covariant MyHomePage oldWidget) {
    super.didUpdateWidget(oldWidget);
    reloadAppScreenNames();
  }

  // Reload names of app screens when language updates
  reloadAppScreenNames() {
    if(_appScreens != null) {
      language = Keys.accessGlobalData.currentState.getLanguage();
      for (int i = 0; i < _appScreens.length; i++) {
        if (_appScreens[i].englishIdentifier != null) {
          _appScreens[i].updateName = language[_appScreens[i].englishIdentifier];
        }
      }
      setState(() {});
    }
  }

  checkInternet() async {
    bool connected = await isConnected;
    setState(() {
      isNetworkConnected = connected;
    });
    _appData = loadApplicationData();
  }

  void checkTabInRange() {
    if (_currentIndex > _appScreens.length - 1) moveToTab(0);
  }

  /// Updates state to latest tab choice
  moveToTab(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  updateMapQuery(String q) {
    setState(() {
      _appScreens.removeAt(3);
      _appScreens.insert(
          3,
          PageInfo(
              language['map'],
              "map",
              MapScreen(
                query: q,
              ),
              Icons.map,
              Icons.map_outlined));
    });
    moveToTab(3);
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }
}