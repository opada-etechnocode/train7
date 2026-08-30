import '../utils/shared_import.dart';

class PaymentGatewayItem extends StatelessWidget {
  final PaymentModel paymentItem;
  final String? selectedPaymentType;
  final VoidCallback onTap;

  const PaymentGatewayItem({
    super.key,
    required this.paymentItem,
    this.selectedPaymentType,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool isSelected = selectedPaymentType == paymentItem.type;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 16,
      ),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: boxDecorationWithRoundedCorners(
        border: Border.all(
          width: 0.5,
          color: isSelected
              ? primaryColor.withValues(alpha: 0.80)
              : GreyLightColor,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              cachedImage(
                paymentItem.gatewayLogo!,
                width: 35,
                height: 35,
                fit: BoxFit.contain,
              ),
              12.width,
              Text(
                paymentItem.title.validate().capitalizeFirstLetter(),
                style: primaryTextStyle(),
                maxLines: 2,
              ),
            ],
          ).expand(),
          if (isSelected)
            Container(
              padding: const EdgeInsets.all(0),
              decoration: boxDecorationWithRoundedCorners(
                backgroundColor: primaryColor,
                borderRadius: radius(8),
              ),
              child: const Icon(
                Icons.check,
                color: Colors.white,
              ),
            ),
        ],
      ),
    ).onTap(onTap);
  }
}
