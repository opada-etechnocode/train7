import '../utils/shared_import.dart';

class ProgramCardClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    const double topRadius = 22;
    final Path path = Path();

    path.moveTo(0, topRadius);
    path.quadraticBezierTo(0, 0, topRadius, 0);
    path.lineTo(size.width - topRadius, 0);
    path.quadraticBezierTo(size.width, 0, size.width, topRadius);
    path.lineTo(size.width, size.height * 0.78);
    path.cubicTo(
      size.width * 0.92,
      size.height * 0.92,
      size.width * 0.55,
      size.height,
      0,
      size.height * 0.90,
    );
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

class ProgramCardComponent extends StatelessWidget {
  final ProgramModel program;
  final bool popOnSuccess;

  const ProgramCardComponent({
    super.key,
    required this.program,
    this.popOnSuccess = false,
  });

  String get _durationText {
    final String unit = program.durationUnit.toString() == 'monthly'
        ? languages.lblMonth
        : program.durationUnit.validate().capitalizeFirstLetter();
    return '${program.duration ?? '-'} $unit';
  }

  String get _plainDescription {
    final String html = program.description.validate();
    if (html.isEmpty) return '';
    try {
      return parse(html).body?.text.replaceAll(RegExp(r'\s+'), ' ').trim() ??
          html;
    } catch (_) {
      return html;
    }
  }

  String _formatMoney(num value) {
    final String currency = getStringAsync(CurrencySymbol, defaultValue: '');
    final String amount = value.toStringAsFixed(0);
    if (currency.isEmpty) return amount;
    return userStore.currencyPosition == 'left'
        ? '$currency $amount'
        : '$amount $currency';
  }

  bool get _canEnterProgram {
    if (userStore.isSubscribe != 1) return false;
    final int? subscribedId =
        userStore.subscriptionDetail?.subscriptionPlan?.programId;
    return subscribedId != null && subscribedId == program.id;
  }

  List<_ProgramFeature> get _features {
    return [
      _ProgramFeature(
        label: '${languages.lblDuration}: $_durationText',
        included: true,
      ),
      if (program.foodRecognitionLimit != null)
        _ProgramFeature(
          label:
              '${languages.lblFoodRecognitionLimit}: ${program.foodRecognitionLimit}',
          included: true,
        ),
      if (program.followUpPrice != null)
        _ProgramFeature(
          label:
              '${languages.lblFollowUp}: ${_formatMoney(program.followUpPrice!)}',
          included: true,
        ),
    ];
  }

  Widget _featureRow(_ProgramFeature feature) {
    final Color textColor = feature.included
        ? Colors.white
        : Colors.white.withValues(alpha: 0.45);
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: feature.included
                  ? Colors.white
                  : Colors.white.withValues(alpha: 0.25),
            ),
            child: Icon(
              Icons.check,
              size: 14,
              color: feature.included
                  ? primaryColor
                  : Colors.white.withValues(alpha: 0.5),
            ),
          ),
          10.width,
          Expanded(
            child: Text(
              feature.label,
              style: primaryTextStyle(size: 14, color: textColor),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final String priceText = _formatMoney(program.price ?? 0);
    final String description = _plainDescription;

    return Container(
      margin: const EdgeInsets.only(bottom: 20, left: 4, right: 4),
      decoration: BoxDecoration(
       color: context.cardColor,
           borderRadius: BorderRadius.circular(20)
      ),
      child: ClipPath(
        clipper: ProgramCardClipper(),
        child: Container(
          width: double.infinity,
          color: primaryColor,
          padding: const EdgeInsets.fromLTRB(22, 28, 22, 48),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                program.name.validate(),
                style: boldTextStyle(size: 20, color: Colors.white),
                textAlign: TextAlign.center,
              ),
              12.height,
              Text(
                priceText.trim(),
                style: boldTextStyle(size: 36, color: Colors.white),
                textAlign: TextAlign.center,
              ),
              14.height,
              Container(
                width: 70,
                height: 1.5,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.white.withValues(alpha: 0),
                      Colors.white.withValues(alpha: 0.8),
                      Colors.white.withValues(alpha: 0),
                    ],
                  ),
                ),
              ),
              18.height,
              ..._features.map(_featureRow),
              if (description.isNotEmpty) ...[
                4.height,
                Text(
                  description,
                  style: primaryTextStyle(
                    size: 13,
                    color: Colors.white.withValues(alpha: 0.9),
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                ),
                14.height,
              ] else
                8.height,
              SizedBox(
                width: context.width() * 0.45,
                child: MaterialButton(
                  onPressed: () {
                    if (_canEnterProgram) {
                      ProgramDetailScreen(program: program)
                          .launch<void>(context);
                      return;
                    }
                    showSubscribeProgramBottomSheet(
                      context,
                      program,
                      popOnSuccess: popOnSuccess,
                    );
                  },
                  color: Colors.white,
                  elevation: 0,
                  height: 44,
                  shape: RoundedRectangleBorder(
                    borderRadius: radius(30),
                  ),
                  child: Text(
                    _canEnterProgram
                        ? languages.lblEnterProgram
                        : languages.lblSubscribe,
                    style: boldTextStyle(color: primaryColor, size: 15),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProgramFeature {
  final String label;
  final bool included;

  const _ProgramFeature({required this.label, required this.included});
}
