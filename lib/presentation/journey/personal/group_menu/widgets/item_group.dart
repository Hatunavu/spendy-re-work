import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:spendy_re_work/common/constants/icon_constants.dart';
import 'package:spendy_re_work/common/extensions/screen_utils_extensions.dart';
import 'package:spendy_re_work/domain/entities/user/group_entity.dart';
import 'package:spendy_re_work/presentation/journey/personal/group_menu/widgets/decoration_group.dart';
import 'package:spendy_re_work/presentation/journey/personal/group_menu/widgets/delete_dialog.dart';

class ItemGroup extends StatelessWidget {
  const ItemGroup(
      {Key? key,
      required this.onEdit,
      required this.groupEntity,
      required this.onDelete,
      required this.slidableController})
      : super(key: key);

  final Function() onEdit;
  final Function() onDelete;
  final GroupEntity groupEntity;
  final SlidableController slidableController;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 22.w).copyWith(top: 16.h),
      child: Slidable(
          controller: slidableController,
          key: Key(groupEntity.name),
          actionPane: const SlidableDrawerActionPane(),
          actionExtentRatio: 0.11,
          secondaryActions: groupEntity.isDefault
              ? []
              : [
                  GestureDetector(
                    onTap: () {
                      slidableController.activeState?.close();
                      onEdit();
                    },
                    child: Padding(
                      padding: EdgeInsets.only(left: 10.w),
                      child: Image.asset(
                        IconConstants.editIcon,
                        width: 45.h,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      slidableController.activeState?.close();
                      _deleteGroup(context);
                    },
                    child: Padding(
                      padding: EdgeInsets.only(left: 10.w),
                      child: SvgPicture.asset(IconConstants.icRemoveWithBackground,
                          width: 24.w, height: 24.w),
                    ),
                  )
                ],
          child: Builder(
            builder: (context) => GestureDetector(
              onTap: () {
                final slidable = Slidable.of(context);
                final closed = slidable?.renderingMode == SlidableRenderingMode.none;
                if (!closed) {
                  slidable?.close();
                }
              },
              child: DecorationGroup(
                nameGroup: groupEntity.name,
                countParticipants: (groupEntity.isDefault) ? 0 : groupEntity.countParticipants ?? 1,
              ),
            ),
          )),
    );
  }

  void _deleteGroup(BuildContext context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (dialogContext) => DeleteGroupDialog(
            nameGroup: groupEntity.name,
            cancelAction: () => Navigator.pop(dialogContext),
            deleteAction: onDelete));
  }
}
