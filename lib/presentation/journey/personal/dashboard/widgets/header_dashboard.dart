import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:spendy_re_work/common/constants/icon_constants.dart';
import 'package:spendy_re_work/common/constants/layout_constants.dart';
import 'package:spendy_re_work/common/constants/route_constants.dart';
import 'package:spendy_re_work/common/extensions/string_extensions.dart';
import 'package:spendy_re_work/common/injector/injector.dart';
import 'package:spendy_re_work/common/utils/permission_helpers.dart';
import 'package:spendy_re_work/domain/entities/user/user_entity.dart';
import 'package:spendy_re_work/presentation/bloc/authentication_bloc/authentication_bloc.dart';
import 'package:spendy_re_work/presentation/bloc/avatar_bloc/avatar_bloc.dart';
import 'package:spendy_re_work/presentation/bloc/avatar_bloc/avatar_event.dart';
import 'package:spendy_re_work/presentation/bloc/avatar_bloc/avatar_state.dart';
import 'package:spendy_re_work/presentation/journey/login/profile/profile_constants.dart';
import 'package:spendy_re_work/presentation/journey/personal/dashboard/personal_page_constants.dart';
import 'package:spendy_re_work/presentation/journey/transaction/blocs/transaction_blocs/transaction_bloc.dart';
import 'package:spendy_re_work/presentation/journey/transaction/blocs/transaction_blocs/transaction_event.dart';
import 'package:spendy_re_work/presentation/theme/theme_color.dart';
import 'package:spendy_re_work/presentation/theme/theme_text.dart';
import 'package:spendy_re_work/presentation/widgets/add_photos_bottom_sheet/add_photos_bottom_sheet.dart';
import 'package:spendy_re_work/presentation/widgets/avatar/avatar_widget.dart';
import 'package:spendy_re_work/presentation/widgets/button_widget/button_widget.dart';
import 'package:spendy_re_work/presentation/widgets/dialogs/logout_dialog/logout_dialog.dart';
import 'package:spendy_re_work/common/extensions/screen_utils_extensions.dart';

class HeaderDashboard extends StatefulWidget {
  HeaderDashboard({
    Key? key,
  }) : super(
          key: key,
        );

  @override
  State<HeaderDashboard> createState() => _HeaderDashboardState();
}

class _HeaderDashboardState extends State<HeaderDashboard> {
  late UserEntity _userEntity;
  late AvatarBloc _avatarBloc;
  late TransactionBloc _transactionBloc;
  String avatar = '';

  @override
  void initState() {
    _userEntity = Injector.resolve<AuthenticationBloc>().userEntity;
    _avatarBloc = Injector.resolve<AvatarBloc>();
    _transactionBloc = Injector.resolve<TransactionBloc>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: 20.h,
        left: PersonalPageConstants.paddingLeft,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BlocProvider<AvatarBloc>(
            create: (_) => _avatarBloc..add(LoaderAvatarEvent(_userEntity.avatar ?? '')),
            child: BlocBuilder<AvatarBloc, AvatarState>(builder: (context, state) {
              if (state is LoaderAvatarState) {
                avatar = state.avatar.uri!;
              }
              return AvatarWidget(
                avatarUrl: avatar,
                isUploadAvatar: state is LoadingAvatarState,
                onPressed: () => _uploadAvatar(context),
                shortenedName: _userEntity.fullName!.shortenedName,
              );
            }),
          ),
          SizedBox(
            width: PersonalPageConstants.avatarPaddingRight,
          ),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _userEntity.fullName?.trim() ?? _userEntity.phoneNumber!.trim(),
                          style: ThemeText.getDefaultTextTheme()
                              .subtitle1!
                              .copyWith(fontSize: PersonalPageConstants.fzName),
                        ),
                        Text(
                          _userEntity.phoneNumber ?? '',
                          style: ThemeText.getDefaultTextTheme().subtitle2!.copyWith(
                                fontSize: PersonalPageConstants.fzPhone,
                              ),
                        ),
                      ],
                    ),
                    ButtonWidget.primary(
                      color: AppColor.lightPurple,
                      onPress: () {
                        Navigator.pushNamed(context, RouteList.payments);
                      },
                      textSize: 15.sp,
                      title: translate('content_payments.free'),
                      width: 70.w,
                      height: 29.h,
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () => _logOut(context),
                  child: Container(
                      padding: EdgeInsets.only(
                        right: PersonalPageConstants.paddingLeft,
                      ),
                      color: AppColor.white,
                      height: 40.h,
                      alignment: Alignment.topRight,
                      child: Image.asset(IconConstants.logoutIcon)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _logOut(BuildContext context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (dialogContext) => LogoutDialogWidget(
              onPressedNo: () => Navigator.pop(dialogContext),
              onPressedYes: () {
                _transactionBloc.add(ClearTransactionEvent());
              },
            ));
  }

  void _uploadAvatar(BuildContext avatarContext) {
    showModalBottomSheet(
      context: avatarContext,
      backgroundColor: AppColor.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(LayoutConstants.roundedRadius),
      ),
      builder: (context) => AddPhotosBottomSheet(
        title: ProfileConstants.avatarText,
        photosOnTap: () => _photosOnTap(avatarContext),
        cameraOnTap: () => _cameraOnTap(avatarContext),
      ),
    );
  }

  Future<void> _photosOnTap(BuildContext context) async {
    final _isGranted = await PermissionHelpers.requestPhotoPermission(context);
    if (_isGranted) {
      _avatarBloc.add(OpenGalleryEvent());
    }
  }

  Future<void> _cameraOnTap(BuildContext context) async {
    final _isGranted = await PermissionHelpers.requestCameraPermission(context);
    if (_isGranted) {
      _avatarBloc.add(OpenCameraEvent());
    }
  }
}
