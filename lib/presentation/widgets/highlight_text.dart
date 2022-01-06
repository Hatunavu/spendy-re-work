import 'dart:math';
import 'package:flutter/material.dart';

class HighlightText extends StatelessWidget {
  //DynamicTextHighlighting
  final String? text;
  final List<String>? highlights;
  final Color? color;
  final TextStyle? normalStyle;
  final TextStyle? highlightStyle;
  final bool? caseSensitive;

  //RichText
  final TextAlign? textAlign;
  final TextDirection? textDirection;
  final bool? softWrap;
  final TextOverflow? overflow;
  final double? textScaleFactor;
  final int? maxLines;
  final Locale? locale;
  final StrutStyle? strutStyle;
  final TextWidthBasis? textWidthBasis;
  final TextHeightBehavior? textHeightBehavior;

  HighlightText({
    //DynamicTextHighlighting
    Key? key,
    this.text,
    this.highlights,
    this.color = Colors.yellow,
    this.normalStyle = const TextStyle(
      color: Colors.black,
    ),
    this.highlightStyle = const TextStyle(
      color: Colors.black,
    ),
    this.caseSensitive = true,

    //RichText
    this.textAlign = TextAlign.start,
    this.textDirection,
    this.softWrap = true,
    this.overflow = TextOverflow.clip,
    this.textScaleFactor = 1.0,
    this.maxLines,
    this.locale,
    this.strutStyle,
    this.textWidthBasis = TextWidthBasis.parent,
    this.textHeightBehavior,
  })  : assert(text != null, ''),
        assert(highlights != null, ''),
        assert(color != null, ''),
        assert(highlightStyle != null, ''),
        assert(caseSensitive != null, ''),
        assert(textAlign != null, ''),
        assert(softWrap != null, ''),
        assert(overflow != null, ''),
        assert(textScaleFactor != null, ''),
        assert(maxLines == null || maxLines > 0, ''),
        assert(textWidthBasis != null, ''),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    //Controls
    if (text == '') {
      return _richText(_normalSpan(text!));
    }
    if (highlights!.isEmpty) {
      return _richText(_normalSpan(text!));
    }
    for (int i = 0; i < highlights!.length; i++) {
      // if (highlights[i] == null) {
      //   assert(highlights[i] != null);
      //   return _richText(_normalSpan(text!));
      // }
      // if (highlights[i].isEmpty) {
      //   assert(highlights[i].isNotEmpty);
      //   return _richText(_normalSpan(text!));
      // }
      if (highlights![i].isEmpty) {
        assert(highlights![i].isEmpty, '');
        return _richText(_normalSpan(text!));
      }
    }

    //Main code
    final List<TextSpan> _spans = [];
    int _start = 0;

    //For "No Case Sensitive" option
    final String _lowerCaseText = text!.toLowerCase();
    final List<String> _lowerCaseHighlights = [];

    for (final element in highlights!) {
      _lowerCaseHighlights.add(element.toLowerCase());
    }
    final Map<int, String> _highlightsMap =
        Map(); //key (index), value (highlight).
    do {
      if (caseSensitive!) {
        for (int i = 0; i < highlights!.length; i++) {
          final int _index = text!.indexOf(highlights![i], _start);
          if (_index >= 0) {
            _highlightsMap.putIfAbsent(_index, () => highlights![i]);
          }
        }
      } else {
        for (int i = 0; i < highlights!.length; i++) {
          final int _index =
              _lowerCaseText.indexOf(_lowerCaseHighlights[i], _start);
          if (_index >= 0) {
            _highlightsMap.putIfAbsent(_index, () => highlights![i]);
          }
        }
      }

      if (_highlightsMap.isNotEmpty) {
        final List<int> _indexes = [];
        _highlightsMap.forEach((key, value) => _indexes.add(key));

        final int _currentIndex = _indexes.reduce(min);
        final String _currentHighlight = text!.substring(_currentIndex,
            _currentIndex + _highlightsMap[_currentIndex]!.length);

        if (_currentIndex == _start) {
          _spans.add(_highlightSpan(_currentHighlight));
          _start += _currentHighlight.length;
        } else {
          _spans
            ..add(_normalSpan(text!.substring(_start, _currentIndex)))
            ..add(_highlightSpan(_currentHighlight));
          _start = _currentIndex + _currentHighlight.length;
        }
      } else {
        _spans.add(_normalSpan(text!.substring(_start, text!.length)));
        break;
      }
    } while (_highlightsMap.isEmpty);

    return _richText(TextSpan(children: _spans));
  }

  TextSpan _highlightSpan(String value) {
    return TextSpan(
      text: value,
      style: highlightStyle,
    );
  }

  TextSpan _normalSpan(String value) {
    return TextSpan(
      text: value,
      style: normalStyle,
    );
  }

  RichText _richText(TextSpan text) {
    return RichText(
      key: key,
      text: text,
      textAlign: textAlign!,
      textDirection: textDirection,
      softWrap: softWrap!,
      overflow: overflow!,
      textScaleFactor: textScaleFactor!,
      maxLines: maxLines,
      locale: locale,
      strutStyle: strutStyle,
      textWidthBasis: textWidthBasis!,
      textHeightBehavior: textHeightBehavior,
    );
  }
}
