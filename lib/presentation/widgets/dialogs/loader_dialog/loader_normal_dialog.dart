import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoaderNormalDialog {
  static LoaderNormalDialog? _instance;
  static BuildContext? _context;
  static bool? _showing;

  LoaderNormalDialog._internal();

  static Future<LoaderNormalDialog> getInstance() async {
    _instance ??= LoaderNormalDialog._internal();

    return _instance!;
  }

  bool get showing => _showing!;

  void show(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          _context = context;
          _showing = true;
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
  }

  void hide() {
    _showing = false;
    Navigator.pop(_context!);
  }
}
