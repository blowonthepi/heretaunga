import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:heretaunga/components/keys.dart';
import 'package:heretaunga/tools/GlobalDataWrapper/Languages.dart';
import 'package:heretaunga/tools/API/api.dart';
import 'package:heretaunga/tools/CheckIsConnected.dart' as CheckConnected;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

typedef GlobalDataWidgetBuilder = Widget Function(BuildContext context);

class GlobalDataWrapper extends StatefulWidget {
  GlobalDataWrapper({ this.globalDataWidgetBuilder});
  final GlobalDataWidgetBuilder globalDataWidgetBuilder;

  @override
  GlobalDataWrapperState createState() => GlobalDataWrapperState();

  static GlobalDataWrapperState of(BuildContext context) {
    return context.findAncestorStateOfType<State<GlobalDataWrapper>>();
  }

  @override
  Key get key => Keys.accessGlobalData;
}

class GlobalDataWrapperState extends State<GlobalDataWrapper> {
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
    if (prefs.getBool("isLoggedIn") ?? false) {
      await initNetworkConnectionListener();
      String lang = prefs.getString("AppLang") ?? "english";
      _applyNewLang(lang);

      initSchoolPhoto();
      updateProfilePicture(prefs.getInt("avatar") ?? 0);
      loadStudentName();

      // UPDATES STATE ONCE EVERYTHING IS READY
      setState(() {});
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _future.asStream(),
      builder: (context, snapshot) {
        return widget.globalDataWidgetBuilder(this.context);
      }
    );
  }

  // INTERNET STARTS
  bool isConnected;
  initNetworkConnectionListener() async {
    bool conn = await CheckConnected.isConnected;
    setState(() {
      isConnected = conn;
    });
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      setState(() {
        isConnected = result != ConnectivityResult.none;
      });
    });
  }
  // INTERNET ENDS

  // LANGUAGES STARTS
  Map<String, String> _language = {};
  Map<String, String> availableLanguages = GDWLanguages().availableLangs;

  Map<String, String> getLanguage() {
    return _language;
  }

  String getActiveLanguage() {
    return prefs.getString("AppLang") ?? "english";
  }

  setLanguage(String lang) {
    prefs.setString("AppLang", lang);
    _applyNewLang(lang);
  }

  _applyNewLang(String lang) {
    setState(() {
      _language = GDWLanguages.langMap[lang];
    });
  }

  // LANGUAGES ENDS

  // PROFILE PICTURE STARTS
  ImageProvider _picture, _schoolPhoto;

  ImageProvider getProfilePicture() {
    return _picture;
  }

  ImageProvider getSchoolPhoto() {
    return _schoolPhoto;
  }

  initSchoolPhoto() {
    loadSchoolPhoto().then((value) {
      setState(() {
        _schoolPhoto = value;
      });
    });
  }

  Future<ImageProvider> loadSchoolPhoto() async {
    var file;
    final path = await getApplicationDocumentsDirectory();
    file = File('${path.path}/profile_${DateTime.now().year}.jpg');
    if (!file.existsSync()) {
      if (isConnected) {
        file = await API().getProfilePhoto();
      } else {
        file = AssetImage("assets/avatars/avatars_1.png");
      }
    } else {
      file = FileImage(file);
    }
    return file;
  }

  void updateProfilePicture(int avatar) {
    prefs.setInt("avatar", avatar);
    if (avatar == 0) {
      loadSchoolPhoto().then((value) {
        setState(() {
          _picture = value;
        });
      });
    } else {
      setState(() {
        _picture = AssetImage("assets/avatars/avatar_$avatar.png");
      });
    }
  }

  // PROFILE PICTURE ENDS

  // STUDENT NAME STARTS
  String _studentName;

  String getStudentName() {
    return _studentName;
  }

  void loadStudentName() {
    var name = prefs.getString("StudentName");
    if (name == null) {
      if (isConnected) {
        API().getProfile().then((studentName) {
          name =
          "${studentName.getElement("StudentDetailsResults").getElement("Students").getElement("Student").getElement("FirstName").text.toString()} ${studentName.getElement("StudentDetailsResults").getElement("Students").getElement("Student").getElement("LastName").text.toString()}";
          prefs.setString("StudentName", name);
          prefs.setInt("StudentNameUpdatedDate",
              DateTime.now().millisecondsSinceEpoch);
          setState(() {
            _studentName = name;
          });
        });
      } else {
        setState(() {
          _studentName = "";
        });
      }
    } else {
      setState(() {
        _studentName = name;
      });
    }
  }
  // STUDENT NAME ENDS
}
