import 'package:spendy_re_work/common/utils/algorithm/settle_debt_algorithm/model/settle_debt_model.dart';
import 'package:spendy_re_work/domain/entities/category_entity.dart';

class CreateADebtArgument {
  SettleDebtModel? settleDebtModel;
  CategoryEntity? categoryEntity;

  CreateADebtArgument({this.categoryEntity, this.settleDebtModel});
}
