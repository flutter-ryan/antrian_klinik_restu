import 'package:antrian_online_restu/src/common/source/color_style.dart';
import 'package:antrian_online_restu/src/common/source/size_config.dart';
import 'package:antrian_online_restu/src/common/source/transition/slide_left_transition.dart';
import 'package:antrian_online_restu/src/common/ui/session_page.dart';
import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:flutter/material.dart';

class Splashpage extends StatefulWidget {
  @override
  _SplashpageState createState() => _SplashpageState();
}

class _SplashpageState extends State<Splashpage> {
  String? _version;
  @override
  void initState() {
    super.initState();
    getPackage();
  }

  void getPackage() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      _version = packageInfo.version;
    });
    Future.delayed(Duration(seconds: 2), () {
      Navigator.pushAndRemoveUntil(
        context,
        SlideLeftRoute(
          page: Sessionpage(),
        ),
        (_) => false,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: kPrimaryColor,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarBrightness: Brightness.dark,
          statusBarIconBrightness: Brightness.light,
        ),
        child: Stack(
          children: [
            Center(
              child: Hero(
                tag: 'logoHero',
                child: Container(
                  width: SizeConfig.blockSizeHorizontal * 70,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/restu_logo.png'),
                    ),
                  ),
                ),
              ),
            ),
            SafeArea(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Antrian Online \u00a9 2020',
                      style: TextStyle(color: Colors.grey[400]),
                    ),
                    Text(
                      'Version: $_version',
                      style: TextStyle(color: Colors.grey[400]),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
