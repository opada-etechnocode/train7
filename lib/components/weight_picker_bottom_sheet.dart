import '../utils/shared_import.dart';

class WeightPickerBottomSheet extends StatefulWidget {
  final WeightType initialWeightType;
  final double initialWeight;

  const WeightPickerBottomSheet({
    super.key,
    required this.initialWeightType,
    required this.initialWeight,
  });

  @override
  State<WeightPickerBottomSheet> createState() => _WeightPickerBottomSheetState();
}

class _WeightPickerBottomSheetState extends State<WeightPickerBottomSheet> {
  late WeightType weightType;
  late double weight;

  @override
  void initState() {
    super.initState();
    weightType = widget.initialWeightType;
    weight = widget.initialWeight;
  }

  @override
  Widget build(BuildContext context) => Container(
      decoration: BoxDecoration(
        color: appStore.isDarkMode ? Colors.black : const Color(0xffD9D9D9),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      height: 250,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () => finish(context),
                icon: const Icon(Icons.close),
              ),
              Header(weightType: weightType, inKg: weight),
              IconButton(
                onPressed: () => finish(context, Tuple2(weightType, weight)),
                icon: const Icon(Icons.check),
              ),
            ],
          ).paddingSymmetric(horizontal: 8),
          Switcher(
            weightType: weightType,
            onChanged: (type) {
              setState(() {
                weightType = type;
              });
              if (type.name == languages.lblKg && weight > 200) {
                weight = 200;
              } else if (type.name != languages.lblKg && weight > 400) {
                weight = 400;
              }
            },
          ),
          const SizedBox(height: 10),
          Expanded(
            child: DivisionSlider(
              key: ValueKey(weightType.name),
              from: weightType.name == "KG" ? 40 : 90,
              max: weightType.name == "KG" ? 200 : 400,
              initialValue: weight.clamp(
                weightType.name == "KG" ? 40 : 90,
                weightType.name == "KG" ? 200 : 400,
              ),
              type: weightType,
              onChanged: (value) {
                setState(() => weight = value);
              },
            ),
          ),
        ],
      ),
    );
}
