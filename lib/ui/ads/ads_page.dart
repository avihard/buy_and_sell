import 'dart:io';

import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterbuyandsell/constant/ps_constants.dart';

class AdsPage extends StatefulWidget {
  @override
  _AdsPageState createState() => _AdsPageState();
}

class _AdsPageState extends State<AdsPage> {
  AdmobReward rewardAd;
  bool firstTime = false;
  bool secondTime = false;
  bool ThirdTime = false;
  int count = 0;

  String getRewardAdUnitId() {
    if (Platform.isIOS) {
      return 'ca-app-pub-2833757144977487/3003901279';
    } else if (Platform.isAndroid) {
      return 'ca-app-pub-2833757144977487/5976144002';
    }
    return null;
  }

  @override
  void initState() {
    rewardAd = AdmobReward(
      adUnitId: getRewardAdUnitId(),
      listener: (AdmobAdEvent event, Map<String, dynamic> args) {
        if (event == AdmobAdEvent.closed) rewardAd.load();
      },
    );
    rewardAd.load();
    PsConst.count++;
    (PsConst.count % 3 == 0) ? rewardAd.show() : null;
    super.initState();
  }

  String getBannerAdUnitId() {
    if (Platform.isIOS) {
      return 'ca-app-pub-2833757144977487/3003901279';
    } else if (Platform.isAndroid) {
      return 'ca-app-pub-2833757144977487/3003901279';
    }
    return null;
  }

  String getBannerAdUnitId2() {
    if (Platform.isIOS) {
      return 'ca-app-pub-2833757144977487/3003901279';
    } else if (Platform.isAndroid) {
      return 'ca-app-pub-2833757144977487/6958430485';
    }
    return null;
  }

  String getBannerAdUnitId3() {
    if (Platform.isIOS) {
      return 'ca-app-pub-2833757144977487/3003901279';
    } else if (Platform.isAndroid) {
      return 'ca-app-pub-2833757144977487/3344836143';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
        body: SingleChildScrollView(
      child: Stack(
        children: [
          Column(
            children: [
              Container(
                height: height / 4,
                width: width - 16,
                child: AdmobBanner(
                  adUnitId: getBannerAdUnitId(),
                  adSize: AdmobBannerSize.MEDIUM_RECTANGLE,
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Container(
                height: height / 4,
                width: width - 16,
                child: AdmobBanner(
                  adUnitId: getBannerAdUnitId(),
                  adSize: AdmobBannerSize.MEDIUM_RECTANGLE,
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Container(
                height: height / 4,
                width: width - 16,
                child: AdmobBanner(
                  adUnitId: getBannerAdUnitId(),
                  adSize: AdmobBannerSize.MEDIUM_RECTANGLE,
                ),
              ),
            ],
          ),
        ],
      ),
    ));
  }
}
