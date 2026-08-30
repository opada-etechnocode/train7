import '../utils/shared_import.dart';

class PaymentFooter extends StatelessWidget {
  final bool isVisible;
  final VoidCallback onTap;

  const PaymentFooter({
    super.key,
    required this.isVisible,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) => Padding(
      padding: const EdgeInsets.all(16),
      child: Visibility(
        visible: isVisible,
        child: AppButton(
          text: languages.lblPay,
          color: primaryColor,
          onTap: onTap,
        ),
      ),
    );
}
