import 'package:my_fatoorah_payment_flutter/myfatoorah_flutter.dart';

import '../utils/shared_import.dart';

class MyFatoorahPaymentResult {
  final bool success;
  final String? invoiceId;
  final String? invoiceStatus;
  final String? message;

  const MyFatoorahPaymentResult({
    required this.success,
    this.invoiceId,
    this.invoiceStatus,
    this.message,
  });
}

class MyFatoorahPaymentService {
  static String get _language =>
      appStore.selectedLanguageCode == 'ar'
          ? MFLanguage.ARABIC
          : MFLanguage.ENGLISH;

  static Future<void> init({
    String? token,
    bool isTest = MYFATOORAH_IS_TEST,
  }) async {
    final String apiToken =
        (token != null && token.trim().isNotEmpty) ? token.trim() : MYFATOORAH_TOKEN;

    await MFSDK.init(
      apiToken,
      MFCountry.UAE,
      isTest ? MFEnvironment.TEST : MFEnvironment.LIVE,
    );

    await MFSDK.setUpActionBar(
      toolBarTitle: languages.lblPayments,
      toolBarTitleColor: '#FFFFFF',
      toolBarBackgroundColor: '#c5983d',
      isShowToolBar: true,
    );
  }

  /// Opens MyFatoorah methods sheet then executes payment.
  /// Returns null if user cancels method selection.
  static Future<MyFatoorahPaymentResult?> pay({
    required BuildContext context,
    required num amount,
    String? token,
    bool isTest = MYFATOORAH_IS_TEST,
  }) async {
    if (amount <= 0) {
      return const MyFatoorahPaymentResult(
        success: false,
        message: 'Invalid amount',
      );
    }

    try {
      await init(token: token, isTest: isTest);

      final MFInitiatePaymentResponse initiate =
          await MFSDK.initiatePayment(
        MFInitiatePaymentRequest(
          invoiceAmount: amount,
          currencyIso: MFCurrencyISO.UAE_AED,
        ),
        _language,
      );

      final List<MFPaymentMethod> methods = initiate.paymentMethods ?? [];
      if (methods.isEmpty) {
        return const MyFatoorahPaymentResult(
          success: false,
          message: 'No payment methods available',
        );
      }

      if (!context.mounted) return null;

      final MFPaymentMethod? selected = await showModalBottomSheet<MFPaymentMethod>(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (ctx) => _MyFatoorahMethodsSheet(methods: methods),
      );

      if (selected == null) return null;

      final MFExecutePaymentRequest request = MFExecutePaymentRequest(
        invoiceValue: amount,
      );
      request.paymentMethodId = selected.paymentMethodId;

      String? callbackInvoiceId;
      final MFGetPaymentStatusResponse response = await MFSDK.executePayment(
        request,
        _language,
        (invoiceId) {
          callbackInvoiceId = invoiceId;
        },
      );

      final String status = response.invoiceStatus?.toLowerCase() ?? '';
      final bool paid = status == 'paid';
      final String invoiceId =
          '${response.invoiceId ?? callbackInvoiceId ?? ''}';

      return MyFatoorahPaymentResult(
        success: paid,
        invoiceId: invoiceId.isEmpty ? null : invoiceId,
        invoiceStatus: response.invoiceStatus,
        message: paid ? null : (response.invoiceStatus ?? 'Payment failed'),
      );
    } on Exception catch (e) {
      log('MyFatoorah pay error: $e');
      return MyFatoorahPaymentResult(
        success: false,
        message: e.toString(),
      );
    }
  }
}

class _MyFatoorahMethodsSheet extends StatelessWidget {
  final List<MFPaymentMethod> methods;

  const _MyFatoorahMethodsSheet({required this.methods});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: context.dividerColor,
              borderRadius: radius(8),
            ),
          ),
          16.height,
          Text(languages.lblPayments, style: boldTextStyle(size: 18)),
          12.height,
          ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.45,
            ),
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: methods.length,
              separatorBuilder: (_, __) => 8.height,
              itemBuilder: (context, index) {
                final MFPaymentMethod method = methods[index];
                final String title = appStore.selectedLanguageCode == 'ar'
                    ? (method.paymentMethodAr ?? method.paymentMethodEn ?? '')
                    : (method.paymentMethodEn ?? method.paymentMethodAr ?? '');

                return ListTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: radius(12),
                    side: BorderSide(color: context.dividerColor),
                  ),
                  leading: method.imageUrl.validate().isNotEmpty
                      ? cachedImage(
                          method.imageUrl.validate(),
                          width: 36,
                          height: 36,
                          fit: BoxFit.contain,
                        )
                      : const Icon(Icons.payment, color: primaryColor),
                  title: Text(title, style: boldTextStyle(size: 14)),
                  onTap: () => Navigator.pop(context, method),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
