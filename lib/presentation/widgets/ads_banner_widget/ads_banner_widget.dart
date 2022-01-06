import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:spendy_re_work/common/utils/admob_utils.dart';

class AdsBannerWidget extends StatefulWidget {
  @override
  _AdsBannerWidgetState createState() => _AdsBannerWidgetState();
}

class _AdsBannerWidgetState extends State<AdsBannerWidget> {
  late BannerAd _bannerAd;

  @override
  void initState() {
    _bannerAd = BannerAd(
        size: AdSize.banner,
        adUnitId: AdmobUtils.bannerId,
        listener: const BannerAdListener(),
        request: const AdRequest());
    _bannerAd.load();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _bannerAd.size.width.toDouble(),
      height: _bannerAd.size.height.toDouble(),
      alignment: Alignment.center,
      child: AdWidget(ad: _bannerAd),
    );
  }
}
