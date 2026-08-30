import '../utils/shared_import.dart';

/// Displays the sets/reps and rest info for an exercise.
class ExerciseSetsDisplay extends StatelessWidget {
  final ExerciseDetailResponse exerciseModel;
  final bool isLBSClicked;
  final bool isKGClicked;

  const ExerciseSetsDisplay({
    super.key,
    required this.exerciseModel,
    required this.isLBSClicked,
    required this.isKGClicked,
  });

  Widget _dividerLine({bool isSmall = false}) => Container(
        height: isSmall ? 40 : 65,
        width: 4,
        color: Colors.transparent,
      );

  Widget _setTextWidget(
    BuildContext context,
    String value, {
    String? value2,
  }) {
    if (isLBSClicked && !isKGClicked) {
      final double kgValue = double.tryParse(value2 ?? " ") ?? 0;
      final double lbsValue = kgValue * 2.20462;
      value2 = lbsValue.toStringAsFixed(2);
    }
    return value2.isEmptyOrNull || value2 == '0.00'
        ? Text(value, style: boldTextStyle()).center()
        : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(value, style: boldTextStyle()),
              2.height,
              Text(
                "- ${value2?.validate() ?? '0'} ${isLBSClicked ? languages.lblLbs : languages.lblKg}",
                style: primaryTextStyle(size: 14),
              ),
            ],
          );
  }

  String _repsOrTime(Sets set) => exerciseModel.data?.based == "reps"
        ? "${set.reps.validate()}x"
        : "${set.time.validate()}s";

  @override
  Widget build(BuildContext context) {
    final sets = exerciseModel.data?.sets;
    final isDark = appStore.isDarkMode;
    final containerDecor = boxDecorationWithRoundedCorners(
      borderRadius: radius(),
      backgroundColor:
          isDark ? cardDarkColor : GreyLightColor.withValues(alpha: 0.3),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Reps/Weight section
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            languages.lblRepsWeight,
            style: secondaryTextStyle(weight: FontWeight.bold, size: 12),
          ),
        ),
        4.height,
        Container(
          width: context.width(),
          decoration: containerDecor,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: _buildSetsRow(context, sets, isRest: false),
        ),
        4.height,
        // Rest section
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            languages.lblRest,
            style: secondaryTextStyle(weight: FontWeight.bold, size: 12),
          ),
        ),
        4.height,
        Container(
          width: context.width(),
          decoration: containerDecor,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: _buildSetsRow(context, sets, isRest: true),
        ),
      ],
    );
  }

  Widget _buildSetsRow(
    BuildContext context,
    List<Sets>? sets, {
    required bool isRest,
  }) {
    if (sets == null || sets.isEmpty) {
      return SizedBox(child: Text(languages.lblNoSetsMsg).center());
    }

    String getValue(Sets s) =>
        isRest ? "${s.rest.validate()}s" : _repsOrTime(s);

    String? getWeight(Sets s) => isRest ? null : s.weight.validate();

    if (sets.length == 1) {
      return _setTextWidget(context, getValue(sets[0]),
          value2: getWeight(sets[0]));
    } else if (sets.length <= 3) {
      return Row(
        children: [
          for (int i = 0; i < sets.length; i++) ...[
            if (i > 0) _dividerLine(isSmall: isRest),
            _setTextWidget(context, getValue(sets[i]),
                    value2: getWeight(sets[i]))
                .expand(),
          ],
        ],
      );
    } else {
      return HorizontalList(
        itemCount: sets.length,
        itemBuilder: (context, index) => Row(
          children: [
            16.width,
            _setTextWidget(context, getValue(sets[index]),
                value2: getWeight(sets[index])),
            16.width,
            _dividerLine(isSmall: isRest),
            16.width,
          ],
        ),
      );
    }
  }
}
