import 'package:flutter/material.dart';
import 'package:spendy_re_work/common/extensions/string_extensions.dart';
import 'package:spendy_re_work/common/enums/category_type.dart';
import 'package:spendy_re_work/domain/entities/category_entity.dart';

class CategoryModel extends CategoryEntity {
  CategoryModel(
      {String? id,
      int? createAt,
      String? name,
      CategoryType? type,
      Color? color})
      : super(id: id, createAt: createAt, name: name, type: type, color: color);

  factory CategoryModel.fromJson(Map<String, dynamic> json, String id) {
    CategoryType type = CategoryType.expense;
    final Color color = json['color'].toString().toColor();
    if (json['type'] == CategoryType.goal.toString()) {
      type = CategoryType.goal;
    }
    return CategoryModel(
        id: id,
        createAt: json['create_at'],
        name: json['name'],
        type: type,
        color: color);
  }

  Map<String, dynamic> toJson() => {
        'color': color!.value.toRadixString(16),
        'create_at': createAt,
        'name': name,
        'type': type!.name
      };
}
