import 'package:flutter_translate/flutter_translate.dart';

enum ColumnChartValueTypeEnum { daily, week }

String? mapChartTypeToString(ColumnChartValueTypeEnum type) {
  return _map[type];
}

final _map = {
  ColumnChartValueTypeEnum.daily: translate('label.daily'),
  ColumnChartValueTypeEnum.week: translate('label.week')
};
