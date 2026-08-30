import '../utils/shared_import.dart';

/// Tracking card matching the design: text left, ring right, sparkline bottom.
Widget trackingCard({
  required Color background,
  required Color progressColor,
  required String subtitle,
  required String value,
  required String label,
  required double progress, // 0.0 - 1.0
  required IconData icon,
  String? footerHint,
  List<double>? sparklineValues,
  String sparklineStartLabel = '00:00',
  String sparklineEndLabel = '24:00',
}) {
  final int percent = (progress.clamp(0.0, 1.0) * 100).round();
  final List<double> points =
      (sparklineValues != null && sparklineValues.isNotEmpty)
          ? sparklineValues
          : [0.15, 0.35, 0.25, 0.55, 0.4, 0.7, 0.5, progress.clamp(0.05, 1.0)];

  final bool isDark = appStore.isDarkMode;
  final Color titleColor = isDark ? const Color(0xFFB8BDC5) : Colors.black54;
  final Color valueColor = progressColor;
  final Color labelColor = isDark ? Colors.white70 : Colors.black54;

  return Container(
    height: 170,
    padding: const EdgeInsets.fromLTRB(14, 14, 12, 10),
    decoration: BoxDecoration(
      color: background,
      borderRadius: BorderRadius.circular(22),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: isDark ? 0.35 : 0.06),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: Column(
      children: [
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: titleColor,
                        fontFamily: 'Cairo',
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    8.height,
                    RichText(
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: value,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: valueColor,
                              fontFamily: 'Cairo',
                              height: 1.1,
                            ),
                          ),
                          if (label.isNotEmpty)
                            TextSpan(
                              text: ' $label',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: labelColor,
                                fontFamily: 'Cairo',
                              ),
                            ),
                        ],
                      ),
                    ),
                    if (footerHint != null && footerHint.isNotEmpty) ...[
                      6.height,
                      Text(
                        footerHint,
                        style: TextStyle(
                          fontSize: 9,
                          color: titleColor,
                          fontFamily: 'Cairo',
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
              8.width,
              Column(
                children: [
                  SizedBox(
                    width: 68,
                    height: 68,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 68,
                          height: 68,
                          child: CircularProgressIndicator(
                            value: progress.clamp(0.0, 1.0),
                            strokeWidth: 5,
                            strokeCap: StrokeCap.round,
                            valueColor: AlwaysStoppedAnimation(progressColor),
                            backgroundColor: isDark
                                ? Colors.white.withValues(alpha: 0.12)
                                : Colors.grey.withValues(alpha: 0.25),
                          ),
                        ),
                        Icon(icon, size: 26, color: progressColor),
                      ],
                    ),
                  ),
                  6.height,
                  Text(
                    '$percent%',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: progressColor,
                      fontFamily: 'Cairo',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(
          height: 28,
          width: double.infinity,
          child: CustomPaint(
            painter: SparklinePainter(color: progressColor, values: points),
          ),
        ),
        2.height,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              sparklineStartLabel,
              style: TextStyle(
                fontSize: 9,
                color: titleColor,
                fontFamily: 'Cairo',
              ),
            ),
            Text(
              sparklineEndLabel,
              style: TextStyle(
                fontSize: 9,
                color: titleColor,
                fontFamily: 'Cairo',
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

/// Builds normalized 0–1 points from graph logs + current value.
List<double> buildSparklinePoints({
  required List<WaterGraphData> logList,
  required int currentValue,
  required int dailyGoal,
}) {
  final List<WaterGraphData> source = List<WaterGraphData>.from(logList);
  if (source.isEmpty) {
    final double p = dailyGoal > 0
        ? (currentValue / dailyGoal).clamp(0.0, 1.0)
        : (currentValue > 0 ? 0.35 : 0.0);
    if (p <= 0) return [0.08, 0.12, 0.1, 0.15, 0.12, 0.18, 0.14, 0.16];
    return [0.1, 0.25, 0.2, 0.45, 0.35, 0.6, 0.5, p.clamp(0.15, 1.0)];
  }

  source.sort(
    (a, b) => DateTime.parse(a.date.validate())
        .compareTo(DateTime.parse(b.date.validate())),
  );

  final List<WaterGraphData> recent =
      source.length > 8 ? source.sublist(source.length - 8) : source;

  final int maxValue = [
    dailyGoal,
    currentValue,
    ...recent.map((e) => e.value.validate()),
  ].reduce((a, b) => a > b ? a : b);

  if (maxValue <= 0) {
    return List<double>.filled(recent.length.clamp(2, 8), 0.08);
  }

  return recent
      .map((e) => (e.value.validate() / maxValue).clamp(0.05, 1.0))
      .toList();
}

class SparklinePainter extends CustomPainter {
  final Color color;
  final List<double> values;

  SparklinePainter({required this.color, required this.values});

  @override
  void paint(Canvas canvas, Size size) {
    if (values.isEmpty) return;

    final List<double> points =
        values.length == 1 ? [values.first, values.first] : values;

    final Paint linePaint = Paint()
      ..color = color.withValues(alpha: 0.95)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final Paint fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          color.withValues(alpha: 0.35),
          color.withValues(alpha: 0.0),
        ],
      ).createShader(Offset.zero & size);

    final Path linePath = Path();
    final Path fillPath = Path();

    Offset pointAt(int i) {
      final double x = size.width * (i / (points.length - 1));
      final double y =
          size.height * (1 - points[i].clamp(0.0, 1.0) * 0.85 - 0.08);
      return Offset(x, y);
    }

    for (int i = 0; i < points.length; i++) {
      final Offset p = pointAt(i);
      if (i == 0) {
        linePath.moveTo(p.dx, p.dy);
        fillPath.moveTo(p.dx, size.height);
        fillPath.lineTo(p.dx, p.dy);
      } else {
        final Offset prev = pointAt(i - 1);
        final Offset mid = Offset((prev.dx + p.dx) / 2, (prev.dy + p.dy) / 2);
        linePath.quadraticBezierTo(prev.dx, prev.dy, mid.dx, mid.dy);
        fillPath.quadraticBezierTo(prev.dx, prev.dy, mid.dx, mid.dy);
        if (i == points.length - 1) {
          linePath.lineTo(p.dx, p.dy);
          fillPath.lineTo(p.dx, p.dy);
        }
      }
    }

    fillPath.lineTo(size.width, size.height);
    fillPath.close();

    canvas.drawPath(fillPath, fillPaint);
    canvas.drawPath(linePath, linePaint);
  }

  @override
  bool shouldRepaint(covariant SparklinePainter oldDelegate) =>
      oldDelegate.color != color ||
      oldDelegate.values.length != values.length ||
      !_listEquals(oldDelegate.values, values);

  bool _listEquals(List<double> a, List<double> b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}
