import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Utils {
  // .........flutter tost message........//

  static void toast({required String message, Color? color}) {
    Fluttertoast.showToast(
        gravity: ToastGravity.TOP,
        msg: message,
        backgroundColor: color ?? Colors.green,
        toastLength: Toast.LENGTH_SHORT);
  }
// Scaffold Message........

  static void scaffoldMessage(
      {required String message, Color? color, required BuildContext context}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      // behavior: SnackBarBehavior.floating,

      content: Text(
        message,
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: color ?? Colors.green,
    ));
  }

  // Check Internet.......
  static Future<dynamic> checkInternet() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      return false;
    } else {
      return true;
    }
  }

  // For when user is click on outside the keyboard then the keyboard is close
  static void keyBoardDismiss() {
    FocusManager.instance.primaryFocus!.unfocus();
  }
}

class AppLogs {
  static debugging(Object object) {
    log(object.toString());
  }
}
