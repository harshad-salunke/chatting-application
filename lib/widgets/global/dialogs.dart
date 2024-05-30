import 'package:flutter/material.dart';

import 'progress_dialog.dart';

class Dialogs {
  static void showSnackbar(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(msg),
        backgroundColor: Colors.blue.withOpacity(.8),
        behavior: SnackBarBehavior.floating));
  }

  static void showCircularProgressBar(BuildContext context) {
    showDialog(
        context: context,

        builder: (_) => const Center(
                child: CircularProgressIndicator(
                  color: Colors.red,
              strokeWidth: 3,
            )));
  }

 static void showProgressBarIcons(BuildContext context,String title){
    showDialog(
        context: context,
        barrierDismissible: false, 
        builder: (BuildContext context) {
          return MyProgressDialog(text: title,);
        });
  }
}
