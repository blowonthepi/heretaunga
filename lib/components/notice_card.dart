import 'package:auto_size_text/auto_size_text.dart';
import 'package:configurable_expansion_tile/configurable_expansion_tile.dart';
import 'package:flutter/material.dart';
import 'package:heretaunga/components/generic.dart';
import 'package:heretaunga/screens/notices.dart';
import 'package:heretaunga/tools/constructors/notices.dart';

class ExpansionCard extends StatefulWidget {
  ExpansionCard({this.notice});

  final Notice notice;

  @override
  State createState() => ExpansionCardState();
}

class ExpansionCardState extends State<ExpansionCard> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ConfigurableExpansionTile(
        onExpansionChanged: (expanded) {
          setState(() {
            isExpanded = expanded;
          });
        },
        key: ValueKey(widget.notice.subject + widget.notice.teacher),
        header: Padding(
          padding: const EdgeInsets.all(16.0),
          child: AutoSizeText(
            widget.notice.subject,
            maxLines: 1,
            maxFontSize: 30,
            minFontSize: 12,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryTextTheme.bodyText1.color,
            ),
          ),
        ),
        headerExpanded: GenericComponent(
          elevation: 0,
          isExpanded: true,
          title: Text(
            widget.notice.subject,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryTextTheme.bodyText1.color,
            ),
          ),
          children: [
            widget.notice.level,
            widget.notice.type,
            widget.notice.teacher,
          ],
          iconChildren: [
            Icons.notification_important_outlined,
            Icons.text_snippet_outlined,
            Icons.person_outline_rounded
          ],
        ),
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4.0, right: 4.0),
            child: SingleChildScrollView(
              child: Row(
                children: [
                  Notices().createState().customChip(
                      widget.notice.placeMeet, Icons.place_outlined),
                  Notices().createState().customChip(
                      widget.notice.dateMeet, Icons.date_range_rounded),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
                left: 16.0, right: 16.0, top: 8.0, bottom: 8.0),
            child: Text(
              widget.notice.body,
              textAlign: TextAlign.start,
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
