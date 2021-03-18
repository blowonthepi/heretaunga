import 'package:flutter/material.dart';
import 'package:heretaunga/components/Results/ResultCard.dart';
import 'package:heretaunga/screens/results.dart';
import 'package:heretaunga/tools/constructors/results.dart';
import 'package:sortedmap/sortedmap.dart';

class AssignmentResults extends StatelessWidget {
  final SortedMap<String, Map<String, List<Result>>> results;

  AssignmentResults({@required this.results});

  @override
  Widget build(BuildContext context) {
    if (results.isEmpty) {
      return Center(
        child: Text(
          "There are currently no results.\nPlease try again if this is incorrect.",
          textAlign: TextAlign.center,
        ),
      );
    }
    return DefaultTabController(
      length: results.length,
      initialIndex: 0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              top: 8.0,
              left: 8.0,
              right: 8.0,
            ),
            child: Theme(
              data: Theme.of(context).copyWith(
                tabBarTheme: TabBarTheme(
                  indicator: UnderlineTabIndicator(
                    borderSide: BorderSide(
                        width: 5.0, color: Theme.of(context).accentColor),
                  ),
                ),
              ),
              child: TabBar(
                isScrollable: true,
                labelPadding: EdgeInsets.only(left: 4, right: 4),
                tabs: [
                  for (String ncea in results.keys)
                    ResultsScreen().tab(
                        ncea.contains("Level 0") ? "Pre NCEA (Junior)" : ncea,
                        null),
                ],
              ),
            ),
          ),
          Expanded(
            child: TabBarView(
              children: [
                for (Map<String, List<Result>> mapResults in results.values)
                  ListView(
                    children: [
                      for (MapEntry<String, List<Result>> result
                          in mapResults.entries)
                        ExpansionTile(
                          title: Text("${result.key}"),
                          children: [
                            for (Result resultObject in result.value)
                              ResultCard(
                                result: resultObject,
                              ),
                          ],
                        ),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
