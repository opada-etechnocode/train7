import '../service/ugc_plan_sync_service.dart';
import '../utils/shared_import.dart';
import 'ugc_attribute_form_screen.dart';
import 'ugc_diet_form_screen.dart';
import 'ugc_program_form_screen.dart';
import 'ugc_workout_form_screen.dart';

class UgcHubScreen extends StatefulWidget {
  const UgcHubScreen({super.key});

  @override
  State<UgcHubScreen> createState() => _UgcHubScreenState();
}

class _UgcHubScreenState extends State<UgcHubScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) setState(() {});
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = appStore.isDarkMode;
    final Color bg = isDark ? darkScaffoldBg : lightScaffoldColor;

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    languages.lblUgcHubTitle,
                    style: boldTextStyle(size: 26),
                  ),
                  4.height,
                  Text(
                    languages.lblUgcHubSubtitle,
                    style: secondaryTextStyle(size: 13),
                  ),
                ],
              ),
            ),
            12.height,
            SizedBox(
              height: 44,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  _pill(0, languages.lblUgcPrograms, Icons.view_week_rounded),
                  _pill(1, languages.lblUgcWorkouts, Icons.fitness_center),
                  _pill(2, languages.lblUgcDiets, Icons.restaurant_menu),
                  _pill(3, languages.lblUgcSetup, Icons.tune_rounded),
                ],
              ),
            ),
            8.height,
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: const [
                  _UgcProgramsTab(),
                  _UgcCreateWorkoutTab(),
                  _UgcCreateDietTab(),
                  _UgcSetupTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _pill(int index, String label, IconData icon) {
    final bool selected = _tabController.index == index;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Material(
        color: selected
            ? primaryColor
            : (appStore.isDarkMode ? darkCardColor : Colors.white),
        borderRadius: BorderRadius.circular(24),
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: () => _tabController.animateTo(index),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              border: selected
                  ? null
                  : Border.all(
                      color: appStore.isDarkMode
                          ? Colors.white.withValues(alpha: 0.08)
                          : lightDividerColor,
                    ),
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 16,
                  color: selected ? Colors.white : primaryColor,
                ),
                6.width,
                Text(
                  label,
                  style: boldTextStyle(
                    size: 12,
                    color: selected
                        ? Colors.white
                        : (appStore.isDarkMode ? Colors.white70 : Colors.black87),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _UgcProgramsTab extends StatefulWidget {
  const _UgcProgramsTab();

  @override
  State<_UgcProgramsTab> createState() => _UgcProgramsTabState();
}

class _UgcProgramsTabState extends State<_UgcProgramsTab> {
  final List<UgcProgramModel> _items = [];
  bool _loading = true;
  int _page = 1;
  bool _hasMore = true;

  @override
  void initState() {
    super.initState();
    _load(refresh: true);
  }

  Future<void> _load({bool refresh = false}) async {
    if (refresh) {
      _page = 1;
      _hasMore = true;
      _items.clear();
    }
    if (!_hasMore && !refresh) return;

    setState(() => _loading = true);
    try {
      final UgcProgramListResponse res = await getUgcProgramList(page: _page);
      final List<UgcProgramModel> list = res.data ?? [];
      if (refresh) _items.clear();
      _items.addAll(list);
      _hasMore = list.isNotEmpty;
      if (_hasMore) _page++;
    } on Exception catch (e) {
      toast(e.toString());
    }
    if (mounted) setState(() => _loading = false);
  }

  Future<void> _delete(UgcProgramModel item) async {
    if (item.id == null) return;
    final bool? ok = await showConfirmDialogCustom(
      context,
      title: languages.lblDelete,
      subTitle: languages.lblDeleteMsg,
      positiveText: languages.lblDelete,
      negativeText: languages.lblCancel,
      onAccept: (c) {},
    );
    if (ok != true) return;
    appStore.setLoading(true);
    try {
      final res = await deleteUgcProgramApi(item.id!);
      toast(res.message.validate(value: languages.lblDone));
      await _load(refresh: true);
    } on Exception catch (e) {
      toast(e.toString());
    }
    appStore.setLoading(false);
  }

  Future<void> _openForm({UgcProgramModel? program}) async {
    final bool? changed =
        await UgcProgramFormScreen(program: program).launch<bool>(context);
    if (changed == true) _load(refresh: true);
  }

  Future<void> _activate(UgcProgramModel item) async {
    appStore.setLoading(true);
    try {
      await UgcPlanSyncService.activateProgram(item);
      toast(languages.lblUgcActivateSuccess);
      if (mounted) setState(() {});
    } on Exception catch (e) {
      toast(e.toString());
    }
    appStore.setLoading(false);
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = appStore.isDarkMode;

    return Stack(
      children: [
        RefreshIndicator(
          color: primaryColor,
          onRefresh: () => _load(refresh: true),
          child: _items.isEmpty && !_loading
              ? ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: [
                    80.height,
                    _EmptyState(
                      title: languages.lblUgcNoPrograms,
                      actionLabel: languages.lblUgcCreateProgram,
                      onAction: () => _openForm(),
                    ),
                  ],
                )
              : ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
                  itemCount: _items.length + (_hasMore ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index >= _items.length) {
                      _load();
                      return const Loader().paddingAll(16);
                    }
                    final UgcProgramModel item = _items[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: isDark ? darkCardColor : Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: isDark
                              ? Colors.white.withValues(alpha: 0.06)
                              : lightDividerColor,
                        ),
                        boxShadow: isDark
                            ? null
                            : [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.04),
                                  blurRadius: 14,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(18),
                          onTap: () => _openForm(program: item),
                          child: Padding(
                            padding: const EdgeInsets.all(14),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 48,
                                  height: 48,
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [
                                        primaryLightColor,
                                        primaryColor,
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  child: const Icon(
                                    Icons.calendar_view_week_rounded,
                                    color: Colors.white,
                                  ),
                                ),
                                12.width,
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              item.name.validate(value: '-'),
                                              style: boldTextStyle(size: 16),
                                            ),
                                          ),
                                          if (UgcPlanSyncService
                                                  .activeProgramId ==
                                              item.id)
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 8,
                                                vertical: 3,
                                              ),
                                              decoration: BoxDecoration(
                                                color: GreenColor.withValues(
                                                  alpha: 0.15,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              child: Text(
                                                languages.lblUgcActivated,
                                                style: secondaryTextStyle(
                                                  size: 10,
                                                  color: GreenColor,
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                      if (item.objective
                                          .validate()
                                          .isNotEmpty) ...[
                                        4.height,
                                        Text(
                                          item.objective.validate(),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: secondaryTextStyle(size: 12),
                                        ),
                                      ],
                                      10.height,
                                      Wrap(
                                        spacing: 6,
                                        runSpacing: 6,
                                        children: [
                                          _metaChip(
                                            Icons.timelapse_rounded,
                                            '${item.durationWeeks ?? '-'} ${languages.lblUgcWeeks}',
                                          ),
                                          _metaChip(
                                            Icons.repeat_rounded,
                                            item.isRecurring == true
                                                ? languages.lblUgcRecurring
                                                : languages.lblUgcCustom,
                                          ),
                                          _metaChip(
                                            Icons.event_rounded,
                                            '${item.days?.length ?? 0} ${languages.lblUgcDays}',
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                PopupMenuButton<String>(
                                  onSelected: (v) {
                                    if (v == 'edit') {
                                      _openForm(program: item);
                                    } else if (v == 'activate') {
                                      _activate(item);
                                    } else if (v == 'delete') {
                                      _delete(item);
                                    }
                                  },
                                  itemBuilder: (_) => [
                                    PopupMenuItem(
                                      value: 'activate',
                                      child: Text(
                                        UgcPlanSyncService.activeProgramId ==
                                                item.id
                                            ? languages.lblUgcActivated
                                            : languages.lblUgcActivate,
                                      ),
                                    ),
                                    PopupMenuItem(
                                      value: 'edit',
                                      child: Text(languages.lblEdit),
                                    ),
                                    PopupMenuItem(
                                      value: 'delete',
                                      child: Text(
                                        languages.lblDelete,
                                        style: primaryTextStyle(
                                          color: Colors.red,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
        ),
        Positioned(
          right: 16,
          bottom: 16,
          child: Material(
            color: primaryColor,
            borderRadius: BorderRadius.circular(12),
            elevation: 2,
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () => _openForm(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.add, color: Colors.white, size: 18),
                    4.width,
                    Text(
                      languages.lblUgcCreateProgram,
                      style: boldTextStyle(color: Colors.white, size: 12),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Observer(
          builder: (_) =>
              const Loader().center().visible(appStore.isLoading || _loading),
        ),
      ],
    );
  }

  Widget _metaChip(IconData icon, String text) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: primaryColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 12, color: primaryColor),
            4.width,
            Text(
              text,
              style: secondaryTextStyle(size: 11, color: primaryColor),
            ),
          ],
        ),
      );
}

class _UgcCreateWorkoutTab extends StatelessWidget {
  const _UgcCreateWorkoutTab();

  @override
  Widget build(BuildContext context) => _CreateLanding(
        title: languages.lblUgcCreateWorkout,
        subtitle: languages.lblUgcCreateWorkoutDesc,
        onCreate: () => const UgcWorkoutFormScreen().launch<void>(context),
      );
}

class _UgcCreateDietTab extends StatelessWidget {
  const _UgcCreateDietTab();

  @override
  Widget build(BuildContext context) => _CreateLanding(
        title: languages.lblUgcCreateDiet,
        subtitle: languages.lblUgcCreateDietDesc,
        onCreate: () => const UgcDietFormScreen().launch<void>(context),
      );
}

class _CreateLanding extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onCreate;

  const _CreateLanding({
    required this.title,
    required this.subtitle,
    required this.onCreate,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDark = appStore.isDarkMode;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(22, 28, 22, 24),
          decoration: BoxDecoration(
            color: isDark ? darkCardColor : Colors.white,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.06)
                  : lightDividerColor,
            ),
            boxShadow: isDark
                ? null
                : [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 18,
                      offset: const Offset(0, 8),
                    ),
                  ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                no_data_found,
                height: 110,
                width: 140,
                fit: BoxFit.contain,
              ),
              14.height,
              Text(title, style: boldTextStyle(size: 16), textAlign: TextAlign.center),
              6.height,
              Text(
                subtitle,
                style: secondaryTextStyle(size: 12),
                textAlign: TextAlign.center,
              ),
              16.height,
              AppButton(
                text: languages.lblAdd,
                color: primaryColor,
                width: context.width() * 0.55,
                height: 40,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                elevation: 0,
                shapeBorder: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                onTap: onCreate,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final String title;
  final String actionLabel;
  final VoidCallback onAction;

  const _EmptyState({
    required this.title,
    required this.actionLabel,
    required this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(
          no_data_found,
          height: context.height() * 0.18,
          width: context.width() * 0.42,
          fit: BoxFit.contain,
        ),
        12.height,
        Text(title, style: boldTextStyle(size: 15)),
        14.height,
        AppButton(
          text: actionLabel,
          color: primaryColor,
          height: 40,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          elevation: 0,
          shapeBorder: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          onTap: onAction,
        ),
      ],
    );
  }
}

class _UgcSetupTab extends StatefulWidget {
  const _UgcSetupTab();

  @override
  State<_UgcSetupTab> createState() => _UgcSetupTabState();
}

class _UgcSetupTabState extends State<_UgcSetupTab> {
  List<LevelModel> levels = [];
  List<WorkoutTypeModel> types = [];
  List<CategoryDietModel> categories = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => loading = true);
    try {
      final results = await Future.wait([
        getUserLevelListApi(),
        getUserWorkoutTypeListApi(),
        getUserCategoryDietListApi(),
      ]);
      levels = (results[0] as LevelResponse).data ?? [];
      types = (results[1] as WorkoutTypeResponse).data ?? [];
      categories = (results[2] as CategoryDietResponse).data ?? [];
    } on Exception catch (_) {
      try {
        levels = (await getLevelListApi()).data ?? [];
        types = (await getWorkoutTypeListApi()).data ?? [];
        categories = (await getDietCategoryApi()).data ?? [];
      } on Exception catch (e2) {
        toast(e2.toString());
      }
    }
    if (mounted) setState(() => loading = false);
  }

  Future<void> _openForm(UgcAttributeKind kind, {dynamic item}) async {
    final bool? changed = await UgcAttributeFormScreen(
      kind: kind,
      item: item,
    ).launch<bool>(context);
    if (changed == true) _load();
  }

  @override
  Widget build(BuildContext context) {
    if (loading) return const Loader().center();
    final bool isDark = appStore.isDarkMode;

    return RefreshIndicator(
      color: primaryColor,
      onRefresh: _load,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          _setupCard(
            isDark: isDark,
            title: languages.lblLevels,
            icon: Icons.signal_cellular_alt_rounded,
            onAdd: () => _openForm(UgcAttributeKind.level),
            children: levels.isEmpty
                ? [_emptyLine()]
                : levels
                    .map(
                      (e) => _attrTile(
                        e.title.validate(),
                        '${languages.lblUgcRate}: ${e.rate ?? '-'}',
                        onEdit: () =>
                            _openForm(UgcAttributeKind.level, item: e),
                        onDelete: () async {
                          if (e.id == null) return;
                          await deleteUgcLevelApi(e.id!);
                          _load();
                        },
                      ),
                    )
                    .toList(),
          ),
          _setupCard(
            isDark: isDark,
            title: languages.lblWorkoutType,
            icon: Icons.sports_gymnastics_rounded,
            onAdd: () => _openForm(UgcAttributeKind.workoutType),
            children: types.isEmpty
                ? [_emptyLine()]
                : types
                    .map(
                      (e) => _attrTile(
                        e.title.validate(),
                        '',
                        onEdit: () =>
                            _openForm(UgcAttributeKind.workoutType, item: e),
                        onDelete: () async {
                          if (e.id == null) return;
                          await deleteUgcWorkoutTypeApi(e.id!);
                          _load();
                        },
                      ),
                    )
                    .toList(),
          ),
          _setupCard(
            isDark: isDark,
            title: languages.lblCategory,
            icon: Icons.category_rounded,
            onAdd: () => _openForm(UgcAttributeKind.categoryDiet),
            children: categories.isEmpty
                ? [_emptyLine()]
                : categories
                    .map(
                      (e) => _attrTile(
                        e.title.validate(),
                        '',
                        onEdit: () =>
                            _openForm(UgcAttributeKind.categoryDiet, item: e),
                        onDelete: () async {
                          if (e.id == null) return;
                          await deleteUgcCategoryDietApi(e.id!);
                          _load();
                        },
                      ),
                    )
                    .toList(),
          ),
        ],
      ),
    );
  }

  Widget _emptyLine() => Text(
        languages.lblNoFoundData,
        style: secondaryTextStyle(),
      ).paddingSymmetric(vertical: 8);

  Widget _setupCard({
    required bool isDark,
    required String title,
    required IconData icon,
    required VoidCallback onAdd,
    required List<Widget> children,
  }) =>
      Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 10),
        decoration: BoxDecoration(
          color: isDark ? darkCardColor : Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isDark
                ? Colors.white.withValues(alpha: 0.06)
                : lightDividerColor,
          ),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: primaryColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, size: 18, color: primaryColor),
                ),
                10.width,
                Text(title, style: boldTextStyle(size: 15)).expand(),
                TextButton.icon(
                  onPressed: onAdd,
                  icon: const Icon(Icons.add, size: 18, color: primaryColor),
                  label: Text(
                    languages.lblAdd,
                    style: primaryTextStyle(color: primaryColor, size: 13),
                  ),
                ),
              ],
            ),
            6.height,
            ...children,
          ],
        ),
      );

  Widget _attrTile(
    String title,
    String subtitle, {
    required VoidCallback onEdit,
    required VoidCallback onDelete,
  }) =>
      Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: primaryColor.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: boldTextStyle(size: 13)),
                  if (subtitle.isNotEmpty)
                    Text(subtitle, style: secondaryTextStyle(size: 11)),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.edit_outlined, size: 18),
              onPressed: onEdit,
            ),
            IconButton(
              icon: Icon(
                Icons.delete_outline,
                size: 18,
                color: Colors.red.shade400,
              ),
              onPressed: onDelete,
            ),
          ],
        ),
      );
}
