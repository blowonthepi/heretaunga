import 'package:flutter/material.dart';

/// Notice Widget and Dialog explaining Offline Mode
class OfflineModeNotice extends StatelessWidget {
  final bool isConnected;
  OfflineModeNotice(this.isConnected);

  @override
  Widget build(BuildContext context) {
    if(isConnected) {
      // Not needed if Internet is accessible.
      return Container();
    }
    return InkWell(
      onTap: () {
        Navigator.of(context).push(PageRouteBuilder(
            opaque: false,
            pageBuilder: (BuildContext context, _, __) {
              TextStyle _tS = TextStyle(
                fontSize: 20,
              );
              return Scaffold(
                appBar: AppBar(
                  elevation: 0,
                  automaticallyImplyLeading: true,
                  title: Row(
                    children: [
                      Icon(
                        Icons.offline_bolt,
                        size: 30,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Offline Mode"),
                      ),
                    ],
                  ),
                ),
                body: ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "You may have noticed some features are missing, this is because they only work online.",
                            style: _tS,
                          ),
                          Text(
                            "Connect to the internet to see the Notices and Map again.\n",
                            style: _tS.copyWith(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "While you are online an automatic save is made of your Timetable and Results for offline viewing.\n",
                            style: _tS,
                          ),
                          Text(
                            "This means if something has been updated it may not be visible within the app for up to TWO WEEKS.\n",
                            style: _tS,
                          ),
                          Text(
                            "If you think some data is outdated, then you can force an update through the settings menu when you're next online.\n",
                            style: _tS,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }));
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
          child: ListTile(
            leading: Icon(
              Icons.offline_bolt,
              size: 35,
            ),
            title: Text("You are Offline"),
            subtitle: Text("Tap to learn more about Offline Mode."),
          ),
        ),
      ),
    );
  }
}
