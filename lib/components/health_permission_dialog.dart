import '../utils/shared_import.dart';

class HealthPermissionDialog extends StatelessWidget {
  final VoidCallback onConnect;

  const HealthPermissionDialog({super.key, required this.onConnect});

  @override
  Widget build(BuildContext context) => Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );


  Widget contentBox(BuildContext context) => Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(color: Colors.black26, offset: Offset(0, 10), blurRadius: 10),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: primaryColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.favorite, color: primaryColor, size: 40),
          ),
          20.height,
          Text(
            languages.lblAppleHealthIntegration,
            style: boldTextStyle(size: 22),
            textAlign: TextAlign.center,
          ),
          16.height,
          Text(
            "This app uses Apple Health (HealthKit) to read your step count and track your daily activity.",
            style: secondaryTextStyle(size: 16),
            textAlign: TextAlign.center,
          ),
          20.height,
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(languages.lblDataaccessed, style: boldTextStyle(size: 14)),
            ],
          ),
          8.height,
          Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.green, size: 18),
              8.width,
              Text(languages.lblStepcount, style: primaryTextStyle(size: 14)),
            ],
          ),
          20.height,
          Text(
            "Your health data stays on your device and is not stored on our servers.",
            style: secondaryTextStyle(size: 12),
            textAlign: TextAlign.center,
          ),
          24.height,
          AppButton(
            text: languages.lblConnectAppleHealth,
            width: context.width(),
            color: primaryColor,
            textStyle: boldTextStyle(color: white),
            onTap: () {
              finish(context);
              onConnect();
            },
            shapeBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          10.height,
          TextButton(
            onPressed: () {
              finish(context);
            },
            child: Text(languages.lblCancel.validate(), style: secondaryTextStyle()),
          ),
        ],
      ),
    );

}
