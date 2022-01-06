import 'package:flutter/material.dart';
import 'package:spendy_re_work/presentation/journey/home/widgets/pages_view.dart';

import 'bottom_tab.dart';

class BodyHome extends StatelessWidget {
  const BodyHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        PagesViewHome(),
        Visibility(
          visible: MediaQuery.of(context).viewInsets.bottom == 0,
          child: Container(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: BottomTabHome(),
            ),
          ),
        ),
      ],
    );
  }
}
