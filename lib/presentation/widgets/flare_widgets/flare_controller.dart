import 'package:flare_flutter/flare_controls.dart';

class MyFlareController extends FlareControls {
  // Redefine on completed
  // when completed, flare replays animation
  @override
  void onCompleted(String name) {
    play(name);
    super.onCompleted(name);
  }
}
