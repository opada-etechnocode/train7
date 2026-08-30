import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';

class NativeStepService {
  static const MethodChannel _channel = MethodChannel('<YOUR_PACKAGE_NAME>/steps');

  static Future<int?> getInstantSteps() async {
    try {
      final int? steps = await _channel.invokeMethod<int>('getInstantSteps');
      
      if (steps == -1) {
        debugPrint('NativeStepService: Step sensor did not emit value within timeout.');
        return null;
      }
      
      debugPrint('NativeStepService: Fetched instant steps: $steps');
      return steps;
    } on PlatformException catch (e) {
      debugPrint("NativeStepService: Failed to get instant steps: '${e.message}'.");
      return null;
    } catch (e) {
      debugPrint("NativeStepService: An unexpected error occurred: $e");
      return null;
    }
  }
}
