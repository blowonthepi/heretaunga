import 'package:flutter/material.dart';
import 'package:heretaunga/tools/ColourGenerator.dart';
import 'package:heretaunga/tools/constructors/results.dart';
import 'package:intl/intl.dart';

class ResultCard extends StatelessWidget {
  final Result result;

  ResultCard({@required this.result});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width*0.95,
      child: Card(
        elevation: 0.0,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
            side: BorderSide(
              width: 0.5,
              color: Colors.grey,
            )),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      result.title,
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    decideGradeWidget(context),
                    decideCredits(),
                  ],
                ),
                Text(
                  "Updated: $dateFormatted",
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String get dateFormatted {
    DateFormat format = new DateFormat("dd/MM/yyyy");
    DateTime date = DateTime.parse(result.resultPublished);
    return format.format(date);
  }

  Widget decideGradeWidget(BuildContext context) {
    if (simplifyGrade().length > 15) {
      return MaterialButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text(result.title),
                content: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.3,
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(result.grade),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
        padding: EdgeInsets.all(1),
        child: Text("Tap to read Grade"),
      );
    } else {
      return Chip(
        label: Text(
          simplifyGrade(),
          style: TextStyle(
            color: contrastingTextColor(Theme.of(context).accentColor),
          ),
        ),
        labelPadding: EdgeInsets.all(4.0),
        padding: EdgeInsets.all(4.0),
        backgroundColor: Theme.of(context).accentColor,
      );
    }
  }

  Widget decideCredits() {
    if (result.credits.isEmpty) {
      return Container();
    } else {
      return Column(
        children: [
          Text("Available Credits: ${result.credits}"),
          Text("Achieved Credits: ${result.creditsPassed}"),
        ],
      );
    }
  }

  String simplifyGrade() {
    switch(result.grade.toLowerCase()) {
      case "achieved with excellence":
        return "Excellence";
      case "achieved with merit":
        return "Merit";
      default:
        return result.grade;
    }
  }
}
