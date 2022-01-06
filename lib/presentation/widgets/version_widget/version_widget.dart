import 'package:flutter/material.dart';
import 'package:spendy_re_work/presentation/theme/theme_text.dart';
import 'package:spendy_re_work/presentation/widgets/version_widget/version_constants.dart';

class VersionInfoWidget extends StatefulWidget {
  @override
  _VersionInfoWidgetState createState() => _VersionInfoWidgetState();
}

class _VersionInfoWidgetState extends State<VersionInfoWidget> {
  String? _version;
  @override
  void initState() {
    VersionConstants.getVersion().then((value) {
      setState(() {
        _version = '${VersionConstants.textVersion} $value';
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _version ?? VersionConstants.defaultVersion,
      style: ThemeText.getDefaultTextTheme().textHint.copyWith(
          fontSize: VersionConstants.fzVersion, fontWeight: FontWeight.normal),
    );
  }
}
