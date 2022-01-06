import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share/share.dart';
import 'package:spendy_re_work/common/utils/algorithm/settle_debt_algorithm/model/settle_debt_model.dart';
import 'package:spendy_re_work/domain/entities/category_entity.dart';
import 'package:spendy_re_work/domain/entities/user/user_entity.dart';
import 'package:spendy_re_work/domain/usecases/debt_usecase.dart';
import 'package:spendy_re_work/domain/usecases/settle_debt_usecase.dart';
import 'package:spendy_re_work/presentation/bloc/authentication_bloc/authentication_bloc.dart';
import 'package:spendy_re_work/presentation/journey/transaction/debt/blocs/debt_event.dart';

import 'debt_state.dart';

class DebtBloc extends Bloc<DebtEvent, DebtState> {
  final SettleDebtUseCase settleDebtUseCase;
  final DebtUseCase debtUseCase;
  final AuthenticationBloc authenticationBloc;

  Map<String, double>? mapDebt;
  List<SettleDebtModel>? optimizeDebtsList;
  List<ShareSettleDebtEntity>? shareSettleDebtList;
  CategoryEntity? debtCategory;

  DebtBloc(
      {required this.settleDebtUseCase,
      required this.debtUseCase,
      required this.authenticationBloc})
      : super(DebtLoadingState());

  UserEntity? _userEntity;

  @override
  Stream<DebtState> mapEventToState(DebtEvent event) async* {
    _userEntity ??= authenticationBloc.userEntity;

    if (event is DebtInitialEvent) {
      yield* _mapDebtInitialEventToState();
    } else if (event is ShareSettleDebtEvent) {
      yield* _mapShareSettleDebtEventToState(event);
    }
  }

  Stream<DebtState> _mapDebtInitialEventToState() async* {
    yield DebtLoadingState();
    try {
      final allSettleDebt = await settleDebtUseCase.settleAllDebt(
          _userEntity!.uid!, _userEntity!.fullName!);
      // debtCategory = categoriesMock
      //     .where((element) => element.key == _keyDebtCate)
      //     .toList()[0];

      mapDebt = await debtUseCase.getUserTransactionsList(
          allSettleDebt.settleDebtsList, _userEntity!.fullName!);
      optimizeDebtsList = debtUseCase.optimizeDebtsList(
          allSettleDebt.settleDebtsList, mapDebt!, _userEntity!.fullName!);
      shareSettleDebtList =
          debtUseCase.initialShareSettleDebtEntityList(optimizeDebtsList!);
      yield DebtInitialState(
          mapDebt: mapDebt!,
          optimizeDebtsList: optimizeDebtsList!,
          shareSettleDebtList: shareSettleDebtList!,
          categoryEntity: debtCategory!);
    } catch (e) {
      yield DebtFailedState();
    }
  }

  Stream<DebtState> _mapShareSettleDebtEventToState(
      ShareSettleDebtEvent event) async* {
    final String message =
        debtUseCase.createShareMessage(event.shareSettleDebtList);
    await Share.share(message);
    shareSettleDebtList =
        debtUseCase.initialShareSettleDebtEntityList(optimizeDebtsList!);
    yield DebtInitialState(
        mapDebt: mapDebt!,
        optimizeDebtsList: optimizeDebtsList!,
        shareSettleDebtList: shareSettleDebtList!,
        categoryEntity: debtCategory!);
  }
}
