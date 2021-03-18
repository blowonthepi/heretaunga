import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heretaunga/components/Today/MoveOnButton.dart';
import 'package:heretaunga/components/Today/UpNext.dart';

class Today extends StatefulWidget {
  @override
  _TodayState createState() => _TodayState();
}

class _TodayState extends State<Today> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: ClampingScrollPhysics(),
      children: [
        UpNext(),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.fiber_new,
                        size: 75,
                      ),
                      Text(
                        "Features".toUpperCase(),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                          fontFamily: GoogleFonts.robotoMono().fontFamily,
                        ),
                      ),
                    ],
                  ),
                  GridView(
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisExtent: 125,
                    ),
                    children: [
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.map_outlined,
                              size: 40,
                            ),
                          ),
                          MoveOnButton(
                            label: "Go to Map",
                            tab: 4,
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.poll_outlined,
                              size: 40,
                            ),
                          ),
                          MoveOnButton(
                            label: "Go to Results",
                            tab: 3,
                          ),
                        ],
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.offline_bolt_outlined,
                              size: 28,
                            ),
                          ),
                          Text(
                            "Offline Mode".toUpperCase(),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                              fontFamily: GoogleFonts.robotoSlab().fontFamily,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        "Load pages faster after first use, and view timetable offline.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.new_releases_outlined,
                          size: 75,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Coming Soon".toUpperCase(),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                              fontFamily: GoogleFonts.robotoSlab().fontFamily,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    "This page has more cool \n'At a glance' content coming soon!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
