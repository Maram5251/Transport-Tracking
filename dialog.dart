import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';

class MyDialog{
  static void showMyDialog({
    required BuildContext context,
    required StatefulWidget mywidget,
    required DialogType dialogtype,
    required String title,
    required String description,
  }) {
    AwesomeDialog(
      context: context,
      dialogType: dialogtype,
      animType: AnimType.topSlide,
      showCloseIcon: true,
      title: title,
      desc: description,
      btnOkOnPress: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => mywidget),
        );
      },
    ).show();
}}