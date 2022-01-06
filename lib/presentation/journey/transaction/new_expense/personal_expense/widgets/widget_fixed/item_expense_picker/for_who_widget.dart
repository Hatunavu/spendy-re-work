import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spendy_re_work/common/constants/key_constants.dart';
import 'package:spendy_re_work/common/constants/route_constants.dart';
import 'package:spendy_re_work/common/extensions/screen_utils_extensions.dart';
import 'package:spendy_re_work/domain/entities/user/group_entity.dart';
import 'package:spendy_re_work/presentation/journey/transaction/new_expense/new_expense_constants.dart';
import 'package:spendy_re_work/presentation/journey/transaction/new_expense/personal_expense/cubit/for_who_bloc/for_who_bloc.dart';
import 'package:spendy_re_work/presentation/journey/transaction/new_expense/personal_expense/cubit/for_who_bloc/for_who_state.dart';
import 'package:spendy_re_work/presentation/journey/transaction/new_expense/personal_expense/widgets/widget_fixed/item_expense_picker/transaction_participant_list_widget.dart';

class ForWhoWidget extends StatefulWidget {
  const ForWhoWidget({Key? key}) : super(key: key);

  @override
  State<ForWhoWidget> createState() => _ForWhoWidgetState();
}

class _ForWhoWidgetState extends State<ForWhoWidget> {
  late ForWhoBloc _forWhoBloc;
  @override
  void initState() {
    _forWhoBloc = BlocProvider.of<ForWhoBloc>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final paddingBottom = MediaQuery.of(context).padding.bottom;
    return BlocListener<ForWhoBloc, ForWhoState>(
      listener: (context, state) {
        if (state.status == ForWhoStatus.success) {
          Navigator.pop(context, state.forWhoParticipant);
        }
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.w)
            .copyWith(bottom: paddingBottom + 18.h, top: 20.h),
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.6,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(NewExpenseConstants.whoPaidTitle,
                      style: TextStyle(
                          color: const Color(0xff3A385A),
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w700)),
                  GestureDetector(
                    onTap: () {},
                    child: Text(NewExpenseConstants.shareSpendDeselectAllTitle,
                        style: TextStyle(
                          color: const Color(0xff7077EA),
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w400,
                        )),
                  )
                ],
              ),
              SizedBox(height: 15.h),
              Expanded(
                child: BlocBuilder<ForWhoBloc, ForWhoState>(
                    builder: (context, state) {
                  return TransactionListParticipantListWIdget(
                    participants: state.participants,
                    currency: state.currency!,
                    countItem: state.participants.length + 1,
                    onSelectParticipant: _onSelectParticipant,
                    onSave: _onSave,
                    editMoney: _editMoneyOfPaticipant,
                    addMoreParticipant: () => _addMoreParticipant(state.group),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _addMoreParticipant(GroupEntity? group) {
    if (group != null) {
      Navigator.pushNamed(context, RouteList.createGroup,
          arguments: {KeyConstants.groupKey: group});
    }
  }

  void _onSave() {
    _forWhoBloc.onSaveForWho();
  }

  void _onSelectParticipant(int value) {
    _forWhoBloc.onSelectAParticipant(value);
  }

  void _editMoneyOfPaticipant(int money, int participantIndex) {
    _forWhoBloc.editParticipantMoney(money, participantIndex);
  }
}
