import 'package:flutter/material.dart';
import 'package:heretaunga/components/Results/AssignmentResults.dart';
import 'package:heretaunga/components/Results/NCEA.dart';
import 'package:heretaunga/tools/API/api_handler.dart';

class ResultsScreen extends StatefulWidget {
  @override
  _ResultsScreenState createState() => _ResultsScreenState();

  Widget tab(String title, Widget icon) {
    return Tab(
      child: Align(
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon != null
                ? Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: icon,
                  )
                : Container(),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text(
                title,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ResultsScreenState extends State<ResultsScreen>
    with AutomaticKeepAliveClientMixin {
  var results;
  Future _appData;

  @override
  void initState() {
    _appData = getAppData();
    super.initState();
  }

  Future<bool> getAppData() async {
    results = await getResultsData();
    if (results.length > 0) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    Size size = MediaQuery.of(context).size;
    return FutureBuilder(
      future: _appData,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.data == false) {
          return Center(
            child: Text("Oops! Something went wrong."),
          );
        }

        return SizedBox(
          width: size.width,
          height: size.height,
          child: DefaultTabController(
            length: 2,
            initialIndex: 0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  color: Colors.black,
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 8.0,
                      left: 8.0,
                      right: 8.0,
                    ),
                    child: Theme(
                      data: Theme.of(context).copyWith(
                        highlightColor: Colors.transparent,
                        splashColor: Colors.transparent,
                      ),
                      child: TabBar(
                        tabs: [
                          ResultsScreen().tab("Grades".toUpperCase(),
                              Icon(Icons.assignment_outlined)),
                          ResultsScreen().tab(
                            "NCEA",
                            Image.asset(
                              "assets/icons/nzqa_white.png",
                              scale: 5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    physics: NeverScrollableScrollPhysics(),
                    children: [
                      AssignmentResults(
                        results: results,
                      ),
                      NCEA(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
