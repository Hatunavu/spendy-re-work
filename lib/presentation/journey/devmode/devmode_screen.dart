import 'package:flutter/material.dart';
import 'package:spendy_re_work/common/constants/route_constants.dart';
import 'package:spendy_re_work/presentation/widgets/base_scaffold/base_scaffold.dart';
import 'package:spendy_re_work/presentation/widgets/button_widget/button_widget.dart';
import 'package:spendy_re_work/presentation/widgets/flare_widgets/alert_flare_widgets/empty_data_widget.dart';
import 'package:spendy_re_work/presentation/widgets/flare_widgets/loader/loader_screen.dart';
import 'package:spendy_re_work/common/extensions/screen_utils_extensions.dart';

class DevModeScreen extends StatelessWidget {
  final _width = 200.w;

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      context,
      appBarTitle: 'Dev Mode',
      body: SafeArea(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ButtonWidget.primary(
                title: 'Transaction List',
                width: _width,
                onPress: () => Navigator.pushNamed(
                  context,
                  RouteList.transactionList,
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              ButtonWidget.primary(
                title: 'Filter',
                width: _width,
                onPress: () => Navigator.pushNamed(
                  context,
                  RouteList.filter,
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              ButtonWidget.primary(
                title: 'Search',
                width: _width,
                onPress: () => Navigator.pushNamed(
                  context,
                  RouteList.search,
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              ButtonWidget.primary(
                title: 'Show Image',
                width: _width,
                onPress: () => Navigator.pushNamed(
                  context,
                  RouteList.showImage,
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              ButtonWidget.primary(
                title: 'Loading Screen',
                width: _width,
                onPress: () => Navigator.push(
                    context, MaterialPageRoute(builder: (_) => LoaderScreen())),
              ),
              const SizedBox(
                height: 8,
              ),
              ButtonWidget.primary(
                title: 'Empty Screen',
                width: _width,
                onPress: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => EmptyDataWidget()),
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              ButtonWidget.primary(
                title: 'Get Start',
                width: _width,
                onPress: () =>
                    Navigator.pushNamed(context, RouteList.createProfile),
              ),
              const SizedBox(
                height: 8,
              ),
              ButtonWidget.primary(
                title: 'Choose currency',
                width: _width,
                onPress: () =>
                    Navigator.pushNamed(context, RouteList.chooseCurrency),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
