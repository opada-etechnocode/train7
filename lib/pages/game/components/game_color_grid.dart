
import '../../../utils/shared_import.dart';

class GameColorGrid extends StatelessWidget {
  final int gridSize;
  final int targetIndex;
  final Color? targetColor;
  final Color? dummyColor;
  final List<GlobalKey> boxKeys;
  final ValueChanged<int> onCellTap;

  const GameColorGrid({
    super.key,
    required this.gridSize,
    required this.targetIndex,
    required this.targetColor,
    required this.dummyColor,
    required this.boxKeys,
    required this.onCellTap,
  });

  @override
  Widget build(BuildContext context) =>
     Flexible(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: GridView.count(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          crossAxisCount: gridSize,
          children: List.generate(
            pow(gridSize, 2) as int,
            (index) => _buildCell(index),
          ),
        ),
      ),
    );


  Widget _buildCell(int index) {
    final bool isTarget = targetIndex == index;
    final Color? cellColor = isTarget ? targetColor : dummyColor;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () => onCellTap(index),
        child: Ink(
          key: boxKeys[index],
          decoration: ShapeDecoration(
            color: cellColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            shadows: [
              BoxShadow(
                color: cellColor!.withValues(alpha: 0.3),
                blurRadius: 10.0,
                spreadRadius: 2.0,
              ),
              BoxShadow(
                color: cellColor.withValues(alpha: 0.3),
                blurRadius: 20.0,
                spreadRadius: 5.0,
              ),
            ],
          ),
          height: 50,
          width: 50,
        ),
      ),
    );
  }
}
