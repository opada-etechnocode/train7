import '../utils/shared_import.dart';

class ShoppingListDetailScreen extends StatefulWidget {
  final int shoppingListId;

  const ShoppingListDetailScreen({super.key, required this.shoppingListId});

  @override
  State<ShoppingListDetailScreen> createState() => _ShoppingListDetailScreenState();
}

class _ShoppingListDetailScreenState extends State<ShoppingListDetailScreen> {
  bool _isLoading = true;
  ShoppingListDetailData? _detailData;
  bool _showByCategory = false;

  /// Single source of truth for checked state, keyed by item ID.
  final Map<int, bool> _checkedMap = {};

  @override
  void initState() {
    super.initState();
    _fetchDetail();
  }

  Future<void> _fetchDetail() async {
    setState(() => _isLoading = true);
    await getShoppingListDetailApi(id: widget.shoppingListId).then((value) {
      _detailData = value.data;
      _checkedMap.clear();
      for (final item in _detailData?.items ?? []) {
        if (item.id != null) {
          _checkedMap[item.id!] = item.isChecked ?? false;
        }
      }
    }).catchError((e) {
      toast(e.toString());
    }).whenComplete(() {
      setState(() => _isLoading = false);
    });
  }

  Future<void> _toggleItem(ShoppingListItem item) async {
    if (item.id == null) return;
    final bool newStatus = !(_checkedMap[item.id!] ?? false);

    setState(() {
      _checkedMap[item.id!] = newStatus;
    });

    Map<String, dynamic> req = {
      'item_id': item.id,
      'is_checked': newStatus ? 1 : 0,
    };

    await shoppingListItemToggleApi(req).catchError((e) {
      toast(e.toString());
      setState(() {
        _checkedMap[item.id!] = !newStatus;
      });
    });
  }

