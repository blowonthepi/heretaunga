import 'package:xml/xml.dart';

class Notice {
  String _type;
  String _level;
  String _subject;
  String _body;
  String _teacher;
  String _placeMeet;
  String _dateMeet;
  String _timeMeet;

  Notice.general({String level, String subject, String body, String teacher}) {
    this._type = "General";
    this._level = level;
    this._subject = subject;
    this._body = body;
    this._teacher = teacher;
    this._placeMeet = null;
    this._dateMeet = null;
    this._timeMeet = null;
  }

  Notice.meeting({
    String level,
    String subject,
    String body,
    String teacher,
    String placeMeet,
    String dateMeet,
    String timeMeet}) {
    this._type = "Meeting";
    this._level = level;
    this._subject = subject;
    this._body = body;
    this._teacher = teacher;
    this._placeMeet = placeMeet;
    this._dateMeet = dateMeet;
    this._timeMeet = timeMeet;
  }

  String get level {
    return _level;
  }
  String get type {
    return _type;
  }
  String get subject {
    return _subject;
  }
  String get body {
    return _body;
  }
  String get teacher {
    return _teacher;
  }
  String get placeMeet {
    return _placeMeet;
  }
  String get dateMeet {
    return _dateMeet;
  }
  String get timeMeet {
    return _timeMeet;
  }
}

class NoticeMethods {
  List<Notice> addAll(XmlDocument notices) {
    List<Notice> result = [];
    result.addAll(_addAllMeeting(notices
        .getElement("NoticesResults")
        .getElement("MeetingNotices")
        .findAllElements("Meeting")));
    result.addAll(_addAllGeneral(notices
        .getElement("NoticesResults")
        .getElement("GeneralNotices")
        .findAllElements("General")));

    return result;
  }

  List<Notice> _addAllMeeting(Iterable<XmlElement> notices) {
    List<Notice> noticesList = [];
    for (XmlElement element in notices) {
      Notice notice = Notice.meeting(
        level: element.getElement("Level").text,
        subject: element.getElement("Subject").text,
        body: element.getElement("Body").text,
        teacher: element.getElement("Teacher").text,
        placeMeet: element.getElement("PlaceMeet").text,
        dateMeet: element.getElement("DateMeet").text,
        timeMeet: element.getElement("TimeMeet").text,
      );

      // Check if item exists exactly in array to avoid double-ups
      // and refresh double-ups
      var contain = noticesList.where((element) {
        if (element.level == notice.level &&
            element.subject == notice.subject &&
            element.body == notice.body &&
            element.teacher == notice.teacher &&
            element.placeMeet == notice.placeMeet &&
            element.dateMeet == notice.dateMeet &&
            element.timeMeet == notice.timeMeet) {
          return true;
        } else {
          return false;
        }
      });

      if (contain.isEmpty) noticesList.add(notice);
    }

    return noticesList;
  }

  List<Notice> _addAllGeneral(Iterable<XmlElement> notices) {
    List<Notice> noticesList = [];
    for (XmlElement element in notices) {
      Notice notice = Notice.general(
        level: element.getElement("Level").text,
        subject: element.getElement("Subject").text,
        body: element.getElement("Body").text,
        teacher: element.getElement("Teacher").text,
      );

      // Check if item exists exactly in array to avoid double-ups
      // and refresh double-ups
      var contain = noticesList.where((element) {
        if (element.level == notice.level &&
            element.subject == notice.subject &&
            element.body == notice.body &&
            element.teacher == notice.teacher &&
            element.placeMeet == notice.placeMeet &&
            element.dateMeet == notice.dateMeet &&
            element.timeMeet == notice.timeMeet) {
          return true;
        } else {
          return false;
        }
      });

      if (contain.isEmpty) noticesList.add(notice);
    }

    return noticesList;
  }
}