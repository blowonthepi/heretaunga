import 'package:flutter/material.dart';
import 'package:heretaunga/components/Today/MoveOnButton.dart';
import 'package:heretaunga/components/class.dart';

/// For UP NEXT when there are no periods to display
class NothingToSee extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Card(
          child: Column(
            children: [
              ClassComponent(
                subject: "There's nothing to see here!".toUpperCase(),
                periodName: "You have no upcoming classes",
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: MoveOnButton(
                  label: "Go to your Timetable",
                  tab: 1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
