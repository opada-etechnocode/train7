import 'package:flutter/material.dart';

import '../models/ai_workout_models.dart';

/// MediaPipe pose connections used by the AI coach HTML demo.
const List<List<int>> kPoseConnections = [
  [11, 12],
  [11, 13],
  [13, 15],
  [12, 14],
  [14, 16],
  [11, 23],
  [12, 24],
  [23, 24],
  [23, 25],
  [25, 27],
  [24, 26],
  [26, 28],
];

/// Draws MediaPipe landmarks over the camera preview.
///
/// Use [mirrorX] when the preview is already mirrored (typical front camera)
/// but the JPEG sent to the server was not flipped.
class AiPosePainter extends CustomPainter {
  final List<AiLandmark>? landmarks;
  final bool mirrorX;

  AiPosePainter({required this.landmarks, this.mirrorX = true});

  @override
  void paint(Canvas canvas, Size size) {
    final List<AiLandmark>? points = landmarks;
    if (points == null || points.isEmpty) return;

    final Paint linePaint = Paint()
      ..color = const Color(0xFF00BFFF)
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final Paint dotPaint = Paint()
      ..color = const Color(0xFF00FF00)
      ..style = PaintingStyle.fill;

    Offset mapPoint(AiLandmark p) {
      final double x = mirrorX ? (1.0 - p.x) : p.x;
      return Offset(x * size.width, p.y * size.height);
    }

    bool valid(AiLandmark p) => p.x != 0 && p.y != 0;

    for (final List<int> pair in kPoseConnections) {
      if (pair[0] >= points.length || pair[1] >= points.length) continue;
      final AiLandmark a = points[pair[0]];
      final AiLandmark b = points[pair[1]];
      if (!valid(a) || !valid(b)) continue;
      canvas.drawLine(mapPoint(a), mapPoint(b), linePaint);
    }

    for (final AiLandmark p in points) {
      if (!valid(p)) continue;
      canvas.drawCircle(mapPoint(p), 5, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant AiPosePainter oldDelegate) =>
      oldDelegate.landmarks != landmarks || oldDelegate.mirrorX != mirrorX;
}
