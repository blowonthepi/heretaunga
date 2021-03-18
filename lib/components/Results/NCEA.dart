import 'package:flutter/material.dart';

class NCEA extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 10,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text("NCEA Item #${index+1}"),
        );
      },
    );
  }
}
