import 'dart:async';

import 'package:cron/cron.dart';
import 'package:flutter/material.dart';
import 'package:heretaunga/components/class.dart';
import 'package:heretaunga/tools/API/api_handler.dart';
import 'package:heretaunga/tools/constructors/periods.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sortedmap/sortedmap.dart';
import 'package:table_calendar/table_calendar.dart';

class Timetable extends StatefulWidget {
  @override
  _TimetableState createState() => _TimetableState();
}

class _TimetableState extends State<Timetable>
    with SingleTickerProviderStateMixin {
  SharedPreferences prefs;
  Future _today;
  SortedMap<int, Day> days = new SortedMap(Ordering.byKey());
  SortedMap<DateTime, CalendarDay> calendar = new SortedMap(Ordering.byKey());
  SortedMap<int, TimetableWeek> timetable = new SortedMap(Ordering.byKey());

  // Cron Job
  final cron = Cron();

  // Table Calendar
  Map<DateTime, List<ReadableCalendarCapsule>> _events = new Map();
  List _selectedEvents;
  AnimationController _animationController;
  CalendarController _calendarController;
  final _selectedDay = DateFormat("yyyy-MM-dd 00:00:00.000")
      .parse(DateFormat("yyyy-MM-dd 00:00:00.000").format(DateTime.now()));

  @override
  void initState() {
    _today = initTimetable();
    super.initState();
  }

  initTimetable() async {
    try {
      days = await getGlobalData();
      calendar = await getCalendarData();
      timetable = await getTimetableData();

      for (MapEntry<DateTime, CalendarDay> entry in calendar.entries) {
        if (!entry.value.status.contains("[Closed]") && entry.value.week > 0) {
          List<ReadableCalendarCapsule> eventsForNow = new List();
          List<TimetablePeriod> ttPeriods = timetable[entry.value.week]
              .days[entry.value.timetableDay - 1]
              .periods;

          for (int i = 0;
              i < days[entry.value.timetableDay].periods.length;
              i++) {
            eventsForNow.add(ReadableCalendarCapsule(
                ttPeriod: ttPeriods[i],
                period: days[entry.value.timetableDay].periods[i]));
          }
          _events[entry.value.date] = eventsForNow;
        } else {
          _events[entry.value.date] = [
            ReadableCalendarCapsule(
              message: entry.value.status
                  .toString()
                  .replaceAll("[", "")
                  .replaceAll("]", ""),
              isOpen: false,
            )
          ];
        }
      }
      _selectedEvents = _events[_selectedDay] ?? [];
      _calendarController = CalendarController();

      _animationController = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 400),
      );

      _animationController.forward();
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  void dispose() {
    if (_animationController != null) {
      _animationController.dispose();
    }
    if (_calendarController != null) {
      _calendarController.dispose();
    }
    super.dispose();
  }

  void _onDaySelected(DateTime day, List events, List holidays) {
    //print('CALLBACK: _onDaySelected');
    _calendarController.setCalendarFormat(CalendarFormat.week);
    setState(() {
      _selectedEvents = events.isNotEmpty
          ? events
          : [
              ReadableCalendarCapsule(
                message: "No Timetable for this day",
                isOpen: false,
              )
            ];
    });
  }

  void _onVisibleDaysChanged(
      DateTime first, DateTime last, CalendarFormat format) {
    //print('CALLBACK: _onVisibleDaysChanged');
  }

  void _onCalendarCreated(
      DateTime first, DateTime last, CalendarFormat format) {
    //print('CALLBACK: _onCalendarCreated');
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _today,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.data == false) {
          return Center(
            child: Text("Oops! Something went wrong.\nERR: L1-T2"),
          );
        }

        return Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            TableCalendar(
              calendarController: _calendarController,
              events: _events,
              startingDayOfWeek: StartingDayOfWeek.monday,
              calendarStyle: CalendarStyle(
                selectedColor: Theme.of(context).primaryColor,
                todayColor: Theme.of(context).primaryColorDark,
                markersColor: Colors.grey,
                outsideDaysVisible: false,
              ),
              availableGestures: AvailableGestures.all,
              availableCalendarFormats: const {
                CalendarFormat.week: 'Week View',
                CalendarFormat.month: 'Month View',
              },
              initialCalendarFormat: CalendarFormat.week,
              headerStyle: HeaderStyle(
                formatButtonTextStyle:
                    TextStyle().copyWith(color: Colors.white, fontSize: 15.0),
                formatButtonDecoration: BoxDecoration(
                  color: Colors.deepOrange[400],
                  borderRadius: BorderRadius.circular(16.0),
                ),
              ),
              onDaySelected: _onDaySelected,
              onVisibleDaysChanged: _onVisibleDaysChanged,
              onCalendarCreated: _onCalendarCreated,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _selectedEvents.length,
                itemBuilder: (context, index) {
                  if (_selectedEvents[index].isOpen) {
                    return returnPeriodWidget(_selectedEvents[index].ttPeriod,
                        _selectedEvents[index].period);
                  } else {
                    bool isChristmas = false;
                    if (_selectedEvents[index].message.contains("Christmas")) {
                      isChristmas = true;
                    }
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        color: isChristmas
                            ? Colors.red
                            : Theme.of(context).accentColor,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CircleAvatar(
                                backgroundColor: isChristmas
                                    ? Colors.red[800]
                                    : Theme.of(context).primaryColorDark,
                                radius: 50,
                                child: isChristmas
                                    ? Image.asset("assets/reindeer.png")
                                    : Icon(
                                        Icons.warning_amber_rounded,
                                        size: 50,
                                        color: Colors.black,
                                      ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                _selectedEvents[index].message,
                                style: TextStyle(
                                  color:
                                      isChristmas ? Colors.white : Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        );
      },
    );
  }

  returnPeriodWidget(TimetablePeriod ttPeriod, Period period) {
    if (period.periodTime != "null") {
      if (ttPeriod.subject == null) {
        return ClassComponent(
          subject: period.periodName,
          time: period.periodTime,
        );
      } else {
        double height = MediaQuery.of(context).size.height;
        return GestureDetector(
          onTap: () {
            showDialog(
                context: context,
                builder: (context) {
                  return Dialog(
                    backgroundColor: Colors.transparent,
                    insetPadding: EdgeInsets.only(
                      left: 24,
                      right: 24,
                      top: height / 4,
                      bottom: height / 4,
                    ),
                    child: ClassComponent(
                      subject: ttPeriod.subject,
                      time: period.periodTime,
                      periodName: period.periodName,
                      teacher: ttPeriod.teacher,
                      room: ttPeriod.room,
                      isDialog: true,
                    ),
                  );
                });
          },
          child: ClassComponent(
            subject: ttPeriod.subject,
            time: period.periodTime,
            periodName: period.periodName,
            teacher: ttPeriod.teacher,
            room: ttPeriod.room,
          ),
        );
      }
    } else {
      return Container();
    }
  }
}
