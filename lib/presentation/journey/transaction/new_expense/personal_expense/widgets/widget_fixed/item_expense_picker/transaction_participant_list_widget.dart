import 'package:flutter/cupertino.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:spendy_re_work/common/extensions/screen_utils_extensions.dart';
import 'package:spendy_re_work/domain/entities/currency_entity.dart';
import 'package:spendy_re_work/domain/entities/participant_in_transaction_entity.dart';
import 'package:spendy_re_work/presentation/journey/personal/group_menu/create_group/widgets/add_participants_widget.dart';
import 'package:spendy_re_work/presentation/journey/transaction/new_expense/personal_expense/widgets/widget_fixed/item_widget/item_check_box_participants_widget.dart';
import 'package:spendy_re_work/presentation/theme/theme_color.dart';
import 'package:spendy_re_work/presentation/widgets/button_widget/button_widget.dart';
import 'package:spendy_re_work/presentation/widgets/keyboard_avoider/keyboard_avoider.dart';
import 'package:spendy_re_work/presentation/widgets/state_widget/empty_data_widget.dart';
import 'package:spendy_re_work/common/extensions/num_extensions.dart';

class TransactionListParticipantListWIdget extends StatelessWidget {
  final List<ParticipantInTransactionEntity> participants;
  final int countItem;
  final CurrencyEntity currency;
  final Function(int) onSelectParticipant;
  final Function()? onSave;
  final Function(int, int) editMoney;
  final Function() addMoreParticipant;
  const TransactionListParticipantListWIdget(
      {Key? key,
      required this.participants,
      required this.countItem,
      required this.currency,
      required this.onSelectParticipant,
      required this.editMoney,
      required this.addMoreParticipant,
      this.onSave})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (participants.isEmpty) {
      return ShowEmptyDataWidget(
        title: translate('group.choose_group'),
      );
    } else {
      return Column(
        children: [
          Expanded(
            child: KeyboardAvoider(
              autoScroll: true,
              child: ListView.builder(
                  controller: ScrollController(),
                  padding: EdgeInsets.zero,
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    if (index == countItem - 1) {
                      return AddParticipantsWidget(onTap: addMoreParticipant);
                    } else {
                      final participant = participants[index];
                      return ItemCheckBoxParticipantsWidget(
                        money:
                            '${(participant.amount)?.formatSimpleCurrency()} ${currency.code}',
                        currency: currency,
                        editMoney: (value) => editMoney(value, index),
                        isChecked: participant.amount != null,
                        onChecked: () => onSelectParticipant(index),
                        name: participant.name,
                      );
                    }
                  },
                  itemCount: countItem),
            ),
          ),
          SizedBox(height: 15.h),
          ButtonWidget.primary(
            color: AppColor.lightPurple,
            width: double.infinity,
            title: translate('label.save'),
            onPress: onSave,
          ),
        ],
      );
    }
  }
}
