class AppConfigurationResponse {
  bool? enableCustomDashboard;
  bool? disableQuickView;
  bool? disableStory;
  String? dashboardType;
  SocialLink? socialLink;
  Admob? admob;

  AppConfigurationResponse({
    this.enableCustomDashboard,
    this.disableQuickView,
    this.disableStory,
    this.socialLink,
    this.dashboardType,
    this.admob,
  });

  AppConfigurationResponse.fromJson(Map<String, dynamic> json) {
    enableCustomDashboard = json['enable_custom_dashboard'];
    disableQuickView = json['disable_quickview'];
    disableStory = json['disable_story'];
    dashboardType = json['dashboard_type'];
    socialLink = json['social_link'] != null
        ? SocialLink.fromJson(json['social_link'])
        : null;
    admob = json['ads_configuration'] != null
        ? Admob.fromJson(json['ads_configuration'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['enable_custom_dashboard'] = enableCustomDashboard;
    data['disable_quickview'] = disableQuickView;
    data['disable_story'] = disableStory;
    data['dashboard_type'] = dashboardType;
    if (socialLink != null) {
      data['social_link'] = socialLink!.toJson();
    }
    if (admob != null) {
      data['ads_configuration'] = admob!.toJson();
    }
    return data;
  }
}

class SocialLink {
  String? whatsapp;
  String? facebook;
  String? twitter;
  String? instagram;
  String? contact;
  String? websiteUrl;
  String? privacyPolicy;
  String? copyrightText;
  String? termCondition;

  SocialLink({
    this.whatsapp,
    this.facebook,
    this.twitter,
    this.instagram,
    this.contact,
    this.websiteUrl,
    this.privacyPolicy,
    this.copyrightText,
    this.termCondition,
  });

  SocialLink.fromJson(Map<String, dynamic> json) {
    whatsapp = json['whatsapp'];
    facebook = json['facebook'];
    twitter = json['twitter'];
    instagram = json['instagram'];
    contact = json['contact'];
    websiteUrl = json['website_url'];
    privacyPolicy = json['privacy_policy'];
    copyrightText = json['copyright_text'];
    termCondition = json['term_condition'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['whatsapp'] = whatsapp;
    data['facebook'] = facebook;
    data['twitter'] = twitter;
    data['instagram'] = instagram;
    data['contact'] = contact;
    data['website_url'] = websiteUrl;
    data['privacy_policy'] = privacyPolicy;
    data['copyright_text'] = copyrightText;
    data['term_condition'] = termCondition;
    return data;
  }
}

class Admob {
  String? bannerId;
  String? bannerIdIos;
  String? interstitialId;
  String? interstitialIdIos;
  String? adsType;

  Admob({
    this.bannerId,
    this.bannerIdIos,
    this.interstitialId,
    this.interstitialIdIos,
    this.adsType,
  });

  Admob.fromJson(Map<String, dynamic> json) {
    bannerId = json['banner_id'];
    bannerIdIos = json['banner_id_ios'];
    interstitialId = json['interstitial_id'];
    interstitialIdIos = json['interstitial_id_ios'];
    adsType = json['ads_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['banner_id'] = bannerId;
    data['banner_id_ios'] = bannerIdIos;
    data['interstitial_id'] = interstitialId;
    data['interstitial_id_ios'] = interstitialIdIos;
    data['ads_type'] = adsType;
    return data;
  }
}
