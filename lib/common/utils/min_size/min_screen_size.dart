import 'package:flutter/material.dart';

class MinScreenSize {
  // percent is value from 0 to 1
  static double minHeight(BuildContext context, double percent) =>
      MediaQuery.of(context).size.height * percent;

  static double minWidth(BuildContext context, double percent) =>
      MediaQuery.of(context).size.width * percent;
}
