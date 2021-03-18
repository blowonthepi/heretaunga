import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heretaunga/components/Main/OfflineChip.dart';
import 'package:heretaunga/main.dart';
import 'package:heretaunga/screens/settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String pageTitle;
  final bool isConnected;
  final SharedPreferences prefs;
  final ImageProvider profileImage;

  CustomAppBar(
      {@required this.pageTitle,
        @required this.isConnected,
        @required this.prefs,
        @required this.profileImage});

  @override
  _CustomAppBarState createState() => _CustomAppBarState();

  @override
  Size get preferredSize => Size(double.infinity, 150);

}

// ignore: must_be_immutable
class _CustomAppBarState extends State<CustomAppBar> {
  Size size;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    size = Size(MediaQuery.of(context).size.width, 140);
    return PreferredSize(
      preferredSize: size,
      child: Container(
        height: 140,
        color: Theme.of(context).appBarTheme.backgroundColor,
        child: Padding(
          padding:
              EdgeInsets.only(top: MediaQuery.of(context).padding.top),
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Stack(
              children: [
                Positioned(
                  left: 0,
                  right: 0,
                  child: AnimatedOpacity(
                    opacity: widget.isConnected ? 0 : 1,
                    duration: Duration(milliseconds: 200),
                    child: OfflineChip(),
                  ),
                ),
                Positioned(
                  bottom: 8,
                  left: 16,
                  right: 16,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.pageTitle,
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          fontFamily: GoogleFonts.robotoSlab().fontFamily,
                          color: Theme.of(context).appBarTheme.titleTextStyle.color
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).push(new MaterialPageRoute(
                            fullscreenDialog: true,
                            builder: (context) => Settings(isConnected: widget.isConnected),
                          ));
                        },
                        child: Hero(
                          tag: "profilePicture",
                          child: CircleAvatar(
                            radius: 20,
                            backgroundColor: Colors.black,
                            backgroundImage: widget.profileImage,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
