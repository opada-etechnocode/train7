import '../service/myfatoorah_payment_service.dart';
import '../utils/shared_import.dart';

class SubscribeProgramBottomSheet extends StatefulWidget {
  final ProgramModel program;
  final bool popOnSuccess;

  const SubscribeProgramBottomSheet({
    super.key,
    required this.program,
    this.popOnSuccess = false,
  });

  @override
  State<SubscribeProgramBottomSheet> createState() =>
      _SubscribeProgramBottomSheetState();
}

class _SubscribeProgramBottomSheetState
    extends State<SubscribeProgramBottomSheet> {
  bool isFollowUp = false;
  bool isSubmitting = false;

  num get basePrice => widget.program.price ?? 0;

  num get followUpPrice => widget.program.followUpPrice ?? 0;

  bool get hasFollowUpOption => widget.program.followUpPrice != null;

  num get totalPrice =>
      isFollowUp && hasFollowUpOption ? basePrice + followUpPrice : basePrice;

  Future<void> _confirmSubscribe() async {
    if (isSubmitting) return;
    if (!userStore.isLoggedIn) {
      const SignInScreen().launch<void>(context);
      return;
    }

    final bool followUp = hasFollowUpOption ? isFollowUp : false;
    final ProgramModel program = widget.program;
    final bool popOnSuccess = widget.popOnSuccess;
    final num amount = totalPrice;

    // Free programs: subscribe directly
    if (amount <= 0) {
      setState(() => isSubmitting = true);
      await _subscribePackage(
        program: program,
        followUp: followUp,
        paymentType: 'free',
        txnId: '',
        popOnSuccess: popOnSuccess,
        closeSheetFirst: true,
      );
      return;
    }

    // Paid: close options sheet, then open MyFatoorah methods dialog
    setState(() => isSubmitting = true);
    Navigator.pop(context);

    final BuildContext? payContext = navigatorKey.currentContext;
    if (payContext == null || !payContext.mounted) return;

    appStore.setLoading(true);
    final MyFatoorahPaymentResult? result = await MyFatoorahPaymentService.pay(
      context: payContext,
      amount: amount,
    );
    appStore.setLoading(false);

    if (result == null) return; // user cancelled method sheet

    if (!result.success) {
      toast(result.message ?? languages.lblPaymentFailed);
      return;
    }

    await _subscribePackage(
      program: program,
      followUp: followUp,
      paymentType: PAYMENT_TYPE_MYFATOORAH,
      txnId: result.invoiceId ?? '',
      popOnSuccess: popOnSuccess,
      closeSheetFirst: false,
      hostContext: payContext,
    );
  }

  Future<void> _subscribePackage({
    required ProgramModel program,
    required bool followUp,
    required String paymentType,
    required String txnId,
    required bool popOnSuccess,
    required bool closeSheetFirst,
    BuildContext? hostContext,
  }) async {
    appStore.setLoading(true);

    final Map<String, dynamic> req = {
      "package_id": program.id,
      "is_follow_up": followUp,
      "payment_status": "paid",
      "payment_type": paymentType,
      "txn_id": txnId,
      "transaction_detail": txnId,
    };

    await subscribeProgramApi(req)
        .then((value) async {
          toast(value.message);
          final BuildContext? ctx = hostContext ??
              (mounted ? context : navigatorKey.currentContext);
          if (ctx == null || !ctx.mounted) {
            appStore.setLoading(false);
            return;
          }

          await getUSerDetail(ctx, userStore.userId).whenComplete(() async {
            appStore.setLoading(false);
            LiveStream().emit(PAYMENT);

            if (closeSheetFirst && ctx.mounted) {
              Navigator.pop(ctx);
            }

            if (!ctx.mounted) return;
            await ProgramDetailScreen(program: program).launch<void>(ctx);
            if (popOnSuccess && ctx.mounted) {
              finish(ctx);
            }
          });
        })
        .catchError((Object e) {
          if (mounted) setState(() => isSubmitting = false);
          appStore.setLoading(false);
          toast(e.toString());
          log(e.toString());
        });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        decoration: BoxDecoration(
          color: context.scaffoldBackgroundColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: context.dividerColor,
                  borderRadius: radius(8),
                ),
              ),
            ),
            16.height,
            Text(
              widget.program.name.validate(),
              style: boldTextStyle(size: 20),
            ),
            8.height,
            Row(
              children: [
                Text(
                  languages.lblTotal,
                  style: secondaryTextStyle(size: 14),
                ),
                const Spacer(),
                PriceWidget(
                  price: totalPrice.toStringAsFixed(2),
                  color: primaryColor,
                  textStyle: boldTextStyle(color: primaryColor, size: 22),
                ),
              ],
            ),
            if (isFollowUp && hasFollowUpOption) ...[
              4.height,
              Text(
                '${languages.lblProgramPrice}: ${basePrice.toStringAsFixed(2)} + ${languages.lblFollowUp}: ${followUpPrice.toStringAsFixed(2)}',
                style: secondaryTextStyle(size: 12),
              ),
            ],
            if (hasFollowUpOption) ...[
              20.height,
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: boxDecorationWithRoundedCorners(
                  borderRadius: radius(12),
                  backgroundColor: context.cardColor,
                  border: Border.all(color: context.dividerColor),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Flexible(
                            child: Text(
                              languages.lblFollowUp,
                              style: boldTextStyle(size: 16),
                            ),
                          ),
                          6.width,
                          Icon(
                            Icons.help_outline,
                            size: 18,
                            color: textSecondaryColorGlobal,
                          ).withTooltip(msg: languages.lblFollowUpTooltip),
                          8.width,
                          Text(
                            '+${followUpPrice.toStringAsFixed(2)}',
                            style: secondaryTextStyle(
                              color: primaryColor,
                              size: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Switch(
                      value: isFollowUp,
                      activeThumbColor: primaryColor,
                      onChanged: (value) {
                        setState(() => isFollowUp = value);
                      },
                    ),
                  ],
                ),
              ),
            ],
            24.height,
            AppButton(
              text: languages.lblConfirm,
              width: context.width(),
              color: primaryColor,
              enabled: !isSubmitting,
              onTap: _confirmSubscribe,
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> showSubscribeProgramBottomSheet(
  BuildContext context,
  ProgramModel program, {
  bool popOnSuccess = false,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => SubscribeProgramBottomSheet(
      program: program,
      popOnSuccess: popOnSuccess,
    ),
  );
}
