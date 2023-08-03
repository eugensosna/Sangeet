// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';

// class AdController extends GetxController {
//   final adUnitId = 'ca-app-pub-7343730522446789/6799855520';
//   BannerAd? bannerAd; 
//   RxBool isAdLoaded = false.obs;

//   loadBannerAd() {
//     bannerAd = BannerAd(
//       adUnitId: adUnitId,
//       request: const AdRequest(),
//       size: AdSize.banner,
//       listener: BannerAdListener(
//         // Called when an ad is successfully received.
//         onAdLoaded: (ad) {
//           debugPrint('$ad loaded.');
//           isAdLoaded(true);
//         },
//         // Called when an ad request failed.
//         onAdFailedToLoad: (ad, err) {
//           debugPrint('BannerAd failed to load: $err');
//           // Dispose the ad here to free resources.
//           ad.dispose();
//           isAdLoaded(false);
//         },
//       ),
//     );
//     bannerAd!.load();
//   }
  
// }