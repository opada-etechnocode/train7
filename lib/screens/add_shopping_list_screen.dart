import '../extensions/date_time_extensions.dart';
import '../utils/registration_data.dart';
import '../utils/shared_import.dart';

class AddShoppingListScreen extends StatefulWidget {
  /// Pass an existing [shoppingList] to open the screen in edit mode.
  final ShoppingListData? shoppingList;
  final bool isDefaultSpecificDate;

  const AddShoppingListScreen({super.key, this.shoppingList, this.isDefaultSpecificDate = true});

  bool get isEditMode => shoppingList != null;

  @override
  State<AddShoppingListScreen> createState() => _AddShoppingListScreenState();
}

class _AddShoppingListScreenState extends State<AddShoppingListScreen> {
  final TextEditingController _titleController = TextEditingController();
  late bool _isSpecificDate;
  DateTime _selectedDate = DateTime.now();
  DateTimeRange? _selectedDateRange;
  bool _isCompleteOnly = false;
  final List<String> _selectedMealTypes = [];
  int _servings = 1;
  int? _dailyPlanId;
  bool _isFetchingPlan = false;

  @override
  void initState() {
    super.initState();
    _isSpecificDate = widget.isDefaultSpecificDate;
    _selectedMealTypes.addAll(RegistrationData.getAvailableMealEntries().keys);
    _prefillForEdit();
  }

  void _prefillForEdit() {
    final list = widget.shoppingList;
    if (list == null) {
      // Add mode — fetch daily plan for today
      _fetchDailyPlanId(_selectedDate);
      return;
    }

    // Edit mode — prefill from existing data
    _titleController.text = list.title ?? '';

    if (list.dailyPlanId != null) {
      // Was created with a specific date
      _isSpecificDate = true;
      _dailyPlanId = list.dailyPlanId;
      if (list.startDate != null) {
        _selectedDate = DateTime.tryParse(list.startDate!) ?? DateTime.now();
      }
    } else {
      // Was created with a date range
      _isSpecificDate = false;
      _servings = list.servings ?? 1;
      if (list.startDate != null && list.endDate != null) {
        final start = DateTime.tryParse(list.startDate!);
        final end = DateTime.tryParse(list.endDate!);
        if (start != null && end != null) {
          _selectedDateRange = DateTimeRange(start: start, end: end);
        }
      }
    }
  }

