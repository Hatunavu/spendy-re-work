import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:intl/intl.dart';
import 'package:spendy_re_work/common/constants/date_time_constants.dart';

import 'package:spendy_re_work/common/constants/icon_constants.dart';
import 'package:spendy_re_work/common/extensions/date_time_extensions.dart';
import 'package:spendy_re_work/common/injector/injector.dart';
import 'package:spendy_re_work/domain/entities/participant_in_transaction_entity.dart';
import 'package:spendy_re_work/domain/entities/user/user_entity.dart';
import 'package:spendy_re_work/presentation/bloc/authentication_bloc/authentication_bloc.dart';
import 'package:spendy_re_work/presentation/journey/transaction/new_expense/new_expense_constants.dart';
import 'package:spendy_re_work/presentation/journey/transaction/new_expense/personal_expense/button_state.dart';
import 'package:spendy_re_work/presentation/theme/theme_text.dart';
import 'package:spendy_re_work/presentation/widgets/create_form/create_element_form.dart';
import 'package:spendy_re_work/presentation/widgets/text_form_widget/text_form_widget.dart';

import '../../widgets/expense_form_widget.dart';

class ExpenseWidget extends StatelessWidget {
  final TextEditingController? controller;

  final DateTime? expenseDateTime;

  final int? photosCount;

  final ButtonState? isActiveShareSpend;

  final Function()? switchDay;
  final Function()? photoOnTap;
  final Function()? selectDay;
  final Function()? whoPaidOnTap;
  final Function()? forWhoOnTap;
  final Function(String)? onChangeNote;

  final ParticipantInTransactionEntity? currentWhoPaid;
  final ParticipantInTransactionEntity? currentForWho;
  late final UserEntity userEntity;
  ExpenseWidget({
    Key? key,
    this.controller,
    this.currentForWho,
    this.currentWhoPaid,
    this.switchDay,
    this.expenseDateTime,
    this.photoOnTap,
    this.selectDay,
    this.whoPaidOnTap,
    this.forWhoOnTap,
    this.photosCount = 0,
    this.isActiveShareSpend = ButtonState.nonActive,
    this.onChangeNote,
  }) : super(key: key) {
    userEntity = Injector.resolve<AuthenticationBloc>().userEntity;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          top: NewExpenseConstants.newExpensePaddingVertical,
          left: NewExpenseConstants.newExpensePaddingHorizontal),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          CreateElementFormWidget(
            iconPath: IconConstants.noteIcon,
            fittedWhenHasFormOnPress: true,
            showLineTop: true,
            child: TextFormWidget(
              controller: controller!,
              hintText: NewExpenseConstants.noteHintText,
              hintStyle: ThemeText.getDefaultTextTheme()
                  .textHint
                  .copyWith(fontSize: NewExpenseConstants.fzHintText),
              onChange: onChangeNote,
            ),
          ),
          CreateElementFormWidget(
            formOnPressed: selectDay!,
            showLineTop: true,
            iconPath: IconConstants.todayIcon,
            child: ExpenseFormWidget(
              title: title(),
              isHintText: ButtonState.active,
              content: content(),
              onPressContent: switchDay!,
            ),
          ),
          CreateElementFormWidget(
            formOnPressed: photoOnTap!,
            showLineTop: true,
            iconPath: IconConstants.cameraMenuIcon,
            child: ExpenseFormWidget(
              title: NewExpenseConstants.takePhotoTitle,
              isHintText: ButtonState.active,
              content: photosCount! > 0 ? '$photosCount pictures' : '',
            ),
          ),
          CreateElementFormWidget(
            formOnPressed: whoPaidOnTap,
            showLineTop: true,
            fittedWhenHasFormOnPress: true,
            iconPath: IconConstants.whoPaidIcon,
            child: ExpenseFormWidget(
              title: NewExpenseConstants.whoPaidTitle,
              // content: currentWhoPaid.name == _userEntity.fullName
              //     ? 'Me'
              //     : currentWhoPaid.name,
              content: translate('label.me'),
              isHintText: isActiveShareSpend,
            ),
          ),
          CreateElementFormWidget(
            formOnPressed: forWhoOnTap,
            showLineTop: true,
            fittedWhenHasFormOnPress: true,
            iconPath: IconConstants.forWhoIcon,
            child: ExpenseFormWidget(
              title: NewExpenseConstants.forWhoTitle,
              // content: currentForWho.name == _userEntity.fullName
              //     ? 'Me'
              //     : currentForWho.name,
              content: translate('label.me'),
              isHintText: isActiveShareSpend,
            ),
          ),
        ],
      ),
    );
  }

  String title() {
    if (expenseDateTime == DateTime.now().dateTimeYmd) {
      return NewExpenseConstants.categoryTodayTitle;
    } else if (expenseDateTime == DateTime.now().yesterday) {
      return NewExpenseConstants.categoryYesterdayTitle;
    }
    return DateFormat(DateTimeConstants.datePattern).format(expenseDateTime!);
  }

  String content() {
    if (expenseDateTime == DateTime.now().dateTimeYmd) {
      return NewExpenseConstants.categoryYesterdayContent;
    } else if (expenseDateTime == DateTime.now().yesterday) {
      return NewExpenseConstants.categoryTodayContent;
    }
    return '';
  }
}