  void _showAddItemSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _AddItemSheet(shoppingListId: widget.shoppingListId),
    ).then((added) {
      if (added == true) _fetchDetail();
    });
  }

  Widget _buildItem(ShoppingListItem item) {
    bool checked = _checkedMap[item.id] ?? (item.isChecked == true);
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: boxDecorationWithRoundedCorners(
        backgroundColor: context.cardColor,
        border: Border.all(color: context.dividerColor.withValues(alpha: 0.5)),
        borderRadius: radius(8),
      ),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: boxDecorationWithRoundedCorners(
              borderRadius: radius(4),
              border: Border.all(
                color: checked ? primaryColor : Colors.grey.shade400,
              ),
              backgroundColor: checked ? primaryColor : Colors.transparent,
            ),
            child: checked
                ? const Icon(Icons.check, size: 16, color: Colors.white)
                : const SizedBox(),
          ).onTap(() => _toggleItem(item)),
          12.width,
          Text(
            item.manuallyAdded == true ? item.customItemName.validate() : item.ingredientTitle.validate(),
            style: primaryTextStyle(
              decoration: checked ? TextDecoration.lineThrough : TextDecoration.none,
              color: checked ? textSecondaryColorGlobal : textPrimaryColorGlobal,
            ),
          ).expand(),
          Text(
            '${item.displayQuantity ?? ''} ${item.displayUnitSymbol ?? ''}'.trim(),
            style: boldTextStyle(
              decoration: checked ? TextDecoration.lineThrough : TextDecoration.none,
              color: checked ? textSecondaryColorGlobal : textPrimaryColorGlobal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemsList() {
    final items = _detailData?.items;
    if (items == null || items.isEmpty) {
      return const NoDataScreen(mTitle: 'No items found').center();
    }
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 90),
      itemCount: items.length,
      itemBuilder: (context, index) => _buildItem(items[index]),
    );
  }

  Widget _buildItemsByCategory() {
    final categories = _detailData?.itemsByCategory;
    if (categories == null || categories.isEmpty) {
      return const NoDataScreen(mTitle: 'No items found').center();
    }
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 90),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(category.ingredientCategoryTitle.validate().isEmpty ? 'Custom' : category.ingredientCategoryTitle.validate(), style: boldTextStyle(size: 18)),
            12.height,
            ...(category.items ?? []).map((item) => _buildItem(item)),
            16.height,
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: appBarWidget(
        _detailData?.title ?? 'Shopping List',
        color: context.scaffoldBackgroundColor,
        context: context,
        actions: [
          PopupMenuButton<int>(
            icon: Icon(Icons.more_vert, color: textPrimaryColorGlobal),
            color: context.cardColor,
            onSelected: (value) async {
              if (value == 1) {
                setState(() {
                  _showByCategory = !_showByCategory;
                });
              } else if (value == 2) {
                // Edit list
                if (_detailData != null) {
                  final mappedData = ShoppingListData(
                    id: _detailData!.id,
                    userId: _detailData!.userId,
                    dailyPlanId: _detailData!.dailyPlanId,
                    title: _detailData!.title,
                    startDate: _detailData!.startDate,
                    endDate: _detailData!.endDate,
                    servings: _detailData!.servings,
                    status: _detailData!.status,
                    itemsCount: _detailData!.itemsCount,
                    createdAt: _detailData!.createdAt,
                    updatedAt: _detailData!.updatedAt,
                  );
                  final bool? result = await AddShoppingListScreen(
                    shoppingList: mappedData,
                  ).launch(context);
                  if (result == true) {
                    _fetchDetail();
                  }
                }
              } else if (value == 3) {
                // Delete list
                if (_detailData?.id != null) {
                  showConfirmDialogCustom(
                    context,
                    title: languages.lblDeleteshoppinglist,
                    subTitle: languages.lblConfirmDeleteShoppingList,
                    dialogType: DialogType.DELETE,
                    onAccept: (p0) async {
                      appStore.setLoading(true);
                      await deleteShoppingListApi({'id': _detailData!.id}).then((value) {
                        toast(value.message);
                        Navigator.pop(context, true);
                      }).catchError((e) {
                        toast(e.toString());
                      }).whenComplete(() {
                        appStore.setLoading(false);
                      });
                    },
                  );
                }
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 1,
                child: Row(
                  children: [
                    Icon(_showByCategory ? Icons.list : Icons.category_outlined, size: 20, color: textPrimaryColorGlobal),
                    8.width,
                    Text(_showByCategory ? languages.lblSimpleList : languages.lblCategorized, style: primaryTextStyle()),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 2,
                child: Row(
                  children: [
                    Icon(Icons.edit_outlined, size: 20, color: textPrimaryColorGlobal),
                    8.width,
                    Text(languages.lblEditlist, style: primaryTextStyle()),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 3,
                child: Row(
                  children: [
                    const Icon(Icons.delete_outline, size: 20, color: Colors.red),
                    8.width,
                    Text(languages.lblDeletelist, style: primaryTextStyle(color: Colors.red)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: _isLoading
          ? const Loader()
          : (_detailData == null
              ? const NoDataScreen()
              : (_showByCategory ? _buildItemsByCategory() : _buildItemsList())),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: AppButton(
            text: languages.lblAdditem,
            color: primaryColor,
            textColor: Colors.white,
            shapeBorder: RoundedRectangleBorder(borderRadius: radius(12)),
            onTap: _showAddItemSheet,
          ),
        ),
      ),
    );
}

// ---------------------------------------------------------------------------
// Add Item Bottom Sheet
// ---------------------------------------------------------------------------

class _AddItemSheet extends StatefulWidget {
  final int shoppingListId;
  const _AddItemSheet({required this.shoppingListId});

  @override
  State<_AddItemSheet> createState() => _AddItemSheetState();
}

class _AddItemSheetState extends State<_AddItemSheet> {
  final _nameController = TextEditingController();
  final _quantityController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  List<MeasurementUnit> _units = [];
  MeasurementUnit? _selectedUnit;
  bool _loadingUnits = true;
  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    _loadUnits();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  Future<void> _loadUnits() async {
    await getMeasurementUnitsApi().then((res) {
      setState(() {
        _units = res.data ?? [];
        // Default to "None" / first unit
        _selectedUnit = _units.isNotEmpty ? _units.first : null;
      });
    }).catchError((e) {
      toast(e.toString());
    }).whenComplete(() {
      setState(() => _loadingUnits = false);
    });
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _submitting = true);

    final Map<String, dynamic> req = {
      'shopping_list_id': widget.shoppingListId,
      'custom_item_name': _nameController.text.trim(),
      if (_quantityController.text.trim().isNotEmpty)
        'display_quantity': num.tryParse(_quantityController.text.trim()),
      if (_selectedUnit != null) 'measurement_unit_id': _selectedUnit!.id,
    };

    await addShoppingListItemApi(req).then((value) {
      toast(value.message ?? 'Item added');
      Navigator.pop(context, true);
    }).catchError((e) {
      toast(e.toString());
    }).whenComplete(() {
      if (mounted) setState(() => _submitting = false);
    });
  }

  @override
  Widget build(BuildContext context) => Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        decoration: BoxDecoration(
          color: context.scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              margin: const EdgeInsets.only(top: 10),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade400,
                borderRadius: radius(4),
              ),
            ),
            16.height,

            // Header row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: boxDecorationWithRoundedCorners(
                      borderRadius: radius(12),
                      backgroundColor: primaryColor.withValues(alpha: 0.12),
                    ),
                    child: const Icon(Icons.add, color: primaryColor, size: 24),
                  ),
                  14.width,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(languages.lblAdditem, style: boldTextStyle(size: 18)),
                      4.height,
                      Text(
                        languages.lblAddNewItemToYourShoppingList,
                        style: secondaryTextStyle(),
                      ),
                    ],
                  ).expand(),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),

            const Divider(height: 24),

            // Form
            if (_loadingUnits)
              const Padding(
                padding: EdgeInsets.all(32),
                child: Loader(),
              )
            else
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Item name
                      Text(languages.lblItem, style: boldTextStyle()),
                      8.height,
                      AppTextField(
                        controller: _nameController,
                        textFieldType: TextFieldType.NAME,
                        decoration: defaultInputDecoration(context, hint: languages.lblEnterItemName),
                        validator: (v) =>
                            (v == null || v.trim().isEmpty) ? languages.lblItemNameIsRequired : null,
                      ),
                      16.height,

                      // Quantity + Unit row
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Quantity
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(languages.lblQuantity, style: boldTextStyle()),
                              8.height,
                              SizedBox(
                                width: 140,
                                child: AppTextField(
                                  controller: _quantityController,
                                  textFieldType: TextFieldType.PHONE,
                                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                  decoration: defaultInputDecoration(context, hint: 'Quantity'),
                                ),
                              ),
                            ],
                          ),
                          16.width,

                          // Unit dropdown
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(languages.lblUnit, style: boldTextStyle()),
                                8.height,
                                Container(
                                  decoration: boxDecorationWithRoundedCorners(
                                    backgroundColor: context.cardColor,
                                    border: Border.all(
                                      color: context.dividerColor.withValues(alpha: 0.5),
                                    ),
                                    borderRadius: radius(8),
                                  ),
                                  padding: const EdgeInsets.symmetric(horizontal: 12),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<MeasurementUnit>(
                                      value: _selectedUnit,
                                      isExpanded: true,
                                      hint: Text(languages.lblNone, style: primaryTextStyle()),
                                      items: _units.map((unit) => DropdownMenuItem<MeasurementUnit>(
                                          value: unit,
                                          child: Text(
                                            '${unit.title ?? ''} (${unit.symbol ?? ''})',
                                            style: primaryTextStyle(),
                                          ),
                                        )).toList(),
                                      onChanged: (val) {
                                        setState(() => _selectedUnit = val);
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      24.height,

                      // Buttons
                      Row(
                        children: [
                          AppButton(
                            text: 'Cancel', // todo
                            color: context.cardColor,
                            textColor: textPrimaryColorGlobal,
                            shapeBorder: RoundedRectangleBorder(
                              borderRadius: radius(12),
                              side: BorderSide(
                                color: context.dividerColor.withValues(alpha: 0.5),
                              ),
                            ),
                            onTap: () => Navigator.pop(context),
                          ).expand(),
                          16.width,
                          AppButton(
                            text: 'Add', //todo
                            color: primaryColor,
                            textColor: Colors.white,
                            shapeBorder: RoundedRectangleBorder(borderRadius: radius(12)),
                            onTap: _submitting ? null : _submit,
                            child: _submitting
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : null,
                          ).expand(),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
}
