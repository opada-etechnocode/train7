import 'package:permission_handler_platform_interface/permission_handler_platform_interface.dart';

import '../utils/shared_import.dart';

class Permissions {
  static PermissionHandlerPlatform get _handler =>
      PermissionHandlerPlatform.instance;

  static Future<bool> activityPermissionsGranted() async {
    final PermissionStatus activityPermissionStatus =
        await _getActivityPermission();
    final PermissionStatus notificationStatus =
        await _getNotificationPermission();

    if (activityPermissionStatus == PermissionStatus.granted &&
        notificationStatus == PermissionStatus.granted) {
      log("grant");
      return true;
    } else {
      log("not grant");
      _handleInvalidPermissions(activityPermissionStatus, notificationStatus);
      return false;
    }
  }

  static Future<PermissionStatus> _getActivityPermission() async {
    final PermissionStatus permission = await _handler.checkPermissionStatus(
      Permission.activityRecognition,
    );
    if (permission != PermissionStatus.granted) {
      final Map<Permission, PermissionStatus> permissionStatus = await _handler
          .requestPermissions([Permission.activityRecognition]);
      return permissionStatus[Permission.activityRecognition] ??
          PermissionStatus.denied;
    } else {
      return permission;
    }
  }

  static Future<PermissionStatus> _getNotificationPermission() async {
    final PermissionStatus permission = await _handler.checkPermissionStatus(
      Permission.notification,
    );
    if (permission != PermissionStatus.granted) {
      final Map<Permission, PermissionStatus> permissionStatus = await _handler
          .requestPermissions([Permission.notification]);
      return permissionStatus[Permission.notification] ??
          PermissionStatus.denied;
    } else {
      return permission;
    }
  }

  static void _handleInvalidPermissions(
    PermissionStatus activityPermissionStatus,
    PermissionStatus notificationPermissionStatus,
  ) {
    if (activityPermissionStatus == PermissionStatus.denied &&
        notificationPermissionStatus == PermissionStatus.denied) {
      throw PlatformException(
        code: "PERMISSION_DENIED",
        message: "Access to camera and microphone denied",
      );
    } else if (activityPermissionStatus == PermissionStatus.restricted &&
        notificationPermissionStatus == PermissionStatus.denied) {
      throw PlatformException(
        code: "PERMISSION_DISABLED",
        message: "Location data is not available on device",
      );
    }
  }
}
