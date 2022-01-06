import 'package:flutter/material.dart';

import 'dots.dart';

class ListDots extends StatelessWidget {
  final int? countDots;
  final double? size;
  final Color? color;
  final Color? colorSelected;
  final int countSelect;

  ListDots({
    Key? key,
    this.countDots,
    this.size,
    this.color,
    this.colorSelected,
    this.countSelect = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        countDots!,
        (int index) {
          final isSelected = index < countSelect;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 13),
            child: Dots(
              key: keyDots(index),
              size: size!,
              isSelected: isSelected,
              color: (isSelected ? colorSelected : color)!,
            ),
          );
        },
      ),
    );
  }

  static ValueKey keyDots(int index) => ValueKey('dots_$index');
}
