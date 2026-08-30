import '../utils/shared_import.dart';

class PlanNutrientGraph extends StatelessWidget {
  final int currentKcal;
  final int targetKcal;
  final num fromKcal;
  final num toKcal;
  final int currentProtein;
  final int targetProtein;
  final double proteinProgress;
  final int currentCarbs;
  final int targetCarbs;
  final double carbsProgress;
  final int currentFats;
  final int targetFats;
  final double fatsProgress;

  const PlanNutrientGraph({
    super.key,
    required this.currentKcal,
    required this.targetKcal,
    required this.fromKcal,
    required this.toKcal,
    required this.currentProtein,
    required this.targetProtein,
    required this.proteinProgress,
    required this.currentCarbs,
    required this.targetCarbs,
    required this.carbsProgress,
    required this.currentFats,
    required this.targetFats,
    required this.fatsProgress,
  });

  String _formatNumber(int n) {
    if (n >= 1000) {
      final rest = n % 1000;
      return '${n ~/ 1000},${rest.toString().padLeft(3, '0')}';
    }
    return '$n';
  }

  @override
  Widget build(BuildContext context) {
    final barBg = appStore.isDarkMode
        ? Colors.grey.shade800
        : Colors.grey.shade200;
    const progressColor = primaryColor;

    double maxValue = targetKcal.toDouble();
    if (toKcal > 0) {
      maxValue = toKcal.toDouble() * 1.15;
    }
    if (currentKcal > maxValue) {
      maxValue = currentKcal.toDouble() * 1.1;
    }
    if (maxValue == 0) {
      maxValue = 1;
    }

    return Container(
      margin: const EdgeInsets.only( bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: boxDecorationWithRoundedCorners(
        backgroundColor: context.cardColor,
        borderRadius: radius(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(20),
            blurRadius: 4,
            spreadRadius: 0.5,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$currentKcal / $targetKcal ${languages.lblKcal.validate()}',
            style: boldTextStyle(size: 18),
          ),
          12.height,
          LayoutBuilder(
            builder: (context, constraints) => _buildKcalGraphWithMarkers(
              constraints.maxWidth,
              maxValue,
              barBg,
              progressColor,
            ),
          ),
          20.height,
          Row(
            children: [
              Expanded(
                child: _buildMacroColumn(
                  languages.lblProtein.validate(),
                  currentProtein,
                  targetProtein,
                  proteinProgress,
                  barBg,
                  progressColor,
                ),
              ),
              12.width,
              Expanded(
                child: _buildMacroColumn(
                  languages.lblCarbs.validate(),
                  currentCarbs,
                  targetCarbs,
                  carbsProgress,
                  barBg,
                  progressColor,
                ),
              ),
              12.width,
              Expanded(
                child: _buildMacroColumn(
                  languages.lblFat.validate(),
                  currentFats,
                  targetFats,
                  fatsProgress,
                  barBg,
                  progressColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildKcalGraphWithMarkers(
    double width,
    double maxValue,
    Color barBg,
    Color progressColor,
  ) {
    final double currentRatio = (currentKcal / maxValue).clamp(0.0, 1.0);
    final double fromRatio = (fromKcal / maxValue).clamp(0.0, 1.0);
    final double toRatio = (toKcal / maxValue).clamp(0.0, 1.0);

    return Column(
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Container(height: 14, width: width, color: barBg),
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Container(
                height: 14,
                width: width * currentRatio,
                color: progressColor,
              ),
            ),
            if (fromKcal > 0)
              Positioned(
                left: width * fromRatio,
                child: Container(height: 14, width: 2, color: Colors.black54),
              ),
            if (toKcal > 0)
              Positioned(
                left: width * toRatio,
                child: Container(height: 14, width: 2, color: Colors.black54),
              ),
          ],
        ),
        4.height,
        SizedBox(
          height: 20,
          width: width,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              if (fromKcal > 0)
                Positioned(
                  left: (width * fromRatio) - 15,
                  child: SizedBox(
                    width: 30,
                    child: Text(
                      _formatNumber(fromKcal.toInt()),
                      textAlign: TextAlign.center,
                      style: secondaryTextStyle(size: 10),
                    ),
                  ),
                ),
              if (toKcal > 0)
                Positioned(
                  left: (width * toRatio) - 15,
                  child: SizedBox(
                    width: 30,
                    child: Text(
                      _formatNumber(toKcal.toInt()),
                      textAlign: TextAlign.center,
                      style: secondaryTextStyle(size: 10),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMacroColumn(
    String label,
    int current,
    int target,
    double progress,
    Color barBg,
    Color progressColor,
  ) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label, style: secondaryTextStyle(size: 12)),
      4.height,
      Text('$current / $target g', style: boldTextStyle(size: 12)),
      8.height,
      ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: SizedBox(
          height: 6,
          width: double.infinity,
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: barBg,
            valueColor: AlwaysStoppedAnimation<Color>(progressColor),
            minHeight: 6,
          ),
        ),
      ),
    ],
  );
}
