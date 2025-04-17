import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdManager {
  static InterstitialAd? _interstitialAd;

  /// Interstitial reklam yükleme
  static void loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: "ca-app-pub-3940256099942544/1033173712", // TEST ID
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
        },
        onAdFailedToLoad: (error) {
          _interstitialAd = null;
        },
      ),
    );
  }

  /// Interstitial reklam gösterme
  static void showInterstitialAd({required VoidCallback onAdClosed}) {
    if (_interstitialAd != null) {
      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          ad.dispose();
          loadInterstitialAd(); // Yeni reklam yükle
          onAdClosed(); // Reklam kapatıldığında sayfa değiştir
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          ad.dispose();
          _interstitialAd = null;
          onAdClosed(); // Reklam gösterilemezse sayfa değiştir
        },
      );

      _interstitialAd!.show();
    } else {
      onAdClosed(); // Reklam yoksa direkt sayfa değiştir
    }
  }

  /// Banner reklam nesnesi oluşturma
  static BannerAd createBannerAd() {
    return BannerAd(
      adUnitId: "ca-app-pub-3940256099942544/6300978111", // TEST ID
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) => print("Banner Ad Yüklendi"),
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          print("Banner Ad Yüklenemedi: $error");
          ad.dispose();
        },
      ),
    );
  }
}
