import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:image/image.dart' as img;

/// Converts a [CameraImage] to upright JPEG bytes for the AI WebSocket.
///
/// [rotationDegrees] should usually be [CameraDescription.sensorOrientation]
/// so MediaPipe sees the same upright person as the preview (like the HTML demo).
Uint8List? convertCameraImageToJpeg(
  CameraImage image, {
  int quality = 70,
  int maxWidth = 640,
  int rotationDegrees = 0,
}) {
  try {
    if (image.format.group == ImageFormatGroup.jpeg) {
      return Uint8List.fromList(image.planes.first.bytes);
    }

    img.Image? rgb = _toRgbImage(image);
    if (rgb == null) return null;

    final int rot = rotationDegrees % 360;
    if (rot == 90 || rot == 180 || rot == 270) {
      rgb = img.copyRotate(rgb, angle: rot);
    }

    img.Image sized = rgb;
    if (rgb.width > maxWidth) {
      sized = img.copyResize(
        rgb,
        width: maxWidth,
        height: (rgb.height * maxWidth / rgb.width).round(),
      );
    }

    return Uint8List.fromList(img.encodeJpg(sized, quality: quality));
  } catch (_) {
    return null;
  }
}

img.Image? _toRgbImage(CameraImage image) {
  final int width = image.width;
  final int height = image.height;

  if (image.format.group == ImageFormatGroup.bgra8888) {
    final img.Image out = img.Image(width: width, height: height);
    final Uint8List bytes = image.planes[0].bytes;
    final int bytesPerRow = image.planes[0].bytesPerRow;
    for (int y = 0; y < height; y++) {
      final int row = y * bytesPerRow;
      for (int x = 0; x < width; x++) {
        final int i = row + x * 4;
        if (i + 2 >= bytes.length) continue;
        out.setPixelRgba(x, y, bytes[i + 2], bytes[i + 1], bytes[i], 255);
      }
    }
    return out;
  }

  // YUV420 / NV21 style
  if (image.planes.length < 2) return null;
  final Uint8List yPlane = image.planes[0].bytes;
  final int yRowStride = image.planes[0].bytesPerRow;

  late Uint8List uPlane;
  late Uint8List vPlane;
  late int uvRowStride;
  late int uvPixelStride;

  if (image.planes.length >= 3) {
    uPlane = image.planes[1].bytes;
    vPlane = image.planes[2].bytes;
    uvRowStride = image.planes[1].bytesPerRow;
    uvPixelStride = image.planes[1].bytesPerPixel ?? 1;
  } else {
    // NV21: UV interleaved in plane 1
    final Uint8List uv = image.planes[1].bytes;
    uPlane = uv;
    vPlane = uv;
    uvRowStride = image.planes[1].bytesPerRow;
    uvPixelStride = 2;
  }

  final img.Image out = img.Image(width: width, height: height);
  for (int y = 0; y < height; y++) {
    for (int x = 0; x < width; x++) {
      final int yp = yPlane[y * yRowStride + x] & 0xff;
      final int uvIndex =
          (y >> 1) * uvRowStride + (x >> 1) * uvPixelStride;
      int u;
      int v;
      if (image.planes.length >= 3) {
        u = uPlane[uvIndex.clamp(0, uPlane.length - 1)] & 0xff;
        v = vPlane[uvIndex.clamp(0, vPlane.length - 1)] & 0xff;
      } else {
        final int vi = uvIndex.clamp(0, vPlane.length - 2);
        v = vPlane[vi] & 0xff;
        u = uPlane[vi + 1] & 0xff;
      }

      final int c = yp - 16;
      final int d = u - 128;
      final int e = v - 128;
      int r = (298 * c + 409 * e + 128) >> 8;
      int g = (298 * c - 100 * d - 208 * e + 128) >> 8;
      int b = (298 * c + 516 * d + 128) >> 8;
      out.setPixelRgba(
        x,
        y,
        r.clamp(0, 255),
        g.clamp(0, 255),
        b.clamp(0, 255),
        255,
      );
    }
  }
  return out;
}
