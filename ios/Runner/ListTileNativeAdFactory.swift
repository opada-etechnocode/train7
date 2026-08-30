import UIKit
import GoogleMobileAds
import google_mobile_ads

/// Native ad layout for list items (factoryId: "listTile"). Uses programmatic layout, no XIB required.
class ListTileNativeAdFactory: NSObject, FLTNativeAdFactory {

  func createNativeAd(
    _ nativeAd: GADNativeAd,
    customOptions: [AnyHashable: Any]?
  ) -> GADNativeAdView {
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
