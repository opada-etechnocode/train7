import '../utils/shared_import.dart';

class PaymentGatewayList extends StatelessWidget {
  final List<PaymentModel> paymentList;
  final String? selectedPaymentType;
  final void Function(String?) onPaymentTypeSelected;

  const PaymentGatewayList({
    super.key,
    required this.paymentList,
    this.selectedPaymentType,
    required this.onPaymentTypeSelected,
  });

  @override
  Widget build(BuildContext context) {
    if (paymentList.isEmpty) {
      return const NoDataScreen();
    }

    return AnimatedListView(
      shrinkWrap: true,
      itemCount: paymentList.length,
      padding: const EdgeInsets.all(16),
      itemBuilder: (context, index) {
        final paymentItem = paymentList[index];
        return PaymentGatewayItem(
          paymentItem: paymentItem,
          selectedPaymentType: selectedPaymentType,
          onTap: () => onPaymentTypeSelected(paymentItem.type),
        );
      },
    );
  }
}
