import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spendy_re_work/common/constants/layout_constants.dart';
import 'package:spendy_re_work/common/constants/route_constants.dart';
import 'package:spendy_re_work/common/enums/data_state.dart';
import 'package:spendy_re_work/common/utils/permission_helpers.dart';
import 'package:spendy_re_work/presentation/journey/login/login_constants.dart';
import 'package:spendy_re_work/presentation/journey/login/profile/bloc/profile_bloc.dart';
import 'package:spendy_re_work/presentation/journey/login/profile/profile_constants.dart';
import 'package:spendy_re_work/presentation/journey/login/profile/widgets/full_name_form.dart';
import 'package:spendy_re_work/presentation/journey/login/profile/widgets/get_start_button.dart';
import 'package:spendy_re_work/presentation/theme/theme_color.dart';
import 'package:spendy_re_work/presentation/widgets/add_photos_bottom_sheet/add_photos_bottom_sheet.dart';
import 'package:spendy_re_work/presentation/widgets/background_logo_widget/background_logo_widget.dart';
import 'package:spendy_re_work/presentation/widgets/flare_widgets/loader/loader_screen.dart';

import 'bloc/profile_event.dart';
import 'bloc/profile_state.dart';
import 'widgets/header_widget.dart';

class CreateProfileScreen extends StatefulWidget {
  @override
  State<CreateProfileScreen> createState() => _CreateProfileScreenState();
}

class _CreateProfileScreenState extends State<CreateProfileScreen> {
  final TextEditingController nameController = TextEditingController();
  late ProfileBloc _profileBloc;
  @override
  void initState() {
    _profileBloc = BlocProvider.of<ProfileBloc>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<ProfileBloc, ProfileState>(listener: (context, state) {
        if (state is ProfileInitialState) {
          _pushToScreen(context, state.dataState);
        }
      }, builder: (context, state) {
        return Stack(
          children: [
            BackgroundLogoWidget(
              child: _body(context, state),
            ),
            Visibility(
                visible: state is ProfileInitialState && state.dataState == DataState.loading,
                child: LoaderScreen(
                  textColor: AppColor.white,
                ))
          ],
        );
      }),
    );
  }

  Widget _body(BuildContext context, ProfileState state) {
    if (state is ProfileInitialState || state is UploadImageState || state is UpdateProfileState) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          HeaderWidget(),
          SizedBox(
            height: ProfileConstants.formPaddingTop30,
          ),
          FullNameForm(
            controller: nameController,
            onChanged: (value) => _onChanged(context, value),
            updateAvatar: () => _showAddPhotoBottomSheet(context),
            isUploadAvatar: state is UploadImageState,
            avatarUrl: avatarUri(state),
          ),
          SizedBox(
            height: LoginConstants.btnLoginPaddingTop,
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: GetStartButton(
              onPressed: () => _onPressed(context, state.isActive!),
              isActive: state.isActive!,
            ),
          ),
        ],
      );
    } else {
      return const SizedBox();
    }
  }

  void _showAddPhotoBottomSheet(BuildContext buildContext) {
    FocusScope.of(buildContext).requestFocus(FocusNode());
    showModalBottomSheet(
        context: buildContext,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(LayoutConstants.roundedRadius),
        ),
        builder: (context) => AddPhotosBottomSheet(
              photosOnTap: () => _photosOnTap(buildContext),
              cameraOnTap: () => _cameraOnTap(buildContext),
              title: ProfileConstants.avatarText,
            ));
  }

  Future<void> _photosOnTap(BuildContext context) async {
    final _isGranted = await PermissionHelpers.requestPhotoPermission(context);
    if (_isGranted) {
      _profileBloc.add(OpenGalleryEvent());
    }
  }

  Future<void> _cameraOnTap(BuildContext context) async {
    final _isGranted = await PermissionHelpers.requestCameraPermission(context);
    if (_isGranted) {
      _profileBloc.add(OpenCameraEvent());
    }
  }

  void _onPressed(BuildContext context, bool isActive) {
    if (isActive) {
      _profileBloc.add(UpdateProfileEvent(fullName: nameController.text));
    }
  }

  void _onChanged(BuildContext context, String value) {
    _profileBloc.add(TypingNameEvent(value));
  }

  void _pushToScreen(BuildContext context, DataState? dataState) {
    if (dataState == DataState.success) {
      Navigator.pushNamed(context, RouteList.chooseCurrency);
    }
  }

  String avatarUri(ProfileState state) {
    if (state is ProfileInitialState) {
      if (state.avatar != null) {
        return state.avatar!.uri ?? '';
      }
    }
    return '';
  }
}
