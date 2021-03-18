import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:heretaunga/components/keys.dart';
import 'package:heretaunga/tools/API/api.dart';
import 'package:heretaunga/tools/CheckIsConnected.dart';
import 'package:heretaunga/tools/constructors/notices.dart';
import 'package:heretaunga/tools/constructors/periods.dart';
import 'package:heretaunga/tools/constructors/results.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sortedmap/sortedmap.dart';
import 'package:xml/xml.dart';

/// INDEX
/// [getGlobalData]
/// [getPeriodData]
/// [getTimetableData]
/// [getCalendarData]
/// [getNoticesData]
/// [getResultsData]

int weekInMillis = 1209600000;

/// GlobalData OFFLINE ENABLED
Future<SortedMap<int, Day>> getGlobalData({bool forceSync}) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  XmlDocument globals;

  if (prefs.getInt("GlobalOfflineData") != null && forceSync == null) {
    await checkForRefresh(
      saveInMillis: prefs.getInt("GlobalOfflineData"),
      offlineOutcome: () async {
        globals = API().makeReturnable(await getFileContents("GlobalData"));
      },
      onlineOutcome: () async {
        globals = await API().getGlobals();
        addToFile("GlobalData", globals);
        prefs.setInt(
            "GlobalOfflineData", DateTime.now().millisecondsSinceEpoch);
      },
    );
  } else {
    globals = await API().getGlobals();
    addToFile("GlobalData", globals);
    prefs.setInt("GlobalOfflineData", DateTime.now().millisecondsSinceEpoch);
  }

  SortedMap<int, Day> result = new SortedMap(Ordering.byKey());
  for (XmlNode node in globals
      .getElement("GlobalsResults")
      .getElement("StartTimes")
      .children) {
    Day d = Day(int.parse(node.getAttribute("index")));
    for (XmlNode time in node.findAllElements("PeriodTime")) {
      d.addPeriod(Period("${time.firstChild.toString()}",
          int.parse(time.getAttribute("index"))));
    }
    result[d.index] = d;
  }

  return await getPeriodData(result, globals);
}

Future<SortedMap<int, Day>> getPeriodData(
    SortedMap<int, Day> result, XmlDocument period) async {
  for (MapEntry<int, Day> day in result.entries) {
    // Days
    for (XmlNode node in period
        .getElement("GlobalsResults")
        .getElement("PeriodDefinitions")
        .findAllElements("PeriodDefinition")) {
      day.value.periods[int.parse(node.getAttribute("index")) - 1]
          .setPeriodName(node.getElement("PeriodName").firstChild.toString());
    }
  }
  return result;
}

/// TimetableData OFFLINE ENABLED
Future<SortedMap<int, TimetableWeek>> getTimetableData({bool forceSync}) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  XmlDocument timetable;
  if (prefs.getInt("TimetableOfflineData") != null && forceSync == null) {
    timetable = API().makeReturnable(await getFileContents("TimetableData"));
  } else {
    timetable = await API().getTimetable();
    addToFile("TimetableData", timetable);
    prefs.setInt("TimetableOfflineData", DateTime.now().millisecondsSinceEpoch);
  }
  SortedMap<int, TimetableWeek> result = new SortedMap(Ordering.byKey());
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

/// CalendarData OFFLINE ENABLED
Future<SortedMap<DateTime, CalendarDay>> getCalendarData({bool forceSync}) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  XmlDocument calendar;
  if (prefs.getInt("CalendarOfflineData") != null && forceSync == null) {
    calendar = API().makeReturnable(await getFileContents("CalendarData"));
  } else {
    calendar = await API().getCalendar();
    addToFile("CalendarData", calendar);
    prefs.setInt("CalendarOfflineData", DateTime.now().millisecondsSinceEpoch);
  }
  SortedMap<DateTime, CalendarDay> result = new SortedMap(Ordering.byKey());
  for (XmlNode node in calendar
      .getElement("CalendarResults")
      .getElement("Days")
      .findAllElements("Day")) {
    DateTime date =
        kamarDateFormat(node.getElement("Date").firstChild.toString());
    result[date] = new CalendarDay(
        date,
        node.getElement("Status").firstChild.toString(),
        node.getElement("WeekYear").firstChild.toString(),
        node.getElement("DayTT").firstChild.toString());
  }
  return result;
}

Future<List<Notice>> getNoticesData() async {
  // Process Notices
  return NoticeMethods().addAll(await API().getNotices());
}

/// StudentResultsData OFFLINE ENABLED
Future<SortedMap<String, Map<String, List<Result>>>> getResultsData() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  XmlDocument results;
  if (prefs.getInt("ResultsOfflineData") != null && !Keys.accessGlobalData.currentState.isConnected) {
    results = API().makeReturnable(await getFileContents("ResultsData"));
  } else {
    results = await API().getResults();
    addToFile("ResultsData", results);
    prefs.setInt("ResultsOfflineData", DateTime.now().millisecondsSinceEpoch);
  }
  return ResultMethods().addAll(results);
}

/// Reformats date to work with KAMAR date format (yyyy-MM-dd)
DateTime kamarDateFormat(String formattedString) {
  DateTime result = DateFormat("yyyy-MM-dd").parse(formattedString);
  return result;
}

/// Saves a copy of the students profile picture for offline use
Future<bool> saveProfilePicture() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String key = prefs.getString("Key");
  String studentID = prefs.getString("StudentID");

  try {
    var httpClient = new HttpClient();
    var request = await httpClient.getUrl(Uri.parse("https://portal.heretaunga.school.nz/api/img.php?Key=$key&Stuid=$studentID"));

    HttpClientResponse response = await request.close();
    if(response.statusCode == 200) {
      var bytes = await consolidateHttpClientResponseBytes(response);
      final path = await getApplicationDocumentsDirectory();
      final file = File('${path.path}/profile_${DateTime.now().year}.jpg');

      // Write the file.
      file.writeAsBytesSync(bytes);
      return true;
    } else {
      return false;
    }
  } catch(e) {
    return false;
  }
}

// Methods for offline use
Future<File> addToFile(String filename, XmlDocument contents) async {
  final path = await getApplicationDocumentsDirectory();
  final file = File('${path.path}/$filename.xml');

  // Write the file.
  return file.writeAsString(contents.toString());
}

Future<String> getFileContents(String filename) async {
  final path = await getApplicationDocumentsDirectory();
  final file = File("${path.path}/$filename.xml");

  return await file.readAsString();
}

/// Checks if saved data is due for refreshment
checkForRefresh(
    {int saveInMillis,
    Function() offlineOutcome,
    Function() onlineOutcome}) async {
  if (DateTime.now().millisecondsSinceEpoch - saveInMillis > weekInMillis) {
    if (await isConnected) {
      await onlineOutcome();
    } else {
      await offlineOutcome();
    }
  } else {
    await offlineOutcome();
  }
}
