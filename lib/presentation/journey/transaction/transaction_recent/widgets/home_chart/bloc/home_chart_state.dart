part of 'home_chart_bloc.dart';

abstract class HomeChartState extends Equatable {
  final List<ColumnChartValueTypeEnum> listTypeName;

  HomeChartState(this.listTypeName);

  @override
  List<Object> get props => [listTypeName];
}

class HomeChartInitial extends HomeChartState {
  final bool isCurrent;

  HomeChartInitial(List<ColumnChartValueTypeEnum> listTypeName,
      {this.isCurrent = true})
      : super(listTypeName);

  HomeChartInitial copyWith(
      {List<ColumnChartValueTypeEnum>? listTypeName, bool? isCurrent}) {
    return HomeChartInitial(listTypeName ?? this.listTypeName,
        isCurrent: !this.isCurrent);
  }

  @override
  List<Object> get props => super.props..add(isCurrent);
}
