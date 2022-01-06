import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';

class TagListConstants {
  static const SizedBox spacingBetweenIconAndTitle = SizedBox(width: 16);
  static const SizedBox spacingBetweenHeaderAndTags = SizedBox(height: 18);

  static double categoryTagPaddingHorizontal = 17;
  static double categoryTagPaddingVertical = 5;

  static String deleteButtonTitle = translate('label.delete_button_title');
  static String addMoreTagTitle = translate('label.add_more_tag_title');
}
