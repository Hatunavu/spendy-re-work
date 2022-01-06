import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spendy_re_work/common/constants/icon_constants.dart';
import 'package:spendy_re_work/common/constants/key_constants.dart';
import 'package:spendy_re_work/common/constants/layout_constants.dart';
import 'package:spendy_re_work/common/constants/route_constants.dart';
import 'package:spendy_re_work/common/utils/algorithm/settle_debt_algorithm/model/settle_debt_model.dart';
import 'package:spendy_re_work/domain/entities/category_entity.dart';
import 'package:spendy_re_work/domain/usecases/debt_usecase.dart';
import 'package:spendy_re_work/presentation/journey/transaction/debt/blocs/debt_state.dart';
import 'package:spendy_re_work/presentation/journey/transaction/debt/widgets/debt_item_widget.dart';
import 'package:spendy_re_work/presentation/journey/transaction/debt/widgets/settle_debt_item_widget.dart';
import 'package:spendy_re_work/presentation/journey/transaction/debt/widgets/share_settle_debt_dialog.dart';
import 'package:spendy_re_work/presentation/journey/transaction/transacstion_args_route.dart';
import 'package:spendy_re_work/presentation/theme/theme_color.dart';
import 'package:spendy_re_work/presentation/theme/theme_text.dart';
import 'package:spendy_re_work/presentation/widgets/base_scaffold/base_scaffold.dart';
import 'package:spendy_re_work/presentation/widgets/flare_widgets/alert_flare_widgets/empty_data_widget.dart';
import 'package:spendy_re_work/presentation/widgets/flare_widgets/alert_flare_widgets/error_flare_widget.dart';
import 'package:spendy_re_work/presentation/widgets/skeleton_widget/debts_skeleton_widget.dart';

import 'blocs/debt_bloc.dart';
import 'blocs/debt_event.dart';
import 'debt_constants.dart';

class DebtScreen extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<DebtBloc, DebtState>(builder: (context, state) {
        if (state is DebtFailedState) {
          return FailedFlareWidget(
            callback: () => Navigator.pop(context),
            actionText: 'Back',
          );
        }

        if (state is DebtInitialState) {
          return BaseScaffold(
            context,
            key: _scaffoldKey,
            appBarTitle: DebtConstants.debtText,
            actionAppbar: [
              GestureDetector(
                  onTap: state.shareSettleDebtList.isEmpty
                      ? null
                      : () => _onShareSettleDebt(context,
                          state.shareSettleDebtList, state.categoryEntity),
                  child: Image.asset(
                    IconConstants.uploadIcon,
                    color: state.shareSettleDebtList.isEmpty
                        ? AppColor.hindColor
                        : AppColor.primaryDarkColor,
                  ))
            ],
            body: _body(context, state),
          );
        }

        return DebtsSkeletonWidget();
      }),
    );
  }

  Widget _body(BuildContext context, DebtInitialState state) {
    final mapDebt = state.mapDebt;
    final optimizeDebtsList = state.optimizeDebtsList;
    if (isEmptyData(mapDebt, optimizeDebtsList)) {
      return Center(
          child: EmptyDataWidget(
        marginBottom: true,
      ));
    }
    return SingleChildScrollView(
      padding: const EdgeInsets.only(left: LayoutConstants.paddingHorizontal),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) => DebtItemWidget(
              amount: mapDebt.values.toList()[index].toInt(),
              fullName: mapDebt.keys.toList()[index],
              isLastList: index == mapDebt.length - 1,
            ),
            itemCount: mapDebt.length,
          ),
          Padding(
            padding: const EdgeInsets.only(
                top: LayoutConstants.dimen_14, bottom: LayoutConstants.dimen_3),
            child: Text(
              DebtConstants.settleDebtText,
              style: ThemeText.getDefaultTextTheme().bodyText1!.copyWith(
                  fontSize: DebtConstants.settleDebtFz,
                  fontWeight: FontWeight.bold),
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) => GestureDetector(
              onTap: () => _pushToNewExpense(
                  context, optimizeDebtsList[index], state.categoryEntity),
              child: SettleDebtItemWidget(
                  optimizeDebtsList[index], state.categoryEntity),
            ),
            itemCount: optimizeDebtsList.length,
          ),
        ],
      ),
    );
  }

  Future<void> _pushToNewExpense(BuildContext context,
      SettleDebtModel settleDebt, CategoryEntity debtCate) async {
    final previousRoute = await Navigator.pushNamed(
        context, RouteList.personalExpense,
        arguments: {
          KeyConstants.routeKey: RouteList.debt,
          KeyConstants.createADebtArg: CreateADebtArgument(
              categoryEntity: debtCate, settleDebtModel: settleDebt),
        });
    if (previousRoute == null) {
      BlocProvider.of<DebtBloc>(context).add(DebtInitialEvent());
    }
  }

  bool isEmptyData(
      Map<String, double> mapDebt, List<SettleDebtModel> optimizeDebtsList) {
    if ((mapDebt.isEmpty) && (optimizeDebtsList.isEmpty)) {
      return true;
    }
    return false;
  }

  void _onShareSettleDebt(
      BuildContext buildContext,
      List<ShareSettleDebtEntity> shareSettleDebtList,
      CategoryEntity debtCate) {
    showModalBottomSheet(
        context: buildContext,
        backgroundColor: AppColor.transparent,
        builder: (context) => ShareSettleDebtDialog(
              shareSettleDebtList: shareSettleDebtList,
              categoryEntity: debtCate,
              onApply: (share) => _onApply(buildContext, share),
            ));
  }

  void _onApply(
      BuildContext context, List<ShareSettleDebtEntity> shareSettleDebtList) {
    BlocProvider.of<DebtBloc>(context)
        .add(ShareSettleDebtEvent(shareSettleDebtList));
  }
}
