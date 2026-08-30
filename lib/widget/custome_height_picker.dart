import '../utils/shared_import.dart';

class CustomHeightPicker extends StatefulWidget {
  const CustomHeightPicker({super.key, required this.heightSelected});

  final ValueChanged<String> heightSelected;

  @override
  State<CustomHeightPicker> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<CustomHeightPicker> {
  int height = (userStore.heightUnit == 'cm' || userStore.heightUnit.isEmpty)
      ? (userStore.height.isEmpty ? 180 : userStore.height.toInt())
      : userStore.height.isEmpty
      ? 180
      : (userStore.height.toDouble() * 30.48).toInt();

  List<String> get _listHeightText => ["CM", "FEET"];
  final ValueNotifier<int> _tabIndexUpdateProgrammatically = ValueNotifier(
    userStore.heightUnit == 'cm' ? 0 : 1,
  );

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      backgroundColor: appStore.isDarkMode
          ? scaffoldColorDark
          : BackgroundColorImageColor,
      leading: GestureDetector(
        onTap: () {
          finish(context);
        },
        child: const Icon(Octicons.chevron_left, color: primaryColor, size: 28),
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          GestureDetector(
            onTap: () async {
              await userStore.setHeightUnit(
                _tabIndexUpdateProgrammatically.value == 0 ? 'cm' : 'feet',
              );
              log("---------------------->>>>${userStore.heightUnit}");
              await userStore.setHeight(
                "${_tabIndexUpdateProgrammatically.value == 0 ? height : (height / 30.48).toStringAsFixed(1)}",
              );
              widget.heightSelected(
                "${_tabIndexUpdateProgrammatically.value == 0 ? height : (height / 30.48).toStringAsFixed(1)}",
              );
              if (!context.mounted) return;
              finish(context);
            },
            child: const Icon(Icons.check, color: primaryColor, size: 28),
          ),
        ],
      ),
    ),
    body: Column(
      children: [
        const SizedBox(height: 20),
        ValueListenableBuilder(
          valueListenable: _tabIndexUpdateProgrammatically,
          builder: (context, currentIndex, _) => FlutterToggleTab(
            width: 50,
            borderRadius: 10,
            selectedBackgroundColors: const [primaryColor],
            selectedIndex: currentIndex,
            selectedTextStyle: const TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
            unSelectedTextStyle: const TextStyle(
              color: Colors.black,
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
            labels: _listHeightText,
            selectedLabelIndex: (index) {
              _tabIndexUpdateProgrammatically.value = index;
              // userStore.setHeightUnit(index == 0 ? 'cm' : 'feet');
              setState(() {});
            },
          ),
        ),
        const SizedBox(height: 20),
        Expanded(
          child: HeightSlider(
            sliderCircleColor: primaryColor,
            height: height,
            onChange: (val) {
              setState(() => height = val);
            },
            unit: _tabIndexUpdateProgrammatically.value == 0 ? 'CM' : 'FEET',
            tabIndex: _tabIndexUpdateProgrammatically.value,
          ),
        ),
      ],
    ),
  );
}
