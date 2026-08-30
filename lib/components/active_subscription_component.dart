import '../utils/shared_import.dart';

class ActiveSubscriptionComponent extends StatelessWidget {
  final SubscriptionPlan plan;
  final VoidCallback onCancel;

  const ActiveSubscriptionComponent({
    super.key,
    required this.plan,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
      child: Column(
        children: [
          16.height,
          Container(
            padding: const EdgeInsets.all(16),
            decoration: boxDecorationWithRoundedCorners(
              backgroundColor: appStore.isDarkMode ? cardDarkColor : GreenColor.withValues(alpha: 0.10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(plan.programName ?? '', style: boldTextStyle()).expand(),
                    PriceWidget(
                      price: plan.totalAmount?.validate().toStringAsFixed(2),
                      color: primaryColor,
                      textStyle: boldTextStyle(color: primaryColor, size: 20),
                    ),
                  ],
                ),
                Text(
                  "${languages.lblYourPlanValid} ${parseDocumentDate(DateTime.parse(plan.subscriptionStartDate.validate()))} ${languages.lblTo} ${parseDocumentDate(DateTime.parse(plan.subscriptionEndDate.validate()))}",
                  style: primaryTextStyle(color: primaryColor, size: 12),
                ),
                8.height,
                HtmlWidget(postContent: plan.programData!.description.validate()),
                16.height,
              ],
            ),
          ),
          24.height,
          AppButton(
            text: languages.lblCancelSubscription,
            width: context.width(),
            color: primaryOpacity,
            textColor: primaryColor,
            onTap: onCancel,
          ),
        ],
      ).paddingSymmetric(horizontal: 16),
    );

}
