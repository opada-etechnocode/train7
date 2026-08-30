import UIKit
import Flutter
import GoogleMobileAds
import google_mobile_ads

// MARK: - Native Ad Factories (in same file so types are always in scope)

/// Native ad layout for list items (factoryId: "listTile").
class ListTileNativeAdFactory: NSObject, FLTNativeAdFactory {
  func createNativeAd(_ nativeAd: GADNativeAd, customOptions: [AnyHashable: Any]?) -> GADNativeAdView {
    let adView = GADNativeAdView(frame: .zero)
    adView.translatesAutoresizingMaskIntoConstraints = false
    adView.backgroundColor = UIColor.systemBackground

    let container = UIView()
    container.translatesAutoresizingMaskIntoConstraints = false
    container.backgroundColor = UIColor.systemBackground
    adView.addSubview(container)

    NSLayoutConstraint.activate([
      container.leadingAnchor.constraint(equalTo: adView.leadingAnchor),
      container.trailingAnchor.constraint(equalTo: adView.trailingAnchor),
      container.topAnchor.constraint(equalTo: adView.topAnchor),
      container.bottomAnchor.constraint(equalTo: adView.bottomAnchor),
      container.heightAnchor.constraint(greaterThanOrEqualToConstant: 80),
    ])

    let iconView = UIImageView()
    iconView.translatesAutoresizingMaskIntoConstraints = false
    iconView.contentMode = .scaleAspectFit
    iconView.clipsToBounds = true
    container.addSubview(iconView)

    let headlineLabel = UILabel()
    headlineLabel.translatesAutoresizingMaskIntoConstraints = false
    headlineLabel.font = UIFont.boldSystemFont(ofSize: 14)
    headlineLabel.numberOfLines = 2
    container.addSubview(headlineLabel)

    let ctaButton = UIButton(type: .system)
    ctaButton.translatesAutoresizingMaskIntoConstraints = false
    ctaButton.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
    ctaButton.setTitleColor(.white, for: .normal)
    ctaButton.backgroundColor = UIColor.systemBlue
    ctaButton.layer.cornerRadius = 6
    ctaButton.isUserInteractionEnabled = false
    container.addSubview(ctaButton)

    NSLayoutConstraint.activate([
      iconView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 12),
      iconView.centerYAnchor.constraint(equalTo: container.centerYAnchor),
      iconView.widthAnchor.constraint(equalToConstant: 40),
      iconView.heightAnchor.constraint(equalToConstant: 40),
      ctaButton.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -12),
      ctaButton.centerYAnchor.constraint(equalTo: container.centerYAnchor),
      ctaButton.heightAnchor.constraint(equalToConstant: 32),
      ctaButton.widthAnchor.constraint(greaterThanOrEqualToConstant: 80),
      headlineLabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 10),
      headlineLabel.trailingAnchor.constraint(equalTo: ctaButton.leadingAnchor, constant: -10),
      headlineLabel.centerYAnchor.constraint(equalTo: container.centerYAnchor),
    ])

    adView.iconView = iconView
    adView.headlineView = headlineLabel
    adView.callToActionView = ctaButton
    headlineLabel.text = nativeAd.headline

    if let icon = nativeAd.icon?.image {
      iconView.image = icon
      iconView.isHidden = false
    } else {
      iconView.isHidden = true
    }

    if let cta = nativeAd.callToAction {
      ctaButton.setTitle(cta, for: .normal)
      ctaButton.isHidden = false
    } else {
      ctaButton.isHidden = true
    }

    adView.nativeAd = nativeAd
    return adView
  }
}

