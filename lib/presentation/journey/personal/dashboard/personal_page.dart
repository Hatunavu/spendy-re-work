import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spendy_re_work/common/extensions/screen_utils_extensions.dart';
import 'package:spendy_re_work/common/constants/route_constants.dart';
import 'package:spendy_re_work/common/injector/injector.dart';
import 'package:spendy_re_work/presentation/bloc/authentication_bloc/authentication_bloc.dart';
import 'package:spendy_re_work/presentation/journey/home/home_screen_constants.dart';
import 'package:spendy_re_work/presentation/journey/personal/dashboard/widgets/header_dashboard.dart';
import 'package:spendy_re_work/presentation/journey/personal/dashboard/widgets/item_dashboard.dart';
import 'package:spendy_re_work/presentation/journey/personal/group_menu/bloc/group_bloc.dart';
import 'package:spendy_re_work/presentation/journey/personal/group_menu/bloc/group_event.dart';
import 'package:spendy_re_work/presentation/widgets/version_widget/version_widget.dart';

class PersonalPage extends StatefulWidget {
  @override
  _PersonalPageState createState() => _PersonalPageState();
}

class _PersonalPageState extends State<PersonalPage> {
  @override
  void initState() {
    Injector.resolve<GroupBloc>().add(GroupInitEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) {
        if (state is UnAuthenticated) {
          Navigator.pushReplacementNamed(context, RouteList.loginPhone);
        }
      },
      child: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              HeaderDashboard(),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 30.h),
                child: MenuPersonal(),
              ),
              VersionInfoWidget(),
              SizedBox(
                height: HomeScreenConstants.pagePaddingBottom,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
