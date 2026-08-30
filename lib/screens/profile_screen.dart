import '../utils/shared_import.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  Widget mOtherInfo(String title, String value, String heading) => Container(
    decoration: boxDecorationWithRoundedCorners(
      borderRadius: radius(12),
      backgroundColor: context.cardColor,
    ),
    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            children: [
              TextSpan(
                text: value,
                style: boldTextStyle(size: 18, color: primaryColor),
              ),
              const WidgetSpan(
                child: Padding(padding: EdgeInsets.only(right: 4)),
              ),
              TextSpan(
                text: heading,
                style: boldTextStyle(size: 14, color: primaryColor),
              ),
            ],
          ),
        ),
        6.height,
        Text(title, style: secondaryTextStyle(size: 12, color: textColor)),
      ],
    ),
  );

  @override
  Widget build(BuildContext context) => AnnotatedRegion(
    value: SystemUiOverlayStyle(
      statusBarColor: primaryColor, // Colors.transparent,
      statusBarIconBrightness: appStore.isDarkMode
          ? Brightness.light
          : Brightness.light,
      systemNavigationBarIconBrightness: appStore.isDarkMode
          ? Brightness.light
          : Brightness.light,
    ),
    child: SafeArea(
      child: Observer(
        builder: (context) => Scaffold(
          backgroundColor: appStore.isDarkMode ? context.scaffoldBackgroundColor : cardLightColor,
          body: SingleChildScrollView(
            child: Column(
              children: [
                Stack(
                  children: [
                    Container(
                      height: context.height() * 0.4,
                      color: primaryColor,
                    ),
                    Align(
                      child: Text(
                        languages.lblProfile,
                        style: boldTextStyle(size: 20, color: white),
                      ).paddingTop(context.statusBarHeight + 16),
                    ),
                    PositionedDirectional(
                      top: context.statusBarHeight + 8,
                      start: 8,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back, color: white),
                        onPressed: () => finish(context),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                        top: userStore.isLoggedIn
                            ? context.height() * 0.2
                            : context.height() * 0.12,
                      ),
                      height: context.height() * 1,
                      decoration: boxDecorationWithRoundedCorners(
                        backgroundColor: context.scaffoldBackgroundColor,
                        borderRadius: radiusOnly(
                          topRight: defaultRadius,
                          topLeft: defaultRadius,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                        top: context.height() * 0.1,
                        right: 16,
                        left: 16,
                      ),
                      child: Column(
                        children: [
                          16.height,
                          Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 20,
                              horizontal: 4,
                            ),
                            decoration: boxDecorationWithRoundedCorners(
                              backgroundColor: appStore.isDarkMode
                                  ? scaffoldColorDark
                                  : context.cardColor,
                              border: Border.all(color: Colors.white.withAlpha(50)),

                              borderRadius: radius(14),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Stack(
                                      alignment: Alignment.bottomRight,
                                      children: [
                                        Container(
                                          decoration:
                                              boxDecorationWithRoundedCorners(
                                                boxShape: BoxShape.circle,
                                                border: Border.all(
                                                  width: 2,
                                                  color: primaryColor,
                                                ),
                                              ),
                                          child:
                                              cachedImage(
                                                    userStore.profileImage
                                                        .validate(),
                                                    height: 65,
                                                    width: 65,
                                                    fit: BoxFit.cover,
                                                  )
                                                  .cornerRadiusWithClipRRect(
                                                    100,
                                                  )
                                                  .paddingAll(1),
                                        ),
                                        Container(
                                          decoration:
                                              boxDecorationWithRoundedCorners(
                                                boxShape: BoxShape.circle,
                                                border: Border.all(
                                                  width: 2,
                                                  color: white,
                                                ),
                                                backgroundColor: primaryColor,
                                              ),
                                          padding: const EdgeInsets.all(4),
                                          child: Image.asset(
                                            ic_edit,
                                            color: white,
                                            height: 14,
                                            width: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                    12.width,
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "${userStore.fName.validate().capitalizeFirstLetter()} ${userStore.lName.capitalizeFirstLetter()}",
                                          style: boldTextStyle(size: 20),
                                        ),
                                        2.height,
                                        Text(
                                          userStore.email.validate(),
                                          style: secondaryTextStyle(),
                                        ),
                                      ],
                                    ).expand(),
                                  ],
                                ).paddingSymmetric(horizontal: 16).onTap(
                                  () async {
                                    final bool? res =
                                        await const EditProfileScreen().launch<bool?>(
                                          context,
                                        );
                                    if (res == true) {
                                      setState(() {});
                                    }
                                  },
                                ),
                                20.height,
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    mOtherInfo(
                                      languages.lblWeight,
                                      userStore.weight.isEmptyOrNull
                                          ? "-"
                                          : userStore.weight.validate(),
                                      userStore.weight.isEmptyOrNull
                                          ? ""
                                          : userStore.weightUnit.validate(),
                                    ).expand(),
                                    12.width,
                                    mOtherInfo(
                                      languages.lblHeight,
                                      userStore.height.isEmptyOrNull
                                          ? "-"
                                          : userStore.height.validate(),
                                      userStore.height.isEmptyOrNull
                                          ? ""
                                          : userStore.heightUnit.validate(),
                                    ).expand(),
                                    12.width,
                                    mOtherInfo(
                                      languages.lblAge,
                                      userStore.age.isEmptyOrNull
                                          ? "-"
                                          : userStore.age.validate(),
                                      userStore.age.isEmptyOrNull
                                          ? ""
                                          : languages.lblYear,
                                    ).expand(),
                                  ],
                                ).paddingSymmetric(horizontal: 16),
                              ],
                            ),
                          ).visible(userStore.isLoggedIn),
                          8.height,
                          mOption(ic_diet_outline, languages.lblRecipes, () {
                            const RecipeMainScreen().launch<void>(context);
                          }, context),
                          const Divider(height: 0, color: grayColor),
                          mOption(
                            ic_blog,
                            languages.lblBlog,
                            () {
                              const BlogScreen().launch<void>(context);
                            },
                            context,
                            goToLogin: true,
                          ),
                          const Divider(height: 0, color: grayColor),

                          // ///TODO
                          // mOption(ic_blog, "Videos", () {
                          //   VideoScreen().launch(context);
                          // }),
                          const Divider(height: 0, color: grayColor),
                          if (userStore.subscription == "1")
                            mOption(
                              ic_dumbbell,
                              languages.lblSubscriptionPlans,
                              () {
                                const SubscriptionDetailScreen().launch<void>(
                                  context,
                                );
                              },
                              context,
                              requireLogin: true,
                            ),
                          const Divider(
                            height: 0,
                            color: grayColor,
                          ).visible(userStore.isLoggedIn),
                          mOption(
                            ic_fav_outline,
                            languages.lblFavoriteWorkoutAndNutristions,
                            () {
                              const FavouriteScreen(index: 0).launch<void>(context);
                            },
                            context,
                            requireLogin: true,
                          ),
                          const Divider(
                            height: 0,
                            color: grayColor,
                          ).visible(userStore.isLoggedIn),
                          mOption(
                            ic_save,
                            languages.lblPostBmk,
                            () {
                              const BookmarkScreen().launch<void>(context);
                            },
                            context,
                            requireLogin: true,
                          ),
                          const Divider(
                            height: 0,
                            color: grayColor,
                          ).visible(userStore.isLoggedIn),
                          mOption(
                            ic_reminder,
                            languages.lblDailyReminders,
                            () {
                              const ReminderScreen().launch<void>(context);
                            },
                            context,
                            goToLogin: true,
                          ),
                          const Divider(height: 0, color: grayColor),
                          mOption(
                            ic_assigned,
                            languages.lblPlan,
                            () {
                              const AssignScreen().launch<void>(context);
                            },
                            context,
                            requireLogin: true,
                          ),
                          const Divider(
                            height: 0,
                            color: grayColor,
                          ).visible(userStore.isLoggedIn),
                          mOption(
                            ic_report_outline,
                            languages.lblReport,
                            () {
                              const ProgressScreen().launch<void>(
                                context,
                                pageRouteAnimation: PageRouteAnimation.Fade,
                              );
                            },
                            context,
                            goToLogin: true,
                          ),
                          const Divider(height: 0, color: grayColor),
                          mOption(ic_setting, languages.lblSettings, () {
                            const SettingScreen().launch<void>(
                              context,
                              pageRouteAnimation: PageRouteAnimation.Fade,
                            );
                          }, context),
                          const Divider(height: 0, color: grayColor),
                          mOption(ic_info, languages.lblAboutApp, () {
                            const AboutAppScreen().launch<void>(
                              context,
                              pageRouteAnimation: PageRouteAnimation.Fade,
                            );
                          }, context),
                          const Divider(height: 0, color: grayColor),
                          mOption(
                            ic_report,
                            languages.lblExerHtr,
                            () {
                              const ExerciseHistoryScreen().launch<void>(
                                context,
                                pageRouteAnimation: PageRouteAnimation.Fade,
                              );
                            },
                            context,
                            requireLogin: true,
                          ),
                          const Divider(height: 0, color: grayColor),
                          mOption(
                            ic_report,
                            languages.lblWOHtr,
                            () {
                              const WorkoutHistoryScreen().launch<void>(
                                context,
                                pageRouteAnimation: PageRouteAnimation.Fade,
                              );
                            },
                            context,
                            requireLogin: true,
                          ),
                          const Divider(
                            height: 0,
                            color: grayColor,
                          ).visible(userStore.isLoggedIn),
                          mOption(
                            ic_favorite_fill,
                            "Favourite Recipe", // todo
                            () {
                              const FavouriteRecipeScreen().launch<void>(context);
                            },
                            context,
                            requireLogin: true,
                          ),
                          const Divider(
                            height: 0,
                            color: grayColor,
                          ).visible(userStore.isLoggedIn),
                          mOption(
                            ic_logout,
                            languages.lblLogout,
                            () {
                              showConfirmDialogCustom(
                                context,
                                dialogType: DialogType.DELETE,
                                title: languages.lblLogoutMsg,
                                positiveText: languages.lblLogout,
                                image: ic_logout,
                                onAccept: (buildContext) {
                                  logout(
                                    context,
                                    onLogout: () {
                                      isFirstTimeGraph = false;
                                      if (userStore.loginRequired) {
                                        const SignInScreen().launch<void>(
                                          context,
                                          isNewTask: true,
                                        );
                                      }
                                    },
                                  );
                                  finish(context);
                                },
                              );
                            },
                            context,
                            requireLogin: true,
                          ),
                          mOption(
                            ic_logout,
                            languages.lblLogin,
                            () {
                              const SignInScreen().launch<void>(context);
                            },
                            context,
                            goToLogin: true,
                          ).visible(
                            !userStore.isLoggedIn && !userStore.loginRequired,
                          ),
                          //20.height,
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
