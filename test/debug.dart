import 'dart:developer';

import 'package:xml/xml.dart';

void printXml(XmlElement object) {
  log(object.toXmlString(pretty: true, indent: '\t'));
}