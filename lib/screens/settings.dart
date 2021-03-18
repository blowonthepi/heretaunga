import 'package:flutter/material.dart';
import 'package:heretaunga/components/Settings/LanguageChoice.dart';
import 'package:heretaunga/components/Settings/OfflineModeNotice.dart';
import 'package:heretaunga/components/Settings/StudentProfile.dart';
import 'package:heretaunga/components/Settings/ThemeModeSelector.dart';
import 'package:heretaunga/components/keys.dart';
import 'package:heretaunga/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Settings extends StatefulWidget {
  final bool isConnected;

  Settings({@required this.isConnected});

  static final TextStyle headingStyle = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 20,
  );

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings>
    with AutomaticKeepAliveClientMixin {
  SharedPreferences prefs;
  ImageProvider profileImage =
      Keys.accessGlobalData.currentState.getSchoolPhoto();

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        iconTheme: Theme.of(context).appBarTheme.iconTheme,
        title: Text(
          Keys.accessGlobalData.currentState.getLanguage()['settings'],
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          physics: ClampingScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              StudentProfile(
                context: context,
                profileImage: profileImage,
                onChanged: () {
                  setState(() {});
                }
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Divider(
                  color: Theme.of(context).iconTheme.color,
                ),
              ),
              OfflineModeNotice(widget.isConnected),
              LanguageChoice(onChanged: (value) {
                setState(() {
                  Keys.accessGlobalData.currentState.setLanguage(value);
                });
              }),
              ThemeModeSelector(),
            ],
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
