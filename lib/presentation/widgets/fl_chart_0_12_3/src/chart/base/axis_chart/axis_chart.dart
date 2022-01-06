import 'package:spendy_re_work/presentation/widgets/fl_chart_0_12_3/src/chart/bar_chart/bar_chart.dart';
import 'package:spendy_re_work/presentation/widgets/fl_chart_0_12_3/src/chart/base/base_chart/base_chart.dart';
import 'package:spendy_re_work/presentation/widgets/fl_chart_0_12_3/src/chart/line_chart/line_chart.dart';

/// This class is suitable for axis base charts
/// in the axis base charts we have a grid behind the charts
/// the direct subclasses are [LineChart], [BarChart]
abstract class AxisChart extends BaseChart {}
