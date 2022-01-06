import 'package:equatable/equatable.dart';
import 'package:spendy_re_work/common/mixin/base_equatable_mixin.dart';

/// A Base class that will make you easier to compare
///
/// By default [props] is only contains `runtimeType`
///
/// and also by default [stringify] is `true`
///
/// Use this for event or state
/// ```dart
/// abstract class ExampleEvent extends BaseEquatable {}
/// ```
/// or you can override props
/// ```dart
/// abstract class ExampleState extends BaseEquatable {
///   final String someProperty;
///
///   ExampleState({this.someProperty});
///
///   @override
///   List<Object> get props => [someProperty];
/// }
/// ```
/// if you want apply this for entity use [BaseEquatableMixin] instead
abstract class BaseEquatable with EquatableMixin, BaseEquatableMixin {}
