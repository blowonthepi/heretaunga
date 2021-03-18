import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class OfflineChip extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Chip(
      backgroundColor: Colors.white,
      avatar: Icon(
        Icons.offline_bolt,
        size: 30,
        color: Colors.black,
      ),
      labelPadding: const EdgeInsets.all(2.0),
      label: AutoSizeText(
        "Offline",
        maxLines: 1,
        style: TextStyle(
          fontSize: 20,
          color: Colors.black,
        ),
      ),
    );
  }
}
