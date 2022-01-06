import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:spendy_re_work/common/extensions/screen_utils_extensions.dart';
import 'package:spendy_re_work/presentation/journey/personal/group_menu/create_group/widgets/list_participants_widget.dart';
import 'package:spendy_re_work/presentation/theme/theme_color.dart';
import 'package:spendy_re_work/presentation/theme/theme_text.dart';

class ParticipantsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(translate('group.participants'),
            style: ThemeText.getDefaultTextTheme().hint.copyWith(
                  fontSize: 17.sp,
                  color: AppColor.lightPurple,
                )),
        SizedBox(height: 12.h),
        SizedBox(
          height: 450.h,
          child: ListParticipantsWidget(),
        ),
      ],
    );
  }
}
