import 'package:flutter/material.dart';
import 'package:spendy_re_work/common/enums/category_type.dart';
import 'package:spendy_re_work/common/mixin/base_equatable_mixin.dart';
import 'package:spendy_re_work/data/model/catergory_model.dart';
import 'package:spendy_re_work/presentation/theme/theme_color.dart';

class CategoryEntity extends Equatable {
  final String? id;
  final int? createAt;
  final String? name;
  final CategoryType? type;
  final Color? color;

  CategoryEntity({this.id, this.createAt, this.name, this.type, this.color});

  factory CategoryEntity.normal() => CategoryEntity(
      id: '', createAt: 0, name: '', type: CategoryType.expense, color: AppColor.primaryColor);

  CategoryModel toModel() =>
      CategoryModel(id: id, createAt: createAt, name: name, type: type, color: color);

  @override
  String toString() {
    return 'CategoryEntity{id: $id, name: $name, type: $type, color: $color}';
  }

  @override
  List<Object?> get props => [id, name, type, color, createAt];
}
