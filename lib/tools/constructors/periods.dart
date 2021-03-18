import 'package:sortedmap/sortedmap.dart';
import 'package:xml/xml.dart';

class Day {
  Day(this.index);
  final int index;
  final List<Period> periods = [];

  addPeriod(Period period) => periods.add(period);

  @override
  String toString() {
    return "$index ${periods.length}";
  }
}

class Period {
  Period(this.periodTime, this.index);
  String periodName;
  final String periodTime;
  final int index;

  setPeriodName(String periodName) {
    this.periodName = periodName;
  }

  @override
  String toString() {
    return "$index = $periodName : $periodTime";
  }
}

class CalendarDay {
  DateTime _date;
  String _status;
  int _week;
  int _timetableDay;
  CalendarDay(DateTime date, String status, String week, String timetableDay) {
    this._date = date;
    this._status = status == "null" ? "" : status;
    this._week = week == "null" ? -1 : int.parse(week);
    this._timetableDay = timetableDay == "null" ? -1 : int.parse(timetableDay);
  }

  DateTime get date {
    return _date;
  }
  String get status {
    return _status;
  }
  int get week {
    return _week;
  }
  int get timetableDay {
    return _timetableDay;
  }

  @override
  String toString() {
    return "$date | $week";
  }
}


class TimetableWeek {
  TimetableWeek(this.week);
  final int week;
  final List<TimetableDay> days = new List();

  addDay(TimetableDay day) {
    days.add(day);
  }

  @override
  String toString() {
    return "Week $week: ${days.length}";
  }
}

class TimetableDay {
  TimetableDay(this.day);
  final int day;
  final List<TimetablePeriod> periods = new List();

  addPeriod(TimetablePeriod period) {
    periods.add(period);
  }

  @override
  String toString() {
    return "Day $day";
  }
}

class TimetablePeriod {
  TimetablePeriod(this.subject, this.teacher, this.room);
  TimetablePeriod.empty() {
    isEmpty = true;
  }
  String subject;
  String teacher;
  String room;
  bool isEmpty;

  @override
  String toString() {
    return "Period: $subject | $teacher | $room";
  }
}

class ReadableCalendarCapsule {
  ReadableCalendarCapsule({this.ttPeriod, this.period, this.message, this.isOpen = true});
  final TimetablePeriod ttPeriod;
  final Period period;
  final String message;
  final bool isOpen;
}

class TTMethods {
  SortedMap<int, TimetableWeek> result = new SortedMap(Ordering.byKey());
  SortedMap<int, TimetableWeek> addAllWeeks(XmlDocument timetable) {
    for (XmlNode node in timetable
        .getElement("StudentTimetableResults")
        .getElement("Students")
        .getElement("Student")
        .getElement("TimetableData")
        .children) {
      TimetableWeek w = new TimetableWeek(
          int.parse(node.toString().split("<W")[1].split(">")[0]));
      for (XmlNode day in node.children) {
        TimetableDay ttDay = new TimetableDay(
            int.parse(day.toString().split("<D")[1].split(">")[0]));
        List<String> periods = day.text.split("|");
        for (String period in periods) {
          TimetablePeriod ttPeriod;
          if (period != "") {
            if (period.length > 3) {
              List<String> info = period.split("-");
              ttPeriod = new TimetablePeriod(info[2], info[3], info[4]);
            }
          } else {
            ttPeriod = new TimetablePeriod.empty();
          }
          if (ttPeriod != null) {
            ttDay.addPeriod(ttPeriod);
          }
        }
        w.addDay(ttDay);
      }
      result[w.week] = w;
    }
    return result;
  }
}