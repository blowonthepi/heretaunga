import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:heretaunga/components/notice_card.dart';
import 'package:heretaunga/tools/API/api_handler.dart';
import 'package:heretaunga/tools/constructors/notices.dart';

class Notices extends StatefulWidget {
  @override
  _NoticesState createState() => _NoticesState();
}

class _NoticesState extends State<Notices> {
  Future _appData;
  List<Notice> noticesList = [];

  @override
  void initState() {
    _appData = getAppData();
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      if(result != ConnectivityResult.none) {
        setState(() {
          _appData = getAppData();
        });
      }
    });
    super.initState();
  }

  Future<bool> getAppData() async {
    noticesList = await getNoticesData();
    if(noticesList.length > 0) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _appData,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.data == false) {
            return Center(
              child: Text("Oops! Something went wrong."),
            );
          }

          if(noticesList.isEmpty) {
            return Center(
              child: Text("There are currently no notices.\nPlease check back later.",
                textAlign: TextAlign.center,
              ),
            );
          }
          return RefreshIndicator(
            onRefresh: () {
              setState(() {
                _appData = null;
                _appData = getAppData();
              });
              return _appData;
            },
            child: ListView.builder(
              itemCount: noticesList.length,
              itemBuilder: (context, index) {
                Notice notice = noticesList[index];
                return ExpansionCard(notice: notice,);
              },
            ),
          );
        });
  }

  Widget customChip(String title, IconData icon) {
    if (title != null) {
      return Padding(
        padding: const EdgeInsets.all(2.0),
        child: Chip(
          backgroundColor: Colors.amber,
          label: Row(
            children: [
              icon != null
                  ? Icon(
                      icon,
                      color: Colors.black,
                    )
                  : Container(),
              Text(
                title,
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          labelPadding: EdgeInsets.all(2.0),
        ),
      );
    } else
      return Container();
  }
}
