import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SuccessDialog {
  static void show(BuildContext context, Function()? onPressed,
      {String? title}) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => CupertinoAlertDialog(
                title: title != null ? Text(title) : null,
                content: const Text('Success'),
                actions: [
                  ElevatedButton(
                    onPressed: onPressed,
                    child: const Text('Ok'),
                  )
                ]));
  }
}
