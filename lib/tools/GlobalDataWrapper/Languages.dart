class GDWLanguages {
  // Language Maps
  static Map<String, String> _english = {
    "today": "Today",
    "timetable": "Timetable",
    "notices": "Notices",
    "results": "Results",
    "map": "Map",
    "settings": "Settings",
  };
  static Map<String, String> _maori = {
    "today": "Tēnei Rā",
    "timetable": "Wātaka",
    "notices": "Pānui",
    "results": "Ngā Paetae",
    "map": "Mapi",
    "settings": "Kōwhiri",
  };
  static Map<String, String> _chinese = {
    "today": "在今天",
    "timetable": "时间表",
    "notices": "宣布",
    "results": "成就",
    "map": "地图",
    "settings": "选项",
  };
  static Map<String, String> _german = {
    "today": "Heute",
    "timetable": "Zeitplan",
    "notices": "Melden",
    "results": "Erfolge",
    "map": "Stadtplan",
    "settings": "Optionen",
  };

  static Map<String, Map<String, String>> langMap = {
    "english": _english,
    "maori": _maori,
    "chinese": _chinese,
    "german": _german,
  };

  final Map<String, String> availableLangs = {
    "English": "english",
    "Māori": "maori",
    "Chinese (Simplified)": "chinese",
    "German": "german",
  };
}