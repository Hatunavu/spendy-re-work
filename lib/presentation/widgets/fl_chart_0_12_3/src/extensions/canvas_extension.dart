import 'dart:ui';

import 'package:spendy_re_work/presentation/widgets/fl_chart_0_12_3/src/extensions/path_extension.dart';
import 'package:spendy_re_work/presentation/widgets/fl_chart_0_12_3/src/utils/canvas_wrapper.dart';

/// Defines extensions on the [CanvasWrapper]
extension DashedLine on CanvasWrapper {
  /// Draws a dashed line from passed in offsets
  void drawDashedLine(
      Offset from, Offset to, Paint painter, List<int>? dashArray) {
    var path = Path()
      ..moveTo(from.dx, from.dy)
      ..lineTo(to.dx, to.dy);
    path = path.toDashedPath(dashArray);
    drawPath(path, painter);
  }
}
