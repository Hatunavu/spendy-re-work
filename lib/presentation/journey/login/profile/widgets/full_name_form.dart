import 'package:flutter/material.dart';
import 'package:spendy_re_work/presentation/journey/login/login_constants.dart';
import 'package:spendy_re_work/presentation/journey/login/profile/profile_constants.dart';
import 'package:spendy_re_work/presentation/theme/theme_text.dart';
import 'package:spendy_re_work/presentation/widgets/avatar/avatar_widget.dart';
import 'package:spendy_re_work/presentation/widgets/text_form_widget/text_form_widget.dart';

class FullNameForm extends StatelessWidget {
  final TextEditingController controller;
  final String? avatarUrl;
  final Function(String) onChanged;
  final Function() updateAvatar;
  final bool isUploadAvatar;

  FullNameForm({
    Key? key,
    required this.controller,
    required this.onChanged,
    required this.updateAvatar,
    this.avatarUrl,
    this.isUploadAvatar = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.symmetric(horizontal: LoginConstants.paddingHorizontal),
      child: Column(
        children: [
          AvatarWidget(
            onPressed: updateAvatar,
            isUploadAvatar: isUploadAvatar,
            avatarUrl: avatarUrl,
          ),
          SizedBox(
            height: ProfileConstants.formPaddingTop,
          ),
          SizedBox(
              width: double.infinity,
              child: TextFormWidget(
                controller: controller,
                textAlign: TextAlign.center,
                hintText: ProfileConstants.nameHintText,
                hintStyle: ThemeText.getDefaultTextTheme().textHint.copyWith(
                      fontSize: LoginConstants.fzHintField,
                    ),
                onChange: onChanged,
              )),
          const Padding(
            padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
            child: Divider(
              color: Color(0xFF000000),
              thickness: 0.3,
              height: 0,
            ),
          ),
        ],
      ),
    );
  }
}
