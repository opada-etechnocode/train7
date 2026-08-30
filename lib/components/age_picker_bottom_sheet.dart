import '../utils/shared_import.dart';

class AgePickerBottomSheet extends StatefulWidget {
  final int initialAge;

  const AgePickerBottomSheet({super.key, required this.initialAge});

  @override
  State<AgePickerBottomSheet> createState() => _AgePickerBottomSheetState();
}

class _AgePickerBottomSheetState extends State<AgePickerBottomSheet> {
  late int mSelectedIndex;

  @override
  void initState() {
    super.initState();
    mSelectedIndex = widget.initialAge;
  }

  @override
  Widget build(BuildContext context) => Container(
      decoration: BoxDecoration(
        color: appStore.isDarkMode ? scaffoldColorDark : Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      height: 300,
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: appStore.isDarkMode ? Colors.black : const Color(0xffD9D9D9),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    color: appStore.isDarkMode ? const Color(0xffD9D9D9) : Colors.black,
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(Icons.close),
                  ),
                  Text(
                    languages.lblAge,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: appStore.isDarkMode ? const Color(0xffD9D9D9) : Colors.black,
                    ),
                  ),
                  IconButton(
                    color: appStore.isDarkMode ? const Color(0xffD9D9D9) : Colors.black,
                    onPressed: () {
                      Navigator.of(context).pop(mSelectedIndex);
                    },
                    icon: const Icon(Icons.check),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Stack(
              alignment: Alignment.center,
              children: [
                CupertinoPicker(
                  magnification: 1.4,
                  squeeze: 0.8,
                  useMagnifier: true,
                  selectionOverlay: const SizedBox(),
                  itemExtent: 32.0,
                  scrollController: FixedExtentScrollController(
                    initialItem: (widget.initialAge - 17).clamp(0, 99 - 17),
                  ),
                  onSelectedItemChanged: (int selectedItem) {
                    setState(() {
                      mSelectedIndex = selectedItem + 17;
                    });
                  },
                  children: List<Widget>.generate(99 - 17 + 1, (int index) {
                    final int actualIndex = index + 17;
                    return Text(
                      actualIndex.toString(),
                      style: boldTextStyle(size: 30),
                    ).center();
                  }),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(height: 2, width: 100, color: primaryColor),
                    50.height,
                    Container(height: 2, width: 100, color: primaryColor),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
}