  Future<void> _fetchDailyPlanId(DateTime date) async {
    setState(() => _isFetchingPlan = true);
    await getDailyPlanDetailApi(date: getDateTimeString(date)).then((value) {
      _dailyPlanId = value.data?.id;
    }).catchError((e) {
      log("Error fetching daily plan: $e");
    }).whenComplete(() {
      setState(() => _isFetchingPlan = false);
    });
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dailyPlanId = null;
      });
      _fetchDailyPlanId(picked);
    }
  }

  Future<void> _selectDateRange() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
      initialDateRange: _selectedDateRange,
    );
    if (picked != null) {
      setState(() {
        _selectedDateRange = picked;
      });
    }
  }

  Future<void> _submit() async {
    if (_titleController.text.trim().isEmpty) {
      toast(languages.lblPleaseenteratitle);
      return;
    }

    Map<String, dynamic> req = {
      'title': _titleController.text.trim(),
      'is_complete_only': _isCompleteOnly,
    };

    // If editing, include the existing shopping list id to update it
    if (widget.isEditMode) {
      req['shopping_list_id'] = widget.shoppingList!.id;
    }

    if (_selectedMealTypes.isEmpty) {
      toast(languages.lblPleaseselectatleastonemealtype);
      return;
    }
    req['meal_types'] = _selectedMealTypes;

    if (_isSpecificDate) {
      if (_dailyPlanId == null && !_isFetchingPlan) {
        toast(languages.lblNodailyplanfoundforthisdate);
        return;
      }
      if (_isFetchingPlan) {
        toast(languages.lblPleasewaitfordailyplantoload);
        return;
      }
      req['daily_plan_id'] = _dailyPlanId;
    } else {
      if (_selectedDateRange == null) {
        toast(languages.lblPleaseselectadaterange);
        return;
      }
      req['start_date'] = getDateTimeString(_selectedDateRange!.start);
      req['end_date'] = getDateTimeString(_selectedDateRange!.end);
      req['servings'] = _servings;
    }

    appStore.setLoading(true);
    await generateShoppingListApi(req).then((value) {
      toast(value.message.validate());
      Navigator.pop(context, true);
    }).catchError((e) {
      toast(e.toString());
    }).whenComplete(() {
      appStore.setLoading(false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(
        widget.isEditMode ? languages.lblEditShoppingList : languages.lblAddShoppingList,
        context: context,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Date / Range Selection
            Container(
              padding: const EdgeInsets.all(16),
              decoration: boxDecorationWithRoundedCorners(
                border: Border.all(color: context.dividerColor.withValues(alpha: 0.5)),
                backgroundColor: context.cardColor,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(languages.lblSpecificdate, style: primaryTextStyle()).expand(),
                      Switch(
                        value: _isSpecificDate,
                        activeColor: primaryColor,
                        onChanged: (v) {
                          setState(() => _isSpecificDate = v);
                        },
                      ),
                    ],
                  ).onTap(() {
                    setState(() => _isSpecificDate = !_isSpecificDate);
                  }),
                  16.height,
                  if (_isSpecificDate)
                    Row(
                      children: [
                        Text(languages.lblDate, style: boldTextStyle()).expand(),
                        Text(getDateTimeString(_selectedDate), style: primaryTextStyle()),
                        8.width,
                        const Icon(Icons.calendar_today, size: 20).onTap(_selectDate),
                      ],
                    )
                  else
                    Row(
                      children: [
                        Text(languages.lblDaterange, style: boldTextStyle()).expand(),
                        Text(
                          _selectedDateRange != null
                              ? '${getDateTimeString(_selectedDateRange!.start)} - ${getDateTimeString(_selectedDateRange!.end)}'
                              : 'Select Range', // todo
                          style: primaryTextStyle(),
                        ),
                        8.width,
                        const Icon(Icons.date_range, size: 20).onTap(_selectDateRange),
                      ],
                    ),
                  if (_isFetchingPlan && _isSpecificDate) const LinearProgressIndicator().paddingTop(8),
                ],
              ),
            ),
            16.height,

            // 2. Title (The "Text" option)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: boxDecorationWithRoundedCorners(
                border: Border.all(color: context.dividerColor.withValues(alpha: 0.5)),
                backgroundColor: context.cardColor,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(languages.lblTitle, style: primaryTextStyle()),
                  8.height,
                  AppTextField(
                    controller: _titleController,
                    textFieldType: TextFieldType.NAME,
                    decoration: defaultInputDecoration(context, hint: 'Enter title'),
                  ),
                ],
              ),
            ),
            16.height,

            // 3. As it is (Meal Types / Servings)
            if (!_isSpecificDate)
              Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(16),
                decoration: boxDecorationWithRoundedCorners(
                  border: Border.all(color: context.dividerColor.withValues(alpha: 0.5)),
                  backgroundColor: context.cardColor,
                ),
                child: Row(
                  children: [
                    Text(languages.lblServings, style: boldTextStyle()).expand(),
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: boxDecorationWithRoundedCorners(
                        backgroundColor: primaryColor,
                        borderRadius: radius(4),
                      ),
                      child: const Icon(Icons.remove, color: Colors.white, size: 16),
                    ).onTap(() {
                      if (_servings > 1) setState(() => _servings--);
                    }),
                    16.width,
                    Text('$_servings', style: boldTextStyle(size: 18)),
                    16.width,
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: boxDecorationWithRoundedCorners(
                        backgroundColor: primaryColor,
                        borderRadius: radius(4),
                      ),
                      child: const Icon(Icons.add, color: Colors.white, size: 16),
                    ).onTap(() {
                      setState(() => _servings++);
                    }),
                  ],
                ),
              ),

            // 3. Meal Types
            Container(
              padding: const EdgeInsets.all(16),
              decoration: boxDecorationWithRoundedCorners(
                border: Border.all(color: context.dividerColor.withValues(alpha: 0.5)),
                backgroundColor: context.cardColor,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(languages.lblMealtypes, style: boldTextStyle()),
                  8.height,
                  ...RegistrationData.getAvailableMealEntries().entries.map((entry) {
                    bool isSelected = _selectedMealTypes.contains(entry.key);
                    return Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Container(
                          width: 20,
                          height: 20,
                          decoration: boxDecorationWithRoundedCorners(
                            borderRadius: radius(4),
                            border: Border.all(color: isSelected ? primaryColor : Colors.grey.shade400),
                            backgroundColor: isSelected ? primaryColor : Colors.transparent,
                          ),
                          child: isSelected ? const Icon(Icons.check, size: 16, color: Colors.white) : const SizedBox(),
                        ),
                        12.width,
                        Text(entry.value, style: primaryTextStyle()).expand(),
                      ],
                    ).paddingSymmetric(vertical: 8).onTap(() {
                      setState(() {
                        if (isSelected) {
                          _selectedMealTypes.remove(entry.key);
                        } else {
                          _selectedMealTypes.add(entry.key);
                        }
                      });
                    });
                  }),
                ],
              ),
            ),
            16.height,

            // 4. Is Complete Only
            Container(
              padding: const EdgeInsets.all(16),
              decoration: boxDecorationWithRoundedCorners(
                border: Border.all(color: context.dividerColor.withValues(alpha: 0.5)),
                backgroundColor: context.cardColor,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    width: 20,
                    height: 20,
                    decoration: boxDecorationWithRoundedCorners(
                      borderRadius: radius(4),
                      border: Border.all(color: _isCompleteOnly ? primaryColor : Colors.grey.shade400),
                      backgroundColor: _isCompleteOnly ? primaryColor : Colors.transparent,
                    ),
                    child: _isCompleteOnly ? const Icon(Icons.check, size: 16, color: Colors.white) : const SizedBox(),
                  ),
                  12.width,
                  Text(languages.lblIscompleteonly, style: primaryTextStyle()).expand(),
                ],
              ).paddingSymmetric(vertical: 8).onTap(() {
                setState(() => _isCompleteOnly = !_isCompleteOnly);
              }),
            ),
            24.height,
          ],
        ),
      ),
      bottomNavigationBar: AppButton(
        text: widget.isEditMode ? 'Update List' : 'Generate List', // todo
        width: context.width(),
        color: primaryColor,
        onTap: _submit,
      ).paddingAll(16),
    );
  }
}
