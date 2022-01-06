import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:spendy_re_work/common/extensions/screen_utils_extensions.dart';
import 'package:spendy_re_work/presentation/journey/transaction/transaction_recent/transaction_recent_constants.dart';

final _groupItemHeight = TransactionRecentConstants.groupItemHeight;
final _minItemHeight = TransactionRecentConstants.minGroupItemHeight;
var _height = _groupItemHeight;
ScrollDirection? _lastDirection;
double _delta = 0;

double getItemHeight({required ScrollController scrollController}) {
  final _offset = scrollController.offset.h;
  final _direction = scrollController.position.userScrollDirection;
  if (_lastDirection != _direction) {
    // reset delta value to start new count
    _lastDirection = _direction;
    _delta = 0;
  }
  _delta = _offset.abs();
  if (_direction == ScrollDirection.forward) {
    if (_height < _groupItemHeight) {
      _height += _delta;
    } else {
      _height = _groupItemHeight;
    }
  } else {
    if (_height > _minItemHeight) {
      _height -= _delta;
    } else {
      _height = _minItemHeight;
    }
  }
  return _height < _minItemHeight ? _minItemHeight : _height;
}
