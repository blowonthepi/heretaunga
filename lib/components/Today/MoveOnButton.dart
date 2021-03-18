import 'package:flutter/material.dart';
import 'package:heretaunga/components/keys.dart';

class MoveOnButton extends StatelessWidget {
  final String label;
  final int tab;
  MoveOnButton({this.label, this.tab});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        Keys.homeState.currentState.moveToTab(tab);
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(label),
          Icon(Icons.arrow_forward_rounded)
        ],
      ),
    );
  }
}
