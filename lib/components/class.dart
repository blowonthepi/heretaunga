import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:heretaunga/main.dart';
import 'package:heretaunga/screens/map.dart';
import 'package:heretaunga/tools/ColourGenerator.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class ClassComponent extends StatelessWidget {
  ClassComponent({
    @required this.subject,
    this.time,
    this.periodName,
    this.teacher,
    this.room,
    this.isDialog = false,
  });

  final String subject;
  String time;
  final String teacher;
  final String room;
  final String periodName;
  final bool isDialog;

  @override
  Widget build(BuildContext context) {
    Color bg;
    if (teacher != null) {
      bg = colourFromString(subject + teacher + room);
    } else {
      bg = colourFromString(subject);
    }
    Color text = bg.computeLuminance() > 0.5 ? Colors.black : Colors.white;
    Size size = MediaQuery.of(context).size;
    // Format Time to 12-hour
    if (time != null) {
      time = DateFormat.jm().format(DateFormat("hh:mm").parse(time));
    }
    bool expandTitle;
    if ("$time$teacher$room" == "nullnullnull") {
      expandTitle = true;
    } else {
      expandTitle = false;
    }
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Card(
        color: bg,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Flex(
            direction: isDialog ? Axis.vertical : Axis.horizontal,
            mainAxisAlignment: isDialog
                ? MainAxisAlignment.center
                : MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: isDialog
                    ? 0
                    : expandTitle
                        ? 1
                        : 4,
                child: Padding(
                  padding: isDialog ? EdgeInsets.all(24.0) : EdgeInsets.zero,
                  child: Column(
                    crossAxisAlignment: isDialog
                        ? CrossAxisAlignment.center
                        : CrossAxisAlignment.start,
                    children: [
                      AutoSizeText(
                        subject,
                        maxLines: 1,
                        maxFontSize: isDialog ? 40 : 22,
                        minFontSize: 14,
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: text,
                        ),
                      ),
                      periodName != null
                          ? AutoSizeText(
                              periodName.toUpperCase(),
                              maxLines: 1,
                              maxFontSize: isDialog ? 21 : 14,
                              minFontSize: 12,
                              style: TextStyle(
                                  fontSize: 21,
                                  color: text,
                                  letterSpacing: 1.2),
                            )
                          : Container(),
                    ],
                  ),
                ),
              ),
              !expandTitle
                  ? Expanded(
                      flex: isDialog ? 0 : 6,
                      child: Padding(
                        padding:
                            isDialog ? EdgeInsets.all(24.0) : EdgeInsets.zero,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            infoWidgets(
                                size, Icons.access_time_rounded, time, text),
                            infoWidgets(size, Icons.person_outline_rounded,
                                teacher, text),
                            infoWidgets(
                                size, Icons.location_on_outlined, room, text,
                            //     onTap: () {
                            //       MyApp.homeState.currentState.updateMapQuery(
                            //       room.replaceAll(RegExp("[0-9]"), ""));
                            // }
                            ),
                          ],
                        ),
                      ),
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }

  Widget infoWidgets(Size size, IconData icon, String title, Color color,
      {Function onTap}) {
    bool canTap = onTap != null;
    if (title != null) {
      return Expanded(
        flex: 3,
        child: GestureDetector(
          behavior:
              canTap ? HitTestBehavior.opaque : HitTestBehavior.translucent,
          onTap: canTap != null ? onTap : () {},
          child: Column(
            children: [
              Icon(
                icon,
                color: color,
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: AutoSizeText(
                  title,
                  maxLines: 1,
                  minFontSize: 10,
                  style: TextStyle(
                    fontSize: 14,
                    color: color,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return Expanded(flex: 3, child: Container());
    }
  }
}
