package com.train7.etechnocode
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.googlemobileads.GoogleMobileAdsPlugin


class MainActivity: FlutterFragmentActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        GoogleMobileAdsPlugin.registerNativeAdFactory(
            flutterEngine,
            "listTile",                        // factoryId used in Flutter
            ListTileNativeAdFactory(this)      // your factory class
        )

        GoogleMobileAdsPlugin.registerNativeAdFactory(
            flutterEngine,
            "bannerTile",                        // factoryId used in Flutter
            BannerNativeAdFactory(this)      // your factory class
        )
    }
    override fun cleanUpFlutterEngine(flutterEngine: FlutterEngine) {
        GoogleMobileAdsPlugin.unregisterNativeAdFactory(flutterEngine, "listTile")
        GoogleMobileAdsPlugin.unregisterNativeAdFactory(flutterEngine, "bannerTile")
        super.cleanUpFlutterEngine(flutterEngine)
    }

}
