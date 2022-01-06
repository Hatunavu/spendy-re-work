import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:spendy_re_work/common/constants/icon_constants.dart';
import 'package:spendy_re_work/presentation/theme/theme_color.dart';
import 'package:spendy_re_work/presentation/theme/theme_text.dart';
import 'package:spendy_re_work/common/extensions/screen_utils_extensions.dart';
import 'avatar_widget_constants.dart';

class AvatarWidget extends StatelessWidget {
  final Function()? onPressed;
  final bool? isUploadAvatar;
  final String? avatarUrl;
  final String? shortenedName;

  AvatarWidget(
      {Key? key,
      required this.onPressed,
      this.isUploadAvatar = false,
      this.shortenedName = '',
      required this.avatarUrl})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final avatar = Container(
        height: AvatarWidgetConstants.sizeAvatar,
        width: AvatarWidgetConstants.sizeAvatar,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
        ),
        child: _imageAvatar());

    return GestureDetector(
      onTap: onPressed,
      child: Stack(
        children: [
          avatar,
          Positioned(
            bottom: -2.h,
            right: -2.w,
            child: CircleAvatar(
              maxRadius: 15.sp,
              backgroundColor: AppColor.white,
              child: Container(
                height: AvatarWidgetConstants.sizeContainerIcon,
                width: AvatarWidgetConstants.sizeContainerIcon,
                decoration: const BoxDecoration(
                  color: AppColor.lightPurple,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: SvgPicture.asset(
                  IconConstants.cameraAvatar,
                  width: 12.w,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _imageAvatar() {
    if (isUploadAvatar!) {
      return Container(
        height: AvatarWidgetConstants.sizeAvatar,
        width: AvatarWidgetConstants.sizeAvatar,
        decoration: const BoxDecoration(
          color: AvatarWidgetConstants.backgroundAvatar,
          shape: BoxShape.circle,
        ),
        padding: EdgeInsets.all(AvatarWidgetConstants.loadingAvatarPadding),
        child: const CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(AppColor.primaryColor),
        ),
      );
    } else {
      if (avatarUrl!.isNotEmpty) {
        return Container(
          height: AvatarWidgetConstants.sizeAvatar,
          width: AvatarWidgetConstants.sizeAvatar,
          decoration: const BoxDecoration(
            color: AvatarWidgetConstants.backgroundAvatar,
            shape: BoxShape.circle,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: CachedNetworkImage(
              imageUrl: avatarUrl!,
              height: AvatarWidgetConstants.sizeAvatar,
              width: AvatarWidgetConstants.sizeAvatar,
              fit: BoxFit.cover,
              placeholder: (context, url) => Padding(
                padding:
                    EdgeInsets.all(AvatarWidgetConstants.loadingAvatarPadding),
                child: const CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor:
                      AlwaysStoppedAnimation<Color>(AppColor.primaryColor),
                ),
              ),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
          ),
        );
      } else if (shortenedName!.isNotEmpty) {
        return Container(
          height: AvatarWidgetConstants.sizeAvatar,
          width: AvatarWidgetConstants.sizeAvatar,
          decoration: const BoxDecoration(
            color: AppColor.primaryColor,
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Text(
            shortenedName!,
            style: ThemeText.getDefaultTextTheme()
                .subtitle1!
                .copyWith(color: AppColor.white),
          ),
        );
      } else {
        return Container(
          height: AvatarWidgetConstants.sizeAvatar,
          width: AvatarWidgetConstants.sizeAvatar,
          decoration: const BoxDecoration(
            color: AvatarWidgetConstants.backgroundAvatar,
            shape: BoxShape.circle,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: Image.asset(IconConstants.avatarIcon),
          ),
        );
      }
    }
  }
}
