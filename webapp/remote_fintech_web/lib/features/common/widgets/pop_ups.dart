import 'package:fintech_new_web/features/home.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../utility/global_variables.dart';

BuildContext? dialogContext;

Future showConfirmationDialogue(BuildContext context, String confirmationString,
    String confirmButtonString, String cancelButtonString) {
  Widget buttonWidget = Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      InkWell(
        onTap: () {
          // Navigator.pop(context, false);
          Navigator.of(context, rootNavigator: true).pop(false);
        },
        child: Container(
          margin: const EdgeInsets.only(right: 5),
          width: GlobalVariables.deviceWidth * 0.15,
          height: GlobalVariables.deviceHeight * 0.05,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: HexColor("#e0e0e0"),
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [
              BoxShadow(
                color: Colors.grey,
                blurRadius: 2,
                offset: Offset(
                  2,
                  3,
                ),
              )
            ],
          ),
          child: Text(cancelButtonString,
              style: const TextStyle(fontSize: 11, color: Colors.black)),
        ),
      ),
      SizedBox(
        width: GlobalVariables.deviceWidth * 0.01,
      ),
      InkWell(
        onTap: () {
          // Navigator.pop(context, true);
          Navigator.of(context, rootNavigator: true).pop(true);
        },
        child: Container(
          key: const Key('TestConfirmBtnPopup'),
          margin: const EdgeInsets.only(left: 5),
          width: GlobalVariables.deviceWidth * 0.25,
          height: GlobalVariables.deviceHeight * 0.05,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: GlobalVariables.themeColor,
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [
              BoxShadow(
                color: Colors.grey,
                blurRadius: 2,
                offset: Offset(
                  2,
                  3,
                ),
              )
            ],
          ),
          child: Text(
            key: const Key('TestConfirmOrderFeedbackBtn'),
            confirmButtonString,
            style: const TextStyle(color: Colors.white, fontSize: 11),
          ),
        ),
      ),
    ],
  );
  AlertDialog alert = AlertDialog(
    icon: CircleAvatar(
      backgroundColor: GlobalVariables.themeColor,
      radius: 30,
      child: const Center(
          child: Icon(
        Icons.question_mark_rounded,
        size: 52,
        color: Colors.white,
      )),
    ),
    iconPadding: const EdgeInsets.only(top: 13),
    content: Text(
      confirmationString,
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontWeight: FontWeight.w500,
        fontSize: 16,
      ),
    ),
    contentPadding: const EdgeInsets.fromLTRB(20, 25, 20, 40),
    insetPadding:
        EdgeInsets.symmetric(horizontal: 0.07 * GlobalVariables.deviceWidth),
    actions: [buttonWidget],
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10))),
    //insetPadding:EdgeInsets.all(1)
  );
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return Theme(
          data: ThemeData(
            scaffoldBackgroundColor: GlobalVariables.backgroundColor,
            colorScheme: const ColorScheme.light(primary: Colors.white),
            appBarTheme: const AppBarTheme(
              elevation: 0,
              iconTheme: IconThemeData(
                color: Colors.black,
              ),
            ),
            pageTransitionsTheme: const PageTransitionsTheme(
              builders: {
                TargetPlatform.android: CupertinoPageTransitionsBuilder(),
                TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
              },
            ),
            useMaterial3: true, // can remove this line
            textSelectionTheme: const TextSelectionThemeData(
              selectionColor: Color.fromARGB(255, 120, 201, 238),
              selectionHandleColor: Colors.black,
            ),
          ),
          child: alert);
    },
  );
}

Future showAlertDialog(BuildContext context, String content,
    String buttonString, bool redirectHome,
    [bool dismiss = false]) {
  Widget continueButton = Center(
      child: ElevatedButton(
          onPressed: () {
            redirectHome
                // ignore: unnecessary_statements
                ? {
                    Navigator.of(context, rootNavigator: true).pop(true),
                    context.goNamed(HomePageScreen.routeName)
                  }
                : dismissDialog();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: GlobalVariables.themeColor,
            shadowColor: Colors.grey,
            elevation: 3,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 55.0),
            child: Text(
              buttonString,
              key: const Key('oidContinuebtn'),
              style: const TextStyle(color: Colors.white),
            ),
          )));

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    backgroundColor: Colors.white,
    icon: Icon(
      Icons.info,
      size: 65,
      color: GlobalVariables.themeColor,
    ),
    iconPadding: const EdgeInsets.only(top: 7),
    content: Text(
      content,
      textAlign: TextAlign.center,
      style: const TextStyle(
          fontWeight: FontWeight.w500, fontSize: 16, color: Colors.black),
    ),
    contentPadding: const EdgeInsets.fromLTRB(20, 25, 20, 40),
    insetPadding:
        EdgeInsets.symmetric(horizontal: 0.07 * GlobalVariables.deviceWidth),
    actions: [
      continueButton,
    ],
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10))),
  );

  // show the dialog
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      dialogContext = context;
      return Theme(
          data: ThemeData(
            fontFamily: "Poppins",
            scaffoldBackgroundColor: GlobalVariables.backgroundColor,
            colorScheme: const ColorScheme.light(primary: Colors.white),
            appBarTheme: const AppBarTheme(
              elevation: 0,
              iconTheme: IconThemeData(
                color: Colors.black,
              ),
            ),
            pageTransitionsTheme: const PageTransitionsTheme(
              builders: {
                TargetPlatform.android: CupertinoPageTransitionsBuilder(),
                TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
              },
            ),
            useMaterial3: true, // can remove this line
            textSelectionTheme: const TextSelectionThemeData(
              selectionColor: Color.fromARGB(255, 120, 201, 238),
              selectionHandleColor: Colors.black,
            ),
          ),
          child: alert);
    },
  );
}

void dismissDialog({bool dismiss = false}) async {
  if (dialogContext != null) {
    Navigator.of(dialogContext!).pop();
    dialogContext = null; // Reset the context
  }
}
