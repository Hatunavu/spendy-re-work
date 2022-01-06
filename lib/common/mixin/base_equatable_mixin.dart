import 'package:equatable/equatable.dart';

export 'package:equatable/equatable.dart';

/// A Base mixin that will make you easier to compare
///
/// By default [props] is contains `runtimeType`
///
/// and also by default [stringify] is `true`
///
/// Use this for entity which is parent of table
/// and override the props with field/property to compare
/// ```dart
/// class ExampleEntity with EquatableMixin, BaseEquatableMixin {
///   final String someProperty;
///   final String anotherProperty;
///
///   ExampleEntity({this.someProperty, this.anotherProperty});
///
///   @override
///   List<Object> get props => [someProperty, anotherProperty];
/// }
/// ```
/// if you want apply this for event/state use [BaseEquatable] instead
mixin BaseEquatableMixin on EquatableMixin {
  @override
  List<Object> get props => [runtimeType];

  @override
  bool get stringify => true;
}
