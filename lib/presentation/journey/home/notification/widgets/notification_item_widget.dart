import 'package:flutter/material.dart';
import 'package:spendy_re_work/common/constants/category_name_map.dart';
import 'package:spendy_re_work/common/enums/notification_enum/notification_type.dart';
import 'package:spendy_re_work/domain/entities/notifications/notification_entity.dart';

import 'package:spendy_re_work/presentation/theme/theme_color.dart';
import 'package:spendy_re_work/presentation/theme/theme_text.dart';
import 'package:spendy_re_work/common/extensions/num_extensions.dart';
import 'package:spendy_re_work/presentation/widgets/highlight_text.dart';
import '../notification_constants.dart';

class NotiItemWidget extends StatelessWidget {
  final NotificationEntity? notificationEntity;
  final Function() onPressed;

  const NotiItemWidget(
      {Key? key, this.notificationEntity, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Padding(
        padding: EdgeInsets.only(top: NotificationConstants.height8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: NotificationConstants.height18,
              alignment: Alignment.center,
              child: notificationEntity!.isRead!
                  ? SizedBox(
                      width: NotificationConstants.iconsSize,
                    )
                  : Icon(
                      Icons.circle,
                      size: NotificationConstants.iconsSize,
                      color: AppColor.iconColorPrimary,
                    ),
            ),
            SizedBox(
              width: NotificationConstants.wight5,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  (NotificationTypeEnum()
                              .getTypeByName(notificationEntity!.type!) ==
                          NotiType.system)
                      ? _buildSystemMessage()
                      : _buildMessage(),
                  SizedBox(
                    height: NotificationConstants.height5,
                  ),
                  _notiTimer(),
                  SizedBox(
                    height: NotificationConstants.height10,
                  ),
                  const Divider(
                    color: AppColor.lineColor,
                    thickness: 1,
                    height: 0,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSystemMessage() {
    return Text(
      notificationEntity!.message!,
      style: ThemeText.getDefaultTextTheme().caption,
    );
  }

  Widget _buildMessage() {
    return HighlightText(
      text: NotificationTypeEnum().getMessage(
          NotificationTypeEnum().getTypeByName(notificationEntity!.type!),
          [CategoryCommon.categoryNameMap[notificationEntity?.key]!]),
      highlights: [CategoryCommon.categoryNameMap[notificationEntity?.key]!],
      highlightStyle: ThemeText.getDefaultTextTheme().caption?.copyWith(
            fontWeight: FontWeight.bold,
          ),
      normalStyle: ThemeText.getDefaultTextTheme().caption,
      color: AppColor.transparent,
    );
  }

  Widget _notiTimer() {
    return Text(
      '${notificationEntity?.showtime?.timerNotification}',
      style: ThemeText.getDefaultTextTheme().overline,
    );
  }
}
