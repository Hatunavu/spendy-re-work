library worm_indicator;

import 'package:flutter/material.dart';

import 'dot.dart';
import 'shape.dart';

const defaultNormalDotColor = Color(0xff808080);

class WormIndicator extends StatefulWidget {
  WormIndicator({
    Key? key,
    required this.length,
    this.controller,
    this.shape,
    this.color = const Color(0xff808080),
    this.indicatorColor = const Color(0xff35affc),
  }) : super(key: key);

  final int length;
  final PageController? controller;
  final Color? color;
  final Color? indicatorColor;
  final Shape? shape;

  @override
  State<StatefulWidget> createState() => _DotsIndicatorState();
}

class _DotsIndicatorState extends State<WormIndicator> {
  Container getNormalDotChildContainer() {
    switch (widget.shape!.shape) {
      case DotShape.circle:
        return Container(
          width: widget.shape!.size,
          height: widget.shape!.size,
        );
      default:
        return Container(
          width: widget.shape!.width,
          height: widget.shape!.height,
        );
    }
  }

  BoxDecoration getNormalDotDecoration(Color? color) {
    switch (widget.shape!.shape) {
      case DotShape.circle:
        return BoxDecoration(
          color: color ?? const Color(0xff35affc),
          shape: BoxShape.circle,
        );
      case DotShape.square:
      case DotShape.rectangle:
        return BoxDecoration(
          color: color ?? const Color(0xff35affc),
          shape: BoxShape.rectangle,
        );
      default:
        return BoxDecoration(
          color: color ?? const Color(0xff35affc),
          shape: BoxShape.circle,
        );
    }
  }

  Widget buildDot(Color color, int index) {
    if ((widget.length % 2 == 1 && index == (widget.length ~/ 2)) ||
        index == -1) {
      return Container(
        decoration: getNormalDotDecoration(color),
        child: getNormalDotChildContainer(),
      );
    }

    if (widget.length % 2 == 1 && index < (widget.length ~/ 2)) {
      return Container(
        margin: EdgeInsets.only(right: widget.shape!.spacing!),
        decoration: getNormalDotDecoration(color),
        child: getNormalDotChildContainer(),
      );
    }

    if (widget.length % 2 == 1 && index > (widget.length ~/ 2)) {
      return Container(
        margin: EdgeInsets.only(left: widget.shape!.spacing!),
        decoration: getNormalDotDecoration(color),
        child: getNormalDotChildContainer(),
      );
    }

    if ((widget.length % 2 == 0 && index < (widget.length ~/ 2)) ||
        index == -1) {
      return Container(
        margin: EdgeInsets.only(right: widget.shape!.spacing!),
        decoration: getNormalDotDecoration(color),
        child: getNormalDotChildContainer(),
      );
    }

    if (widget.length % 2 == 0 && index > (widget.length ~/ 2)) {
      return Container(
        margin: EdgeInsets.only(left: widget.shape!.spacing!),
        decoration: getNormalDotDecoration(color),
        child: getNormalDotChildContainer(),
      );
    }

    return Container(
      decoration: getNormalDotDecoration(color),
      child: getNormalDotChildContainer(),
    );
  }

  List<Widget> _renderNormalDots() {
    final List<Widget> listDots = [];
    for (int i = 0; i < widget.length; i++) {
      listDots.add(buildDot(widget.color ?? defaultNormalDotColor, i));
    }
    return listDots;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Stack(
        children: <Widget>[
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: _renderNormalDots(),
            ),
          ),
          Container(
            child: DotInstance(
              length: widget.length,
              listenable: widget.controller,
              shape: widget.shape,
              color: widget.indicatorColor,
            ),
          ),
        ],
      ),
    );
  }
}
