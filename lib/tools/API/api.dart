import 'dart:io';
import 'dart:convert' show utf8;

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xml/xml.dart';
import 'package:intl/intl.dart';
import 'api_handler.dart';

import 'package:flutter/material.dart' as mat;
import 'dart:core';

class API {
  String url = 'https://portal.heretaunga.school.nz/api/api.php';

  //String url = 'https://demo.school.kiwi/api/api.php';
  Map<String, String> headers = {
    "User-Agent": "Phoenix",
    "Origin": "file://",
    "X-Requested-With": "nz.co.KAMAR",
  };

  /// logon
  /// Returns the result of Logon
  /// from the KAMAR API and sets SharedPreferences
  ///
  Future logon(String username, String password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var response = await http.post(Uri.encodeFull(url),
        headers: headers,
        body: {
          "Command": "Logon",
          "Key": "vtku",
          "Username": username,
          "Password": password
        });

    XmlDocument xml = makeReturnable(response.body);
    // If success element exists continue
    if (xml.firstElementChild.getElement("Success") != null) {
      if (xml.firstElementChild.getElement("Key") != null) {
        prefs.setString("Key",
            xml.firstElementChild.getElement("Key").firstChild.toString());
        prefs.setString(
            "StudentID",
            xml.firstElementChild
                .getElement("CurrentStudent")
                .firstChild
                .toString());
        prefs.setBool("isLoggedIn", true);
        return "success";
      }
    } else {
      return xml.firstElementChild.getElement("Error").firstChild.toString();
    }
  }

  /// getGlobals
  /// Returns the result of GetGlobals
  /// from the KAMAR API:
  /// - PeriodDefinitions
  /// - StartTimes for each day of week
  ///
  Future getGlobals() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String key = prefs.getString("Key");
    var response = await http.post(Uri.encodeFull(url),
        headers: headers, body: {"Command": "GetGlobals", "Key": key});
    return makeReturnable(response.body);
  }

  /// getDetails
  /// Returns the result of GetStudentDetails
  /// from the KAMAR API:
  /// - Names
  /// - YearLevel
  /// - Parent info
  /// - NSN
  ///
  Future getDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String key = prefs.getString("Key");
    String studentId = prefs.getString("StudentID");
    var response = await http.post(Uri.encodeFull(url),
        headers: headers,
        body: {
          "Command": "GetStudentDetails",
          "Key": key,
          "StudentID": studentId
        });
    return makeReturnable(response.body);
  }

  /// getCalendar
  /// Returns the result of GetCalendar
  /// from the KAMAR API:
  /// - Days
  /// - Open status
  /// - Week #
  /// - Term #
  ///
  Future getCalendar() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String key = prefs.getString("Key");
    var date = DateTime.now();
    String formattedDate = DateFormat("yyyy").format(date);
    var response = await http.post(Uri.encodeFull(url),
        headers: headers,
        body: {
          "Command": "GetCalendar",
          "Key": key,
          "Year": "$formattedDate",
          "ShowAll": "YES"
        });

    return makeReturnable(response.body);
  }

  /// getCalendarEvents
  /// Returns the result of GetEvents
  /// from the KAMAR API:
  /// - Events
  /// - Who should care about the event
  ///
  Future getCalendarEvents(var dateStart, var dateEnd) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String key = prefs.getString("Key");
    var response =
        await http.post(Uri.encodeFull(url), headers: headers, body: {
      "Command": "GetEvents",
      "Key": key,
      "DateStart": "$dateStart",
      "DateEnd": "$dateEnd",
      "ShowAll": "YES"
    });

    return makeReturnable(response.body);
  }

  /// getTimetable
  /// Returns the result of GetStudentTimetable
  /// from the KAMAR API:
  /// - Lines
  /// - Classes, day by day
  ///
  Future getTimetable() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String key = prefs.getString("Key");
    String studentID = prefs.getString("StudentID");
    var date = DateTime.now();
    String formattedDate = DateFormat("yyyy").format(date);
    var response =
        await http.post(Uri.encodeFull(url), headers: headers, body: {
      "Command": "GetStudentTimetable",
      "Key": key,
      "StudentID": studentID,
      "Grid": "${formattedDate}TT"
    });
    return makeReturnable(response.body);
  }

  /// getNotices
  /// Returns the result of GetNotices
  /// from the KAMAR API:
  /// - Meeting and General Notices
  ///
  Future getNotices() async {
    var date = DateTime.now();
    String formattedDate = DateFormat("dd/M/yyyy").format(date);
    var response = await http.post(Uri.encodeFull(url),
        headers: headers,
        body: {"Command": "GetNotices", "Key": "vtku", "Date": formattedDate});
    return makeReturnable(utf8.decode(response.bodyBytes));
  }

  /// getNCEAResults
  /// Returns the result of GetStudentNCEASummary
  /// from the KAMAR API:
  /// - Credits achieved per year, shows all years
  /// - Credit total overall
  /// - UE/Numeracy/Literacy credits
  /// - Status of UE/Num/Lit achievement (YES/NO)
  ///
  Future getNCEAResults() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String key = prefs.getString("Key");
    String studentID = prefs.getString("studentID");
    var response = await http.post(Uri.encodeFull(url),
        headers: headers,
        body: {
          "Command": "GetStudentNCEASummary",
          "Key": key,
          "StudentID": studentID
        });

    return makeReturnable(response.body);
  }

  /// getResults
  /// Returns the result of GetStudentResults
  /// from the KAMAR API:
  /// - Local school results for Juniors
  /// - Individual Standards results for Seniors
  ///
  Future getResults() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String key = prefs.getString("Key");
    String studentID = prefs.getString("StudentID");
    var response = await http.post(Uri.encodeFull(url),
        headers: headers,
        body: {"Command": "GetStudentResults", "Key": key, "StudentID": studentID});
    return makeReturnable(response.body);
  }

  /// getProfile
  /// Returns the result of GetStudentDetails
  /// from the KAMAR API:
  /// - Information about the Student
  /// - Name
  /// - Doctor
  /// - Caregivers
  ///
  Future getProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String key = prefs.getString("Key");
    String studentID = prefs.getString("StudentID");
    var response = await http.post(Uri.encodeFull(url),
        headers: headers,
        body: {
          "Command": "GetStudentDetails",
          "Key": key,
          "StudentID": studentID
        });

    return makeReturnable(response.body);
  }

  /// getProfilePhoto
  /// Returns the Image widget for the students
  /// profile photo from img.php URL
  Future<ImageProvider> getProfilePhoto() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String key = prefs.getString("Key");
    String studentID = prefs.getString("StudentID");

    // Save profile picture
    return saveProfilePicture().then((value) async {
      if (value) {
        final path = await getApplicationDocumentsDirectory();
        final file = File('${path.path}/profile_${DateTime.now().year}.jpg');
        return FileImage(file);
      } else {
        return NetworkImage(
          "https://portal.heretaunga.school.nz/api/img.php?Key=$key&Stuid=$studentID",
        );
      }
    });
  }

  logout(mat.BuildContext context) {
    SharedPreferences.getInstance().then((value) {
      value.clear();
      getApplicationDocumentsDirectory()
          .then((path) {
            for(File f in path.listSync()) {
              f.deleteSync();
            }
      });
    });
    return true;
  }

  makeReturnable(var result) => XmlDocument.parse(result);
}
