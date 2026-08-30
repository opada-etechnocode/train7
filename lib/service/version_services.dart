import 'dart:developer' show log;
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../service/update_available_pop_up.dart';

class VersionService {
  Future<void> getVersionData(BuildContext context, dynamic value) async {
    log("CheckVersinCalls---${value.androidVersionCode}");
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();
    final num currentBuildNumberAndroid =
        num.tryParse(packageInfo.buildNumber.toString()) ?? 0;
    if (Platform.isAndroid) {
      final num liveBuildNumber =
          num.tryParse(value.androidVersionCode.toString()) ?? 0;
      log("----------15>>$liveBuildNumber");
      if (currentBuildNumberAndroid != 0 &&
          currentBuildNumberAndroid < liveBuildNumber) {
        //   update is available
        if (value.androidForceUpdate.toString() == "1") {
          //   update force
          //   UpdateAvailable(force:true).launch(context);
          showDialog<void>(
            context: context,
            builder: (context) => UpdateAvailable(
              force: true,
              storeUrl: value.playstoreUrl.toString(),
            ),
            barrierDismissible: false,
          );
        } else {
          //   optional update suggest only skip-able
          //   UpdateAvailable(force:true).launch(context);
          showDialog<void>(
            context: context,
            builder: (context) =>
                UpdateAvailable(storeUrl: value.playstoreUrl.toString()),
          );
        }
      } else {
        //   no update available
      }
    } else if (Platform.isIOS) {
      log(
        "isVersionGreater.call ==>LIVE-VERSION:${value.iosVersion.toString()}  LOCAL-VERSION:${packageInfo.data['version'].toString()}",
      );
      if (isVersionGreater(
        value.iosVersion.toString(),
        packageInfo.data['version'].toString(),
      )) {
        log("IOS_UPDATE_DETECTED");
        //   update is available
        if (value.iosForceUpdate.toString() == "1") {
          //   update force
          showDialog<void>(
            context: context,
            builder: (context) => UpdateAvailable(
              force: true,
              storeUrl: value.appstoreUrl.toString(),
            ),
            barrierDismissible: false,
          );
        } else {
          //   optional update suggest only skip-able
          showDialog<void>(
            context: context,
            builder: (context) =>
                UpdateAvailable(storeUrl: value.appstoreUrl.toString()),
          );
        }
      } else {
        log("IOS_NO_UPDATE");
        //   no update available
      }
    }
  }
}

bool isVersionGreater(String version1, String version2) {
  // Split the version strings into parts
  final List<String> versionParts1 = version1.split('.');
  final List<String> versionParts2 = version2.split('.');

  // Determine the maximum length of the version parts
  final int maxLength = versionParts1.length > versionParts2.length
      ? versionParts1.length
      : versionParts2.length;

  // Pad shorter version with zeros
  while (versionParts1.length < maxLength) {
    versionParts1.add('0');
  }
  while (versionParts2.length < maxLength) {
    versionParts2.add('0');
  }

  // Compare each part of the version
  for (int i = 0; i < maxLength; i++) {
    // Parse each part as an integer
    final int part1 = int.parse(versionParts1[i]);
    final int part2 = int.parse(versionParts2[i]);

    // Compare the parts
    if (part1 > part2) return true;
    if (part1 < part2) return false;
  }

  // If all parts are equal, the versions are the same
  return false;
}
