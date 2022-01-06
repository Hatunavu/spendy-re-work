import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:spendy_re_work/common/constants/route_constants.dart';
import 'package:spendy_re_work/presentation/journey/personal/group_menu/bloc/group_bloc.dart';
import 'package:spendy_re_work/presentation/journey/personal/group_menu/bloc/group_event.dart';
import 'package:spendy_re_work/presentation/journey/personal/group_menu/bloc/group_state.dart';
import 'package:spendy_re_work/presentation/journey/personal/group_menu/widgets/item_group.dart';
import 'package:spendy_re_work/presentation/widgets/dialogs/loader_dialog/loader_wallet_dialog.dart';

class BodyGroupScreen extends StatefulWidget {
  const BodyGroupScreen({Key? key}) : super(key: key);

  @override
  State<BodyGroupScreen> createState() => _BodyGroupScreenState();
}

class _BodyGroupScreenState extends State<BodyGroupScreen> {
  late GroupBloc _groupBloc;
  late final SlidableController slidableController = SlidableController();
  @override
  void initState() {
    _groupBloc = BlocProvider.of<GroupBloc>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GroupBloc, GroupState>(
      buildWhen: (previousState, currentState) =>
          previousState is GroupLoadingState && currentState is GroupUpdateState,
      listener: (context, state) {
        if (state is GroupLoadingState) {
          LoaderWalletDialog.getInstance().show(context);
        } else {
          LoaderWalletDialog.getInstance().hide(context);
        }
      },
      builder: (context, state) {
        final _groups = [];
        if (state is GroupUpdateState) {
          _groups.addAll(state.groups);
        }
        return ListView.builder(
          padding: EdgeInsets.zero,
          itemBuilder: (_, index) {
            final _group = _groups[index];
            return ItemGroup(
              slidableController: slidableController,
              groupEntity: _group,
              onDelete: () {
                _groupBloc.add(GroupDeleteEvent(id: _group.id));
                Navigator.pop(context);
              },
              onEdit: () {
                Navigator.pushNamed(context, RouteList.createGroup, arguments: {
                  'groupId': _group.id ?? '',
                  'group': _group,
                });
              },
            );
          },
          itemCount: _groups.length,
        );
      },
    );
  }
}
