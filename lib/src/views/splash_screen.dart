import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
// import 'package:sangeet/src/controller/ad_controller.dart';
import 'package:sangeet/src/controller/audio_controller.dart';
import 'package:sangeet/src/widgets/bottom_nav.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final box = GetStorage();
  final AudioController _con = Get.put(AudioController());
  // final AdController _adCon = Get.put(AdController());

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if(box.read('isDarkMode') == null) {
        box.write('isDarkMode', Get.isDarkMode);
      } else {
        Get.changeThemeMode(
          box.read('isDarkMode') ? ThemeMode.dark : ThemeMode.light
        );
      }
    });
    _con.getAllFiles();
    super.initState();
    // _adCon.loadBannerAd();
    Timer(
      const Duration(seconds: 3),
      () => Get.off(() => const BottomNavigation())
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.75,
          width: MediaQuery.of(context).size.width * 0.75,
          child: Image.asset('assets/images/appIcon.png')
        )
      )
    );
  }
  
}