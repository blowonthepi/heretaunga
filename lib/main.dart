import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heretaunga/base.dart';
import 'package:heretaunga/components/keys.dart';
import 'package:heretaunga/login.dart';
import 'package:heretaunga/tools/GlobalDataWrapper/GlobalDataWrapper.dart';
import 'package:heretaunga/tools/GlobalDataWrapper/ThemeDataWrapper.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
          [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp])
      .then((value) => runApp(MyApp()));
}

class MyApp extends StatelessWidget {
  final ThemeData _themeDataDark = ThemeData(
    fontFamily: GoogleFonts.poppins().fontFamily,
    primarySwatch: Colors.red,
    primaryColor: Color.fromRGBO(155, 0, 25, 1),
    primaryColorDark: Color.fromRGBO(235, 176, 57, 1),
    accentColor: Color.fromRGBO(255, 196, 77, 1),
    toggleableActiveColor: Color.fromRGBO(255, 196, 77, 1),
    brightness: Brightness.dark,
    backgroundColor: Colors.grey[800],
    primaryTextTheme: TextTheme(
        bodyText1: TextStyle(
      color: Colors.white,
    )),
    appBarTheme: AppBarTheme(
      color: Colors.black,
      titleTextStyle: TextStyle(
        color: Colors.white,
      ),
      iconTheme: IconThemeData(
        color: Colors.white,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        primary: Colors.white,
      ),
    ),
    tabBarTheme: TabBarTheme(
      labelColor: Colors.white,
      unselectedLabelColor: Colors.white,
      indicatorSize: TabBarIndicatorSize.label,
      indicator: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
        color: Color.fromRGBO(155, 0, 25, 1),
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.grey[850],
      unselectedLabelStyle: TextStyle(
        fontSize: 13,
      ),
      selectedLabelStyle: TextStyle(
        fontSize: 13,
      ),
      selectedItemColor: Color.fromRGBO(255, 196, 77, 1),
      unselectedItemColor: Colors.grey,
    ),
  );
  final ThemeData _themeDataLight = ThemeData(
    fontFamily: GoogleFonts.poppins().fontFamily,
    primarySwatch: Colors.red,
    primaryColor: Color.fromRGBO(155, 0, 25, 1),
    primaryColorDark: Color.fromRGBO(120, 0, 0, 1),
    accentColor: Color.fromRGBO(155, 0, 25, 1),
    toggleableActiveColor: Color.fromRGBO(155, 0, 25, 1),
    brightness: Brightness.light,
    backgroundColor: Colors.white,
    primaryTextTheme: TextTheme(
        bodyText1: TextStyle(
      color: Colors.black,
    )),
    appBarTheme: AppBarTheme(
      color: Colors.white,
      titleTextStyle: TextStyle(
        color: Colors.black,
      ),
      iconTheme: IconThemeData(
        color: Colors.black,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        primary: Colors.black,
      ),
    ),
    tabBarTheme: TabBarTheme(
      labelColor: Colors.white,
      unselectedLabelColor: Colors.white,
      indicatorSize: TabBarIndicatorSize.label,
      indicator: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
        color: Color.fromRGBO(155, 0, 25, 1),
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      unselectedLabelStyle: TextStyle(
        fontSize: 13,
        color: Colors.grey[800],
      ),
      selectedLabelStyle: TextStyle(
        fontSize: 13,
        color: Colors.black,
      ),
      selectedItemColor: Color.fromRGBO(155, 0, 25, 1),
      unselectedItemColor: Colors.grey,
    ),
  );

  @override
  Widget build(BuildContext context) {
    precacheImage(AssetImage("assets/images/pride.png"), context);
    return ThemeDataWrapper(
      themeDataWidgetBuilder: (context) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Heretaunga',
          theme: _themeDataLight,
          darkTheme: _themeDataDark,
          themeMode: Keys.accessThemeData.currentState.getThemeMode(),
          initialRoute: "/",
          routes: {
            "/": (context) => GlobalDataWrapper(
                  globalDataWidgetBuilder: (context) => new MyHomePage(),
                ),
            "/login": (context) => new Login(),
          },
        );
      },
    );
  }
}