/// Native ad layout for banner-style placements (factoryId: "bannerTile").
class BannerNativeAdFactory: NSObject, FLTNativeAdFactory {
  func createNativeAd(_ nativeAd: GADNativeAd, customOptions: [AnyHashable: Any]?) -> GADNativeAdView {
    let adView = GADNativeAdView(frame: .zero)
    adView.translatesAutoresizingMaskIntoConstraints = false
    adView.backgroundColor = UIColor.systemBackground

    let container = UIView()
    container.translatesAutoresizingMaskIntoConstraints = false
    container.backgroundColor = UIColor.systemBackground
    adView.addSubview(container)

    NSLayoutConstraint.activate([
      container.leadingAnchor.constraint(equalTo: adView.leadingAnchor),
      container.trailingAnchor.constraint(equalTo: adView.trailingAnchor),
      container.topAnchor.constraint(equalTo: adView.topAnchor),
      container.bottomAnchor.constraint(equalTo: adView.bottomAnchor),
      container.heightAnchor.constraint(greaterThanOrEqualToConstant: 90),
    ])

    let iconView = UIImageView()
    iconView.translatesAutoresizingMaskIntoConstraints = false
    iconView.contentMode = .scaleAspectFit
    iconView.clipsToBounds = true
    container.addSubview(iconView)

    let headlineLabel = UILabel()
    headlineLabel.translatesAutoresizingMaskIntoConstraints = false
    headlineLabel.font = UIFont.boldSystemFont(ofSize: 14)
    headlineLabel.numberOfLines = 1
    container.addSubview(headlineLabel)

    let bodyLabel = UILabel()
    bodyLabel.translatesAutoresizingMaskIntoConstraints = false
    bodyLabel.font = UIFont.systemFont(ofSize: 12)
    bodyLabel.textColor = UIColor.secondaryLabel
    bodyLabel.numberOfLines = 2
    container.addSubview(bodyLabel)

    let ctaButton = UIButton(type: .system)
    ctaButton.translatesAutoresizingMaskIntoConstraints = false
    ctaButton.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
    ctaButton.setTitleColor(.white, for: .normal)
    ctaButton.backgroundColor = UIColor.systemBlue
    ctaButton.layer.cornerRadius = 6
    ctaButton.isUserInteractionEnabled = false
    container.addSubview(ctaButton)

    NSLayoutConstraint.activate([
      iconView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 12),
      iconView.centerYAnchor.constraint(equalTo: container.centerYAnchor),
      iconView.widthAnchor.constraint(equalToConstant: 40),
      iconView.heightAnchor.constraint(equalToConstant: 40),
      ctaButton.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -12),
      ctaButton.centerYAnchor.constraint(equalTo: container.centerYAnchor),
      ctaButton.heightAnchor.constraint(equalToConstant: 32),
      ctaButton.widthAnchor.constraint(greaterThanOrEqualToConstant: 80),
      headlineLabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 10),
      headlineLabel.trailingAnchor.constraint(equalTo: ctaButton.leadingAnchor, constant: -10),
      headlineLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 12),
      bodyLabel.leadingAnchor.constraint(equalTo: headlineLabel.leadingAnchor),
      bodyLabel.trailingAnchor.constraint(equalTo: headlineLabel.trailingAnchor),
      bodyLabel.topAnchor.constraint(equalTo: headlineLabel.bottomAnchor, constant: 4),
      bodyLabel.bottomAnchor.constraint(lessThanOrEqualTo: container.bottomAnchor, constant: -12),
    ])

    adView.iconView = iconView
    adView.headlineView = headlineLabel
    adView.bodyView = bodyLabel
    adView.callToActionView = ctaButton
    headlineLabel.text = nativeAd.headline

    if let body = nativeAd.body {
      bodyLabel.text = body
      bodyLabel.isHidden = false
    } else {
      bodyLabel.isHidden = true
    }

    if let icon = nativeAd.icon?.image {
      iconView.image = icon
      iconView.isHidden = false
    } else {
      iconView.isHidden = true
    }

    if let cta = nativeAd.callToAction {
      ctaButton.setTitle(cta, for: .normal)
      ctaButton.isHidden = false
    } else {
      ctaButton.isHidden = true
    }

    adView.nativeAd = nativeAd
    return adView
  }
}

// MARK: - AppDelegate

@main
@objc class AppDelegate: FlutterAppDelegate {

  var listTileNativeAdFactory: ListTileNativeAdFactory?
  var bannerNativeAdFactory: BannerNativeAdFactory?

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)

    listTileNativeAdFactory = ListTileNativeAdFactory()
    bannerNativeAdFactory = BannerNativeAdFactory()

    if let listTileNativeAdFactory {
      FLTGoogleMobileAdsPlugin.registerNativeAdFactory(
        self,
        factoryId: "listTile",
        nativeAdFactory: listTileNativeAdFactory
      )
    }

    if let bannerNativeAdFactory {
      FLTGoogleMobileAdsPlugin.registerNativeAdFactory(
        self,
        factoryId: "bannerTile",
        nativeAdFactory: bannerNativeAdFactory
      )
    }

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
