import '../utils/shared_import.dart';

enum ChartType { CHART1, CHART2, CHART3 }

class HorizontalBarChart extends StatelessWidget {
  final List<GraphModel>? seriesList;

  HorizontalBarChart(this.seriesList, {super.key});

  final List<GraphModel> data = [];

  @override
  Widget build(BuildContext context) => SfCartesianChart(
    legend: const Legend(isVisible: true),
    series: getDefaultData3(),
    backgroundColor: context.cardColor,
    zoomPanBehavior: ZoomPanBehavior(maximumZoomLevel: 0.85),
    selectionType: SelectionType.series,
    primaryXAxis: const CategoryAxis(
      interval: 1,
      isInversed: true,
      axisLine: AxisLine(color: primaryColor),
    ),
    enableAxisAnimation: true,
    tooltipBehavior: TooltipBehavior(enable: true),
  );

  List<CartesianSeries<GraphModel, String>> getDefaultData3() {
    // List<ChartSeries> getDefaultData3() {
    final List<GraphModel> chartData = [];
    seriesList?.forEach((element) {
      log("-------------------->>>${element.value}");
      chartData.add(
        GraphModel(
          date: element.date,
          value: element.value?.replaceAll('user', '').trim(),
        ),
      );
    });
    return <CartesianSeries<GraphModel, String>>[
      SplineAreaSeries<GraphModel, String>(
        dataSource: chartData,
        isVisibleInLegend: false,
        gradient: LinearGradient(
          colors: <Color>[
            appStore.isDarkMode == true
                ? scaffoldBackgroundColor
                : Colors.white,
            primaryColor,
          ],
          stops: const <double>[0.03, 0.9],
          end: Alignment.topCenter,
          begin: Alignment.bottomCenter,
        ),
        borderColor: primaryColor,
        borderDrawMode: BorderDrawMode.excludeBottom,
        animationDuration: 1000,
        dataLabelSettings: const DataLabelSettings(
          isVisible: true,
          labelPosition: ChartDataLabelPosition.outside,
        ),
        markerSettings: const MarkerSettings(
          isVisible: true,
          height: 4,
          width: 4,
          borderColor: primaryColor,
        ),
        xValueMapper: (GraphModel data, _) => data.date.toString(),
        yValueMapper: (GraphModel data, _) =>
            double.parse(data.value.toString()),
        emptyPointSettings: const EmptyPointSettings(
          mode: EmptyPointMode.average,
        ),
      ),
    ];
  }
}
