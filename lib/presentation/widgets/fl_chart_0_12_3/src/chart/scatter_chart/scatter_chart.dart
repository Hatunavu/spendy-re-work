import 'package:spendy_re_work/presentation/widgets/fl_chart_0_12_3/fl_chart.dart';
import 'package:spendy_re_work/presentation/widgets/fl_chart_0_12_3/src/chart/base/base_chart/base_chart_painter.dart';
import 'package:spendy_re_work/presentation/widgets/fl_chart_0_12_3/src/chart/base/base_chart/touch_input.dart';
import 'package:spendy_re_work/presentation/widgets/fl_chart_0_12_3/src/chart/scatter_chart/scatter_chart_data.dart';
import 'package:spendy_re_work/presentation/widgets/fl_chart_0_12_3/src/chart/scatter_chart/scatter_chart_painter.dart';
import 'package:spendy_re_work/presentation/widgets/fl_chart_0_12_3/src/utils/utils.dart';
import 'package:flutter/cupertino.dart';

/// Renders a pie chart as a widget, using provided [ScatterChartData].
class ScatterChart extends ImplicitlyAnimatedWidget {
  /// Determines how the [ScatterChart] should be look like.
  final ScatterChartData data;

  /// [data] determines how the [ScatterChart] should be look like,
  /// when you make any change in the [ScatterChartData], it updates
  /// new values with animation, and duration is [swapAnimationDuration].
  const ScatterChart(
    this.data, {
    Duration swapAnimationDuration = const Duration(milliseconds: 150),
  }) : super(duration: swapAnimationDuration);

  /// Creates a [_ScatterChartState]
  @override
  _ScatterChartState createState() => _ScatterChartState();
}

class _ScatterChartState extends AnimatedWidgetBaseState<ScatterChart> {
  /// we handle under the hood animations (implicit animations) via this tween,
  /// it lerps between the old [ScatterChartData] to the new one.
  ScatterChartDataTween? _scatterChartDataTween;

  TouchHandler<ScatterTouchResponse>? _touchHandler;

  final GlobalKey _chartKey = GlobalKey();

  List<int> touchedSpots = [];

  @override
  Widget build(BuildContext context) {
    final showingData = _getData();
    final touchData = showingData.scatterTouchData;

    return GestureDetector(
      onLongPressStart: (d) {
        final chartSize = _getChartSize();
        if (chartSize == null) {
          return;
        }

        final response = _touchHandler?.handleTouch(
            FlLongPressStart(d.localPosition), chartSize);
        if (_canHandleTouch(response!, touchData)) {
          touchData.touchCallback(response);
        }
      },
      onLongPressEnd: (d) {
        final chartSize = _getChartSize();
        if (chartSize == null) {
          return;
        }

        final response = _touchHandler?.handleTouch(
            FlLongPressEnd(d.localPosition), chartSize);
        if (_canHandleTouch(response!, touchData)) {
          touchData.touchCallback(response);
        }
      },
      onLongPressMoveUpdate: (d) {
        final chartSize = _getChartSize();
        if (chartSize == null) {
          return;
        }

        final response = _touchHandler?.handleTouch(
            FlLongPressMoveUpdate(d.localPosition), chartSize);
        if (_canHandleTouch(response!, touchData)) {
          touchData.touchCallback(response);
        }
      },
      onPanCancel: () {
        final chartSize = _getChartSize();
        if (chartSize == null) {
          return;
        }

        final response = _touchHandler?.handleTouch(
            FlPanEnd(Offset.zero, const Velocity(pixelsPerSecond: Offset.zero)),
            chartSize);
        if (_canHandleTouch(response!, touchData)) {
          touchData.touchCallback(response);
        }
      },
      onPanEnd: (DragEndDetails details) {
        final chartSize = _getChartSize();
        if (chartSize == null) {
          return;
        }

        final response = _touchHandler?.handleTouch(
            FlPanEnd(Offset.zero, details.velocity), chartSize);
        if (_canHandleTouch(response!, touchData)) {
          touchData.touchCallback(response);
        }
      },
      onPanDown: (DragDownDetails details) {
        final chartSize = _getChartSize();
        if (chartSize == null) {
          return;
        }

        final response = _touchHandler?.handleTouch(
            FlPanStart(details.localPosition), chartSize);
        if (_canHandleTouch(response!, touchData)) {
          touchData.touchCallback(response);
        }
      },
      onPanUpdate: (DragUpdateDetails details) {
        final chartSize = _getChartSize();
        if (chartSize == null) {
          return;
        }

        final response = _touchHandler?.handleTouch(
            FlPanMoveUpdate(details.localPosition), chartSize);
        if (_canHandleTouch(response!, touchData)) {
          touchData.touchCallback(response);
        }
      },
      child: CustomPaint(
        key: _chartKey,
        size: getDefaultSize(MediaQuery.of(context).size),
        painter: ScatterChartPainter(
          _withTouchedIndicators(_scatterChartDataTween!.evaluate(animation)),
          _withTouchedIndicators(showingData),
          (touchHandler) {
            setState(() {
              _touchHandler =
                  touchHandler as TouchHandler<ScatterTouchResponse>?;
            });
          },
          textScale: MediaQuery.of(context).textScaleFactor,
        ),
      ),
    );
  }

  bool _canHandleTouch(
      ScatterTouchResponse? response, ScatterTouchData? touchData) {
    return response != null && touchData != null;
  }

  ScatterChartData _withTouchedIndicators(ScatterChartData? scatterChartData) {
    if (scatterChartData == null) {
      return scatterChartData!;
    }

    if (!scatterChartData.scatterTouchData.enabled ||
        !scatterChartData.scatterTouchData.handleBuiltInTouches) {
      return scatterChartData;
    }

    return scatterChartData.copyWith(
      showingTooltipIndicators: touchedSpots,
    );
  }

  Size? _getChartSize() {
    final RenderBox? containerRenderBox =
        _chartKey.currentContext!.findRenderObject() as RenderBox?;
    if (containerRenderBox != null && containerRenderBox.hasSize) {
      return containerRenderBox.size;
    }
    return null;
  }

  ScatterChartData _getData() {
    final scatterTouchData = widget.data.scatterTouchData;
    if (scatterTouchData.enabled && scatterTouchData.handleBuiltInTouches) {
      return widget.data.copyWith(
        scatterTouchData: widget.data.scatterTouchData
            .copyWith(touchCallback: _handleBuiltInTouch),
      );
    }
    return widget.data;
  }

  void _handleBuiltInTouch(ScatterTouchResponse touchResponse) {
    // if (widget.data.scatterTouchData.touchCallback != null) {
    //   widget.data.scatterTouchData.touchCallback(touchResponse);
    // }

    if (touchResponse.touchInput is FlPanStart ||
        touchResponse.touchInput is FlPanMoveUpdate ||
        touchResponse.touchInput is FlLongPressStart ||
        touchResponse.touchInput is FlLongPressMoveUpdate) {
      setState(() {
        touchedSpots = [touchResponse.touchedSpotIndex];
      });
    } else {
      setState(() {
        touchedSpots = [];
      });
    }
  }

  @override
  void forEachTween(dynamic visitor) {
    _scatterChartDataTween = visitor(
      _scatterChartDataTween,
      _getData(),
      (dynamic value) => ScatterChartDataTween(begin: value, end: widget.data),
    ) as ScatterChartDataTween;
  }
}
