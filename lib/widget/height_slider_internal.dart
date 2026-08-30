import '../utils/shared_import.dart';

class HeightSliderInternal extends StatelessWidget {
  final int height;
  final int tabIndex;
  final String unit;
  final Color primaryColor;
  final Color accentColor;
  final Color currentHeightTextColor;
  final Color sliderCircleColor;

  const HeightSliderInternal({
    super.key,
    required this.height,
    required this.tabIndex,
    required this.unit,
    required this.primaryColor,
    required this.accentColor,
    required this.currentHeightTextColor,
    required this.sliderCircleColor,
  });

  @override
  Widget build(BuildContext context) => IgnorePointer(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SliderLabel(
          height: height,
          tabIndex: tabIndex,
          unit: unit,
          currentHeightTextColor: currentHeightTextColor,
        ),
        Row(
          children: <Widget>[
            SliderCircle(sliderCircleColor: sliderCircleColor),
            Expanded(child: SliderLine(primaryColor: primaryColor)),
          ],
        ),
      ],
    ),
  );
}

class SliderLabel extends StatelessWidget {
  final int height;
  final int tabIndex;
  final String unit;
  final Color currentHeightTextColor;

  const SliderLabel({
    super.key,
    required this.height,
    required this.tabIndex,
    required this.unit,
    required this.currentHeightTextColor,
  });

  @override
  Widget build(BuildContext context) => Center(
    child: Text(
      "${tabIndex == 0 ? height : (height / 30.48).toStringAsFixed(1)} $unit",
      style: TextStyle(
        fontSize: 16.0,
        color: currentHeightTextColor,
        fontWeight: FontWeight.w600,
      ),
    ),
  );
}

class SliderLine extends StatelessWidget {
  final Color primaryColor;

  const SliderLine({super.key, required this.primaryColor});

  @override
  Widget build(BuildContext context) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: List.generate(
      40,
      (i) => Expanded(
        child: Container(
          height: 2.0,
          decoration: BoxDecoration(
            color: i.isEven ? primaryColor : Colors.white,
          ),
        ),
      ),
    ),
  );
}

class SliderCircle extends StatelessWidget {
  final Color sliderCircleColor;

  const SliderCircle({super.key, required this.sliderCircleColor});

  @override
  Widget build(BuildContext context) => Container(
    width: 32.0,
    height: 32.0,
    decoration: BoxDecoration(color: sliderCircleColor, shape: BoxShape.circle),
    child: const Icon(Icons.unfold_more, color: Colors.white, size: 0.6 * 32.0),
  );
}
