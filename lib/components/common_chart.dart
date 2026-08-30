import '../utils/shared_import.dart';

class CommonColumnChart extends StatelessWidget {
  final String yAxisTitle;
  final String tooltipUnit;
  final List<WaterGraphData> data;
  final String achievedLabel;
  final String goalLabel;
  final double yInterval;

  const CommonColumnChart({
    super.key,
    required this.yAxisTitle,
    required this.tooltipUnit,
    required this.data,
    required this.achievedLabel,
    required this.goalLabel,
    required this.yInterval,
  });

  @override
  Widget build(BuildContext context) => SfCartesianChart(
    /// 🟦 LEGEND
    legend: Legend(
      isVisible: true,
      position: LegendPosition.bottom,
      textStyle: primaryTextStyle(
        size: 14,
        color: appStore.isDarkMode ? Colors.white : Colors.black,
      ),
    ),

    /// 🟨 X-AXIS
    primaryXAxis: CategoryAxis(
      majorGridLines: const MajorGridLines(width: 0),
      labelRotation: -45,
      labelStyle: primaryTextStyle(
        size: 13,
        color: appStore.isDarkMode ? Colors.white : Colors.black,
      ),
      autoScrollingDelta: 6,
    ),

    /// 🟪 Y-AXIS
    primaryYAxis: NumericAxis(
      title: AxisTitle(
        text: yAxisTitle,
        textStyle: primaryTextStyle(
          size: 14,
          color: appStore.isDarkMode ? Colors.white : Colors.black,
        ),
      ),
      interval: yInterval,
      labelStyle: primaryTextStyle(
        size: 12,
        color: appStore.isDarkMode ? Colors.white : Colors.black87,
      ),
      majorGridLines: MajorGridLines(
        width: 1,
        color: appStore.isDarkMode ? Colors.white30 : Colors.grey.shade300,
      ),
    ),

    /// 🔍 TOOLTIP
    tooltipBehavior: TooltipBehavior(
      enable: true,
      format: 'point.x : point.y $tooltipUnit',
    ),

    /// 🔎 ZOOM & PAN
    zoomPanBehavior: ZoomPanBehavior(
      enablePanning: true,
      enablePinching: true,
      zoomMode: ZoomMode.x,
    ),

    /// 📊 SERIES
    series: <ColumnSeries<WaterGraphData, String>>[
      ColumnSeries<WaterGraphData, String>(
        name: achievedLabel,
        dataSource: data,
        xValueMapper: (d, _) =>
            DateFormat('dd MMM').format(DateTime.parse(d.date.validate())),
        yValueMapper: (d, _) => d.value,
        width: 0.28,
        borderRadius: BorderRadius.circular(8),
        gradient: LinearGradient(
          colors: [Colors.grey.shade300, Colors.grey.shade500],
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
        ),
        dataLabelSettings: const DataLabelSettings(isVisible: true),
      ),

      /// 🎯 GOAL
      ColumnSeries<WaterGraphData, String>(
        name: goalLabel,
        dataSource: data,
        xValueMapper: (d, _) =>
            DateFormat('dd MMM').format(DateTime.parse(d.date.validate())),
        yValueMapper: (d, _) => d.todayGoal,
        width: 0.28,
        borderRadius: BorderRadius.circular(8),
        gradient: const LinearGradient(
          colors: [primaryLightColor, primaryColor],
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
        ),
        dataLabelSettings: const DataLabelSettings(isVisible: true),
      ),
    ],
  );
}
