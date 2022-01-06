import 'package:flutter/material.dart';

import 'theme_border.dart';

class ThemeInputDecoration {
  static InputDecorationTheme get(BuildContext context) => InputDecorationTheme(
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: ThemeBorder.getCircular(10),
          borderSide: const BorderSide(
            color: Colors.red,
            width: 1,
          ),
        ),
      );
}
