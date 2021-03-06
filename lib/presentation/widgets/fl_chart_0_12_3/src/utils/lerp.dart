import 'dart:ui';

import 'package:spendy_re_work/presentation/widgets/fl_chart_0_12_3/fl_chart.dart';
import 'package:spendy_re_work/presentation/widgets/fl_chart_0_12_3/src/chart/scatter_chart/scatter_chart_data.dart';
import 'package:flutter/animation.dart';

List<T>? _lerpList<T>(List<T>? a, List<T>? b, double t,
    {required T? Function(T?, T?, double) lerp}) {
  if (a != null && b != null && a.length == b.length) {
    return List.generate(a.length, (i) {
      return lerp(a[i], b[i], t)!;
    });
  } else if (a != null && b != null) {
    return List.generate(b.length, (i) {
      return lerp(i >= a.length ? b[i] : a[i], b[i], t)!;
    });
  } else {
    return b;
  }
}

/// Lerps [Color] list based on [t] value, check [Tween.lerp].
List<Color>? lerpColorList(List<Color> a, List<Color> b, double t) =>
    _lerpList(a, b, t, lerp: Color.lerp);

/// Lerps [double] list based on [t] value, check [Tween.lerp].
List<double>? lerpDoubleList(List<double>? a, List<double>? b, double t) =>
    _lerpList(a, b, t, lerp: lerpDouble);

/// Lerps [int] list based on [t] value, check [Tween.lerp].
List<int>? lerpIntList(List<int>? a, List<int>? b, double t) =>
    _lerpList(a, b, t, lerp: lerpInt);

/// Lerps [int] list based on [t] value, check [Tween.lerp].
int? lerpInt(int? a, int? b, double t) {
  return (a! + (b! - a) * t).round();
}

/// Lerps [FlSpot] list based on [t] value, check [Tween.lerp].
List<FlSpot>? lerpFlSpotList(List<FlSpot> a, List<FlSpot> b, double t) =>
    _lerpList(a, b, t, lerp: FlSpot.lerp);

/// Lerps [HorizontalLine] list based on [t] value, check [Tween.lerp].
List<HorizontalLine>? lerpHorizontalLineList(
        List<HorizontalLine> a, List<HorizontalLine> b, double t) =>
    _lerpList(a, b, t, lerp: (a, b, t) => HorizontalLine.lerp(a, b, t));

/// Lerps [VerticalLine] list based on [t] value, check [Tween.lerp].
List<VerticalLine>? lerpVerticalLineList(
        List<VerticalLine> a, List<VerticalLine> b, double t) =>
    _lerpList(a, b, t, lerp: (a, b, t) => VerticalLine.lerp(a, b, t));

/// Lerps [HorizontalRangeAnnotation] list based on [t] value, check [Tween.lerp].
List<HorizontalRangeAnnotation>? lerpHorizontalRangeAnnotationList(
        List<HorizontalRangeAnnotation> a,
        List<HorizontalRangeAnnotation> b,
        double t) =>
    _lerpList(a, b, t,
        lerp: (a, b, t) => HorizontalRangeAnnotation.lerp(a, b, t));

/// Lerps [VerticalRangeAnnotation] list based on [t] value, check [Tween.lerp].
List<VerticalRangeAnnotation>? lerpVerticalRangeAnnotationList(
        List<VerticalRangeAnnotation> a,
        List<VerticalRangeAnnotation> b,
        double t) =>
    _lerpList(a, b, t,
        lerp: (a, b, t) => VerticalRangeAnnotation.lerp(a, b, t));

/// Lerps [LineChartBarData] list based on [t] value, check [Tween.lerp].
List<LineChartBarData>? lerpLineChartBarDataList(
        List<LineChartBarData> a, List<LineChartBarData> b, double t) =>
    _lerpList(a, b, t, lerp: (a, b, t) => LineChartBarData.lerp(a, b, t));

/// Lerps [BetweenBarsData] list based on [t] value, check [Tween.lerp].
List<BetweenBarsData>? lerpBetweenBarsDataList(
        List<BetweenBarsData> a, List<BetweenBarsData> b, double t) =>
    _lerpList(a, b, t, lerp: (a, b, t) => BetweenBarsData.lerp(a, b, t));

/// Lerps [BarChartGroupData] list based on [t] value, check [Tween.lerp].
List<BarChartGroupData>? lerpBarChartGroupDataList(
        List<BarChartGroupData> a, List<BarChartGroupData> b, double t) =>
    _lerpList(a, b, t, lerp: (a, b, t) => BarChartGroupData.lerp(a, b, t));

/// Lerps [BarChartRodData] list based on [t] value, check [Tween.lerp].
List<BarChartRodData>? lerpBarChartRodDataList(
        List<BarChartRodData> a, List<BarChartRodData> b, double t) =>
    _lerpList(a, b, t, lerp: (a, b, t) => BarChartRodData.lerp(a, b, t));

// /// Lerps [PieChartSectionData] list based on [t] value, check [Tween.lerp].
// List<PieChartSectionData>? lerpPieChartSectionDataList(
//         List<PieChartSectionData> a, List<PieChartSectionData> b, double t) =>
//     _lerpList(a, b, t, lerp: PieChartSectionData.lerp);

/// Lerps [ScatterSpot] list based on [t] value, check [Tween.lerp].
List<ScatterSpot>? lerpScatterSpotList(
        List<ScatterSpot> a, List<ScatterSpot> b, double t) =>
    _lerpList(a, b, t, lerp: (a, b, t) => ScatterSpot.lerp(a, b, t));

/// Lerps [BarChartRodStackItem] list based on [t] value, check [Tween.lerp].
List<BarChartRodStackItem>? lerpBarChartRodStackList(
        List<BarChartRodStackItem> a, List<BarChartRodStackItem> b, double t) =>
    _lerpList(a, b, t, lerp: (a, b, t) => BarChartRodStackItem.lerp(a, b, t));
