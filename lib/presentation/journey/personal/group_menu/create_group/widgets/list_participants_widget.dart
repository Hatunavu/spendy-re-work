import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spendy_re_work/common/injector/injector.dart';
import 'package:spendy_re_work/presentation/bloc/authentication_bloc/authentication_bloc.dart';
import 'package:spendy_re_work/presentation/journey/personal/group_menu/create_group/bloc/create_group_cubit.dart';
import 'package:spendy_re_work/presentation/journey/personal/group_menu/create_group/bloc/create_group_state.dart';
import 'package:spendy_re_work/presentation/journey/personal/group_menu/create_group/widgets/item_participants.dart';
import 'package:spendy_re_work/presentation/journey/personal/group_menu/create_group/widgets/add_participants_widget.dart';
import 'package:spendy_re_work/presentation/widgets/keyboard_avoider/keyboard_avoider.dart';
import 'owner_widget.dart';

class ListParticipantsWidget extends StatefulWidget {
  @override
  State<ListParticipantsWidget> createState() => _ListParticipantsWidgetState();
}

class _ListParticipantsWidgetState extends State<ListParticipantsWidget> {
  final user = Injector.resolve<AuthenticationBloc>().userEntity;
  late CreateGroupCubit _createGroupBloc;
  final ScrollController _scrollController = ScrollController();
  final ValueNotifier<bool> _canAddParticipant = ValueNotifier(true);

  @override
  void initState() {
    _createGroupBloc = BlocProvider.of<CreateGroupCubit>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateGroupCubit, CreateGroupState>(
      buildWhen: (pre, current) => pre.participants.length != current.participants.length,
      builder: (context, state) {
        final _participantCount = state.participants.length + 2;
        return KeyboardAvoider(
          autoScroll: true,
          child: ListView.builder(
            controller: _scrollController,
            padding: EdgeInsets.zero,
            itemBuilder: (_, index) {
              if (index == 0) {
                return OwnerWidget(name: user.fullName!);
              } else if (index == _participantCount - 1) {
                return ValueListenableBuilder<bool>(
                  valueListenable: _canAddParticipant,
                  child: AddParticipantsWidget(
                    onTap: () {
                      _createGroupBloc.addParticipant();
                    },
                  ),
                  builder: (_, canAdd, child) {
                    return canAdd ? child! : const SizedBox();
                  },
                );
              } else {
                final _itemIndex = index - 1;
                final participantEntity = state.participants[_itemIndex];
                return ItemParticipantsWidget(
                  key: Key(participantEntity.name),
                  participantEntity: participantEntity,
                  onRemove: () {
                    _createGroupBloc.deleteParticipant(_itemIndex);
                  },
                  onChanged: (value) {
                    _createGroupBloc.updateParticipant(_itemIndex, value);
                  },
                  focusListener: (isFocused) {
                    _canAddParticipant.value = !isFocused;
                  },
                );
              }
            },
            itemCount: _participantCount,
          ),
        );
      },
    );
  }
}
