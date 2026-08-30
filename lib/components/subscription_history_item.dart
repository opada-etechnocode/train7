import '../utils/shared_import.dart';

class SubscriptionHistoryItem extends StatelessWidget {
  final SubscriptionPlan plan;
  final Color Function(String?) getTextColor;
  final Color Function(String?) getBgColor;

  const SubscriptionHistoryItem({
    super.key,
    required this.plan,
    required this.getTextColor,
    required this.getBgColor,
  });

  Future<void> _openProgram(BuildContext context) async {
    final int? programId = plan.programId;
    if (programId == null) return;

    appStore.setLoading(true);
    try {
      final ProgramResponse response = await getPrograms();
      final List<ProgramModel> matches = response.data
              ?.where((p) => p.id == programId)
              .toList() ??
          [];
      appStore.setLoading(false);
      if (matches.isEmpty) {
        toast(languages.lblNoFoundData);
        return;
      }
      if (context.mounted) {
        await ProgramDetailScreen(program: matches.first).launch<void>(context);
      }
    } catch (e) {
      appStore.setLoading(false);
      toast(e.toString());
    }
  }

  String get _dateRange {
    try {
      return '${parseDocumentDate(DateTime.parse(plan.subscriptionStartDate.validate()))} — ${parseDocumentDate(DateTime.parse(plan.subscriptionEndDate.validate()))}';
    } catch (_) {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color statusColor = getTextColor(plan.status.validate());

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: appStore.isDarkMode
          ? boxDecorationWithRoundedCorners(borderRadius: radius(16))
          : boxDecorationRoundedWithShadow(16),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
            decoration: BoxDecoration(
              color: primaryColor.withValues(alpha: 0.08),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: primaryColor.withValues(alpha: 0.15),
                    borderRadius: radius(12),
                  ),
                  child: const Icon(
                    Icons.workspace_premium_rounded,
                    color: primaryColor,
                    size: 22,
                  ),
                ),
                12.width,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        plan.programName.validate(),
                        style: boldTextStyle(size: 16),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      4.height,
                      Text(
                        plan.paymentType.validate().capitalizeFirstLetter(),
                        style: secondaryTextStyle(size: 12),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.12),
                    borderRadius: radius(20),
                  ),
                  child: Text(
                    plan.status.validate().capitalizeFirstLetter(),
                    style: boldTextStyle(size: 11, color: statusColor),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.calendar_month_outlined,
                      size: 16,
                      color: textSecondaryColorGlobal,
                    ),
                    6.width,
                    Expanded(
                      child: Text(_dateRange, style: secondaryTextStyle(size: 12)),
                    ),
                    PriceWidget(
                      price: plan.totalAmount.validate().toStringAsFixed(2),
                      color: primaryColor,
                      textStyle: boldTextStyle(color: primaryColor, size: 16),
                    ),
                  ],
                ),
                if (plan.isFollowUp == true) ...[
                  10.height,
                  Row(
                    children: [
                      Icon(
                        Icons.support_agent_rounded,
                        size: 16,
                        color: primaryColor,
                      ),
                      6.width,
                      Text(
                        languages.lblFollowUp,
                        style: secondaryTextStyle(size: 12, color: primaryColor),
                      ),
                    ],
                  ),
                ],
                14.height,
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () => _openProgram(context),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: primaryColor,
                      side: const BorderSide(color: primaryColor),
                      shape: RoundedRectangleBorder(borderRadius: radius(12)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Text(
                      languages.lblEnterProgram,
                      style: boldTextStyle(color: primaryColor, size: 14),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
