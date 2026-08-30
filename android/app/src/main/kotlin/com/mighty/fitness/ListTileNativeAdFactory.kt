package com.train7.etechnocode

import android.view.LayoutInflater
import android.widget.Button
import android.widget.ImageView
import android.widget.TextView
import com.google.android.gms.ads.nativead.NativeAd
import com.google.android.gms.ads.nativead.NativeAdView
import io.flutter.plugins.googlemobileads.GoogleMobileAdsPlugin
import android.content.Context

class ListTileNativeAdFactory(private val context: Context)
    : GoogleMobileAdsPlugin.NativeAdFactory {

    override fun createNativeAd(
        nativeAd: NativeAd,
        customOptions: MutableMap<String, Any>?
    ): NativeAdView {

        val adView = LayoutInflater.from(context)
            .inflate(R.layout.native_ad_listtile, null) as NativeAdView

        // Assign views
        val headlineView = adView.findViewById<TextView>(R.id.ad_headline)
        val iconView = adView.findViewById<ImageView>(R.id.ad_icon)
        val ctaView = adView.findViewById<Button>(R.id.ad_call_to_action)
        val mediaView = adView.findViewById<com.google.android.gms.ads.nativead.MediaView>(R.id.ad_media)

        adView.headlineView = headlineView
        adView.iconView = iconView
        adView.callToActionView = ctaView
        adView.mediaView = mediaView

        // Set headline
        headlineView?.text = nativeAd.headline

        // Set CTA text
        ctaView?.text = nativeAd.callToAction

        // Set icon safely
        val icon = nativeAd.icon
        if (icon != null) {
            iconView?.setImageDrawable(icon.drawable)
            iconView?.visibility = ImageView.VISIBLE
        } else {
            iconView?.visibility = ImageView.GONE
        }

        // Assign the native ad to view
        adView.setNativeAd(nativeAd)

        return adView
    }
}
