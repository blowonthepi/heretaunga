import 'dart:async';

import 'package:cron/cron.dart';
import 'package:flutter/material.dart';
import 'package:heretaunga/components/Today/NothingToSee.dart';
import 'package:heretaunga/components/class.dart';
import 'package:heretaunga/tools/API/api_handler.dart';
import 'package:heretaunga/tools/constructors/periods.dart';
import 'package:intl/intl.dart';
import 'package:sortedmap/sortedmap.dart';

class UpNext extends StatefulWidget {
  @override
  _UpNextState createState() => _UpNextState();
}

// ignore: must_be_immutable
class _UpNextState extends State<UpNext> {
  SortedMap<int, Day> days = new SortedMap(Ordering.byKey());
  SortedMap<DateTime, CalendarDay> calendar = new SortedMap(Ordering.byKey());
  SortedMap<int, TimetableWeek> timetable = new SortedMap(Ordering.byKey());
  bool isLoading = false;
  var data;

  // Cron Job
  Timer timer;

  @override
  void initState() {
    isLoading = true;
    populateData().then((value) {
      data = perform();
      setState(() {
        isLoading = false;
      });
    });

    timer = Timer.periodic(Duration(minutes: 1), (Timer t) => setState(() {}));
    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(
        child: LinearProgressIndicator(),
      );
    }
    if (data['error'] != null) return data['error'];

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          provideDisplay(
            checker:
                data['todayPeriods'][data['periodNow'].index - 1].periodName !=
                    "null",
            positive: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    data['periodPhrase'].toUpperCase(),
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 21,
                    ),
                  ),
                ),
                returnUpNext(data['ttPeriodNow'], data['periodNow']),
                provideDisplay(
                  checker: data['todayPeriods'][data['periodNow'].index]
                          .periodName !=
                      "null",
                  positive: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Later".toUpperCase(),
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontSize: 21,
                          ),
                        ),
                      ),
                      provideDisplay(
                        checker: data['todayPeriods'][data['periodNow'].index]
                                .periodTime !=
                            "null",
                        positive: returnUpNext(
                            timetable[data['today'].week]
                                .days[data['today'].timetableDay - 1]
                                .periods[data['periodNow'].index],
                            data['todayPeriods'][data['periodNow'].index]),
                        negative: Container(),
                      ),
                    ],
                  ),
                  negative: Container(),
                ),
              ],
            ),
            negative: Container(child: Text("Pō marie")),
          ),
        ],
      ),
    );
  }

  /// Does boolean check, mostly to make code in build method prettier
  provideDisplay({bool checker, Widget positive, Widget negative}) =>
      checker ? positive : negative;

  /// Returns the next classes
  Widget returnUpNext(TimetablePeriod ttPeriod, Period period) {
    if (period.periodTime != "null") {
      if (ttPeriod.subject == null) {
        return ClassComponent(
          subject: period.periodName,
          time: period.periodTime,
        );
      } else {
        return ClassComponent(
          subject: ttPeriod.subject,
          time: period.periodTime,
          periodName: period.periodName,
          teacher: ttPeriod.teacher,
          room: ttPeriod.room,
        );
      }
    } else {
      return Container();
    }
  }

  /// Makes necessary API calls
  populateData() async {
    days = await getGlobalData();
    calendar = await getCalendarData();
    timetable = await getTimetableData();
    return true;
  }

  /// Performs logic to determine which 1-2 classes are shown
  perform() {
    CalendarDay today = calendar[kamarDateFormat(DateTime.now().toString())];

    try {
      // TodayPeriods and ...PeriodTimes hold info about
      // the periods on the current day
      List<Period> todayPeriods = days[today.timetableDay].periods;
      List<DateTime> todayPeriodTimes = [];
      for (Period p in todayPeriods) {
        if (p.periodTime != "null") {
          todayPeriodTimes.add(DateFormat("HH:mm").parse(p.periodTime));
        }
      }

      // Find time now
      final now =
          DateFormat("HH:mm").parse(DateFormat("HH:mm").format(DateTime.now()));
      // Find the closest period to now
      var closestToNow = todayPeriodTimes.reduce(
          (a, b) => a.difference(now).abs() < b.difference(now).abs() ? a : b);
      // Adjust if time is the last spell
      if (now.difference(closestToNow) >= Duration(hours: 1)) {
        closestToNow = now;
      }

      // Phrase to appear above next class
      String periodPhrase =
          closestToNow.millisecondsSinceEpoch < now.millisecondsSinceEpoch
              ? "On Now"
              : "Up Next";
      TimetablePeriod ttPeriodNow;
      Period periodNow;

      for (Period p in todayPeriods) {
        if (p.periodTime != "null") {
          if (DateFormat("HH:mm").parse(p.periodTime).compareTo(closestToNow) ==
              0) {
            periodNow = p;
          }
        }
      }

      try {
        ttPeriodNow = timetable[today.week]
            .days[today.timetableDay - 1]
            .periods[periodNow.index - 1];
        return {
          "error": null,
          "ttPeriodNow": ttPeriodNow,
          "periodNow": periodNow,
          "periodPhrase": periodPhrase,
          "todayPeriods": todayPeriods,
          "today": today,
        };
      } catch (e) {
        return {
          "error": NothingToSee(),
        };
      }
    } catch (e) {
      return {
        "error": NothingToSee(),
      };
    }
  }
}
