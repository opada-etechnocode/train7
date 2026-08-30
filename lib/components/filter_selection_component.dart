import '../utils/shared_import.dart';

class FilterSelectionComponent extends StatelessWidget {
  final List<WorkoutFilterList> filterList;
  final void Function(int) onSelect;
  final List<LevelModel> mLevelList;
  final List<WorkoutTypeModel> mWorkoutTypesList;
  final void Function(List<int>) onFilterCall;

  const FilterSelectionComponent({
    super.key,
    required this.filterList,
    required this.onSelect,
    required this.mLevelList,
    required this.mWorkoutTypesList,
    required this.onFilterCall,
  });

  @override
  Widget build(BuildContext context) => HorizontalList(
      itemCount: filterList.length,
      padding: const EdgeInsets.only(left: 16, right: 8),
      itemBuilder: (context, index) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        decoration: boxDecorationWithRoundedCorners(
          backgroundColor: filterList[index].select! ? primaryColor : context.scaffoldBackgroundColor,
          borderRadius: radius(24),
          border: Border.all(
            color: filterList[index].select! ? primaryColor : Colors.grey,
          ),
        ),
        child: Text(
          filterList[index].title.toString(),
          style: secondaryTextStyle(
            color: filterList[index].select! ? Colors.white : Colors.grey,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ).onTap(() async {
        onSelect(index);
        if (filterList[index].id != 0) {
          await showModalBottomSheet<void>(
            isScrollControlled: true,
            context: context,
            useSafeArea: true,
            backgroundColor: appStore.isDarkMode ? cardDarkColor : context.cardColor,
            shape: RoundedRectangleBorder(
              borderRadius: radiusOnly(topRight: 18, topLeft: 18),
            ),
            builder: (BuildContext context) => FilterWorkoutBottomSheet(
              listId: filterList[index].id,
              mLevelList: mLevelList,
              mWorkoutTypesList: mWorkoutTypesList,
              onCall: onFilterCall,
            ),
          );
        }
      }),
    );
}
