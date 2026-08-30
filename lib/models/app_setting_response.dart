class AppSettingResponse {
  int? id;
  String? siteName;
  String? siteEmail;
  String? siteDescription;
  String? siteCopyright;
  String? facebookUrl;
  String? instagramUrl;
  String? twitterUrl;
  String? linkedinUrl;
  List<String>? languageOption;
  String? contactEmail;
  String? contactNumber;
  String? helpSupportUrl;
  String? createdAt;
  String? updatedAt;
  String? loginEnable;
  String? subscription;
  AppVersion? appVersion;
  CrispChat? crispChat;
  MobileGame? mobileGame;
  List<Pages>? pages;

  AppSettingResponse({
    this.id,
    this.siteName,
    this.siteEmail,
    this.siteDescription,
    this.siteCopyright,
    this.facebookUrl,
    this.instagramUrl,
    this.twitterUrl,
    this.linkedinUrl,
    this.languageOption,
    this.contactEmail,
    this.contactNumber,
    this.helpSupportUrl,
    this.createdAt,
    this.updatedAt,
    this.appVersion,
    this.loginEnable,
    this.subscription,
    this.crispChat,
    this.mobileGame,
    this.pages,
  });

  AppSettingResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    siteName = json['site_name'];
    siteEmail = json['site_email'];
    siteDescription = json['site_description'];
    siteCopyright = json['site_copyright'];
    facebookUrl = json['facebook_url'];
    instagramUrl = json['instagram_url'];
    twitterUrl = json['twitter_url'];
    linkedinUrl = json['linkedin_url'];
    languageOption = json['language_option'].cast<String>();
    contactEmail = json['contact_email'];
    contactNumber = json['contact_number'];
    helpSupportUrl = json['help_support_url'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    appVersion = json['app_version'] != null
        ? AppVersion.fromJson(json['app_version'])
        : null;
    loginEnable = json['login_enable'];
    subscription = json['subscription'];
    crispChat = json['crisp_chat'] != null
        ? CrispChat.fromJson(json['crisp_chat'])
        : null;
    mobileGame = json['mobile_game'] != null
        ? MobileGame.fromJson(json['mobile_game'])
        : null;
    if (json['pages'] != null) {
      pages = <Pages>[];
      json['pages'].forEach((dynamic v) {
        pages!.add(Pages.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['site_name'] = siteName;
    data['site_email'] = siteEmail;
    data['site_description'] = siteDescription;
    data['site_copyright'] = siteCopyright;
    data['facebook_url'] = facebookUrl;
    data['instagram_url'] = instagramUrl;
    data['twitter_url'] = twitterUrl;
    data['linkedin_url'] = linkedinUrl;
    data['language_option'] = languageOption;
    data['contact_email'] = contactEmail;
    data['contact_number'] = contactNumber;
    data['help_support_url'] = helpSupportUrl;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (appVersion != null) {
      data['app_version'] = appVersion!.toJson();
    }
    data['login_enable'] = loginEnable;
    data['subscription'] = subscription;
    if (crispChat != null) {
      data['crisp_chat'] = crispChat!.toJson();
    }
    if (pages != null) {
      data['pages'] = pages!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AppVersion {
  String? androidForceUpdate;
  String? androidVersionCode;
  String? playstoreUrl;
  String? iosForceUpdate;
  String? iosVersion;
  String? appstoreUrl;

  AppVersion({
    this.androidForceUpdate,
    this.androidVersionCode,
    this.playstoreUrl,
    this.iosForceUpdate,
    this.iosVersion,
    this.appstoreUrl,
  });

  AppVersion.fromJson(Map<String, dynamic> json) {
    androidForceUpdate = json['android_force_update'];
    androidVersionCode = json['android_version_code'];
    playstoreUrl = json['playstore_url'];
    iosForceUpdate = json['ios_force_update'];
    iosVersion = json['ios_version'];
    appstoreUrl = json['appstore_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['android_force_update'] = androidForceUpdate;
    data['android_version_code'] = androidVersionCode;
    data['playstore_url'] = playstoreUrl;
    data['ios_force_update'] = iosForceUpdate;
    data['ios_version'] = iosVersion;
    data['appstore_url'] = appstoreUrl;
    return data;
  }
}

class CrispChat {
  String? crispChatWebsiteId;
  bool? isCrispChatEnabled;

  CrispChat({this.crispChatWebsiteId, this.isCrispChatEnabled});

  CrispChat.fromJson(Map<String, dynamic> json) {
    crispChatWebsiteId = json['crisp_chat_website_id'];
    isCrispChatEnabled = json['is_crisp_chat_enabled'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['crisp_chat_website_id'] = crispChatWebsiteId;
    data['is_crisp_chat_enabled'] = isCrispChatEnabled;
    return data;
  }
}

class MobileGame {
  bool? mobileGameEnabled;

  MobileGame({this.mobileGameEnabled});

  MobileGame.fromJson(Map<String, dynamic> json) {
    mobileGameEnabled = json['mobile_game_enabled'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['crisp_chat_website_id'] = mobileGameEnabled;
    return data;
  }
}

class Pages {
  int? id;
  String? title;
  String? slug;
  String? url;

  Pages({this.id, this.title, this.slug, this.url});

  Pages.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    slug = json['slug'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['slug'] = slug;
    data['url'] = url;
    return data;
  }
}
