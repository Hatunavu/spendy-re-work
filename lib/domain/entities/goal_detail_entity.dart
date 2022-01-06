import 'package:spendy_re_work/domain/entities/category_entity.dart';
import 'package:spendy_re_work/domain/entities/goal_entity.dart';

class GoalDetailEntity {
  CategoryEntity categoryEntity;
  GoalEntity goalEntity;

  GoalDetailEntity(this.categoryEntity, this.goalEntity);
}
