import '../utils/shared_import.dart';

class SubscriptionTabHeader extends StatelessWidget {
  final bool select;
  final VoidCallback onTap;

  const SubscriptionTabHeader({
    super.key,
    required this.select,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) => Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: context.dividerColor)),
      ),
      child: Row(
        children: [
          _buildTab(context, languages.lblSubscriptionPlans, select),
          _buildTab(context, languages.lblHistory, !select),
        ],
      ).paddingSymmetric(horizontal: 16),
    );

  Widget _buildTab(BuildContext context, String title, bool isSelected) => Container(
      padding: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: 1.5,
            color: isSelected ? primaryColor : Colors.transparent,
          ),
        ),
      ),
      child: Text(
        title,
        style: boldTextStyle(
          color: isSelected ? primaryColor : textSecondaryColorGlobal,
        ),
      ).center(),
    ).onTap(onTap).expand();
}
