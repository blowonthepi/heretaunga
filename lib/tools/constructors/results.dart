// TODO
import 'package:flutter/foundation.dart';
import 'package:sortedmap/sortedmap.dart';
import 'package:xml/xml.dart';

class Result {
  final String grade;
  final String title;
  final String subField;
  final String credits;
  final String creditsPassed;
  final String resultPublished;

  Result(
      {@required this.grade,
      @required this.title,
      @required this.subField,
      @required this.credits,
      @required this.creditsPassed,
      @required this.resultPublished});
}

class ResultMethods {
  SortedMap<String, Map<String, List<Result>>> addAll(XmlDocument doc) {
    SortedMap<String, Map<String, List<Result>>> results =
        new SortedMap(Ordering.byKey());
    for (XmlNode node in doc
        .getElement("StudentResultsResults")
        .getElement("ResultLevels")
        .children) {
      if (node.firstChild != null) {
        // Added level to Results Map
        results["Level ${node.getElement("NCEALevel").text}"] = new Map();
        for (XmlNode result in node.getElement("Results").children) {
          // Check if result has data
          if (result.getAttribute("index") != null) {
            // Check if list needs init
            String field = result.getElement("SubField").text.isEmpty
                ? "Uncategorised"
                : result.getElement("SubField").text;
            if (results["Level ${node.getElement("NCEALevel").text}"][field] ==
                null) {
              results["Level ${node.getElement("NCEALevel").text}"][field] = [];
            }

            // Fill out Result
            results["Level ${node.getElement("NCEALevel").text}"][field]
                .add(new Result(
              grade: result.getElement("Grade").text ?? "No Grade Entered",
              title: result.getElement("Title").text ?? "No Title Given",
              subField:
                  result.getElement("SubField").text ?? "No SubField Given",
              credits:
                  result.getElement("Credits").text ?? "No Credits Entered",
              creditsPassed: result.getElement("CreditsPassed").text ??
                  "No Credits Passed Entered",
              resultPublished: result.getElement("ResultPublished").text ??
                  "No Publish Date",
            ));
          }
        }
      }
    }
    return results;
  }
}
