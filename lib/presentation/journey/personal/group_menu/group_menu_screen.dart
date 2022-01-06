import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:spendy_re_work/common/constants/icon_constants.dart';
import 'package:spendy_re_work/common/constants/route_constants.dart';
import 'package:spendy_re_work/common/extensions/screen_utils_extensions.dart';
import 'package:spendy_re_work/presentation/journey/personal/group_menu/widgets/body_group_screen.dart';
import 'package:spendy_re_work/presentation/theme/theme_color.dart';
import 'package:spendy_re_work/presentation/widgets/appbar/primary_appbar.dart';

class GroupMenuScreen extends StatelessWidget {
  const GroupMenuScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarNormalWidget(
        title: translate('group.groups'),
        onAction: () {
          Navigator.pushNamed(context, RouteList.createGroup);
        },
        action: Center(
          child: SvgPicture.asset(
            IconConstants.icAdd,
            width: 24.w,
            height: 24.w,
          ),
        ),
        leading: Image.asset(
          IconConstants.backIcon,
          width: 18.w,
          color: AppColor.iconColor,
        ),
      ),
      body: const BodyGroupScreen(),
    );
  }
}
