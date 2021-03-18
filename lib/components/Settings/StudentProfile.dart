import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heretaunga/components/keys.dart';
import 'package:heretaunga/main.dart';
import 'package:heretaunga/tools/API/api.dart';

/// Returns a widget with:
/// Profile Picture
/// Name
/// Logout button
/// TODO: NSN number
class StudentProfile extends StatelessWidget {
  final BuildContext context;
  final ImageProvider profileImage;
  final Function onChanged;

  StudentProfile(
      {@required this.context,
      @required this.profileImage,
      @required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            changeProfileDialog();
          },
          child: Stack(
            children: [
              Hero(
                tag: "profilePicture",
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage:
                      Keys.accessGlobalData.currentState.getProfilePicture(),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: CircleAvatar(
                  radius: 15,
                  child: Icon(
                    Icons.edit_outlined,
                    size: 20,
                    color: Theme.of(context).backgroundColor,
                  ),
                  backgroundColor: Theme.of(context).iconTheme.color,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 8.0),
                child: Text(
                  "${Keys.accessGlobalData.currentState.getStudentName()}",
                  style: TextStyle(
                    fontFamily: GoogleFonts.robotoSlab().fontFamily,
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: TextButton(
                  onPressed: () {
                    if (API().logout(context)) {
                      Keys.accessGlobalData.currentState.refreshGlobals();
                      Navigator.of(context).pushReplacementNamed("/login");
                    }
                  },
                  child: Text(
                    "Logout".toUpperCase(),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Change profile picture dialog
  changeProfileDialog() {
    showDialog(
        builder: (context) {
          return IntrinsicHeight(
            child: Dialog(
              child: GridView.builder(
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3),
                itemCount: 6,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {
                          Keys.accessGlobalData.currentState
                              .updateProfilePicture(index);
                          Navigator.pop(context);
                        },
                        child: CircleAvatar(
                          radius: 75,
                          backgroundImage: profileImage,
                          backgroundColor: Colors.white,
                        ),
                      ),
                    );
                  }
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () {
                        Keys.accessGlobalData.currentState
                            .updateProfilePicture(index);
                        Navigator.pop(context);
                        onChanged();
                      },
                      child: CircleAvatar(
                        radius: 75,
                        backgroundImage:
                            AssetImage("assets/avatars/avatar_$index.png"),
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        },
        context: context);
  }
}
