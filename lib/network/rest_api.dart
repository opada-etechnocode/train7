import '../utils/shared_import.dart';


Future<LoginResponse> logInApi(Map<String, dynamic> request) async {
  final Response response = await buildHttpResponse(
    'login',
    request: request,
    method: HttpMethod.POST,
  );
  if (!response.statusCode.isSuccessful()) {
    if (response.body.isJson()) {
      final json = jsonDecode(response.body);

      if (json.containsKey('code') &&
          json['code'].toString().contains('invalid_username')) {
        throw Exception('invalid_username');
      }
    }
  }

  return await handleResponse(response).then((dynamic value) async {
    final LoginResponse loginResponse = LoginResponse.fromJson(value);
    final UserModel? userResponse = loginResponse.data;

    saveUserData(userResponse);
    await userStore.setLogin(true);
    return loginResponse;
  });
}

Future<void> saveUserData(UserModel? userModel) async {
  if (userModel!.apiToken.validate().isNotEmpty) {
    await userStore.setToken(userModel.apiToken.validate());
  }
  setValue(IS_SOCIAL, false);

  await userStore.setToken(userModel.apiToken.validate());
  await userStore.setUserID(userModel.id.validate());
  await userStore.setUserEmail(userModel.email.validate());
  await userStore.setFirstName(userModel.firstName.validate());
  await userStore.setLastName(userModel.lastName.validate());
  await userStore.setUsername(userModel.username.validate());
  await userStore.setUserImage(userModel.profileImage.validate());
  await userStore.setDisplayName(userModel.displayName.validate());
  await userStore.setPhoneNo(userModel.phoneNumber.validate());
  await userStore.setGender(userModel.gender.validate());
  await userStore.setSubscribe(userModel.isSubscribe.validate());
}

Future<SocialLoginResponse> socialLogInApi(Map<String, dynamic> req) async =>
    SocialLoginResponse.fromJson(
      await handleResponse(
        await buildHttpResponse(
          'social-mail-login',
          request: req,
          method: HttpMethod.POST,
        ),
      ),
    );

Future<SocialLoginResponse> socialOtpLogInApi(Map<String, dynamic> req) async =>
    SocialLoginResponse.fromJson(
      await handleResponse(
        await buildHttpResponse(
          'social-otp-login',
          request: req,
          method: HttpMethod.POST,
        ),
      ),
    );

Future<FitnessBaseResponse> changePwdApi(Map<String, dynamic> req) async =>
    FitnessBaseResponse.fromJson(
      await handleResponse(
        await buildHttpResponse(
          'change-password',
          request: req,
          method: HttpMethod.POST,
        ),
      ),
    );

Future<FitnessBaseResponse> forgotPwdApi(Map<String, dynamic> req) async =>
    FitnessBaseResponse.fromJson(
      await handleResponse(
        await buildHttpResponse(
          'forget-password',
          request: req,
          method: HttpMethod.POST,
        ),
      ),
    );

Future<FitnessBaseResponse> deleteUserAccountApi() async =>
    FitnessBaseResponse.fromJson(
      await handleResponse(
        await buildHttpResponse('delete-user-account', method: HttpMethod.POST),
      ),
    );

Future<LoginResponse> registerApi(Map<String, dynamic> req) async => LoginResponse.fromJson(
  await handleResponse(
    await buildHttpResponse('register', request: req, method: HttpMethod.POST),
  ),
);

Future<LoginResponse> updateProfileApi(Map<String, dynamic> req) async => LoginResponse.fromJson(
  await handleResponse(
    await buildHttpResponse(
      'update-profile',
      request: req,
      method: HttpMethod.POST,
    ),
  ),
);

Future<BodyPartResponse> getBodyPartApi(int? page) async =>
    BodyPartResponse.fromJson(
      await (handleResponse(
        await buildHttpResponse("bodypart-list?page=$page"),
      )),
    );

Future<EquipmentResponse> getEquipmentListApi({int? page = 1}) async =>
    EquipmentResponse.fromJson(
      await (handleResponse(
        await buildHttpResponse("equipment-list?page=$page"),
      )),
    );

Future<WorkoutResponse> getWorkoutListApi(
  bool? isFav,
  bool? isAssign, {
  int? page = 1,
}) async {
  if (isAssign == true) {
    return WorkoutResponse.fromJson(
      await handleResponse(
        await buildHttpResponse('assign-workout-list?page=$page'),
      ),
    );
  } else {
    if (isFav != true) {
      return WorkoutResponse.fromJson(
        await (handleResponse(
          await buildHttpResponse("workout-list?page=$page"),
        )),
      );
    } else {
      return WorkoutResponse.fromJson(
        await handleResponse(
          await buildHttpResponse('get-favourite-workout?page=$page'),
        ),
      );
    }
  }
}

Future<WorkoutTypeResponse> getWorkoutTypeListApi({
  int mPerPage = WORKOUT_TYPE_PAGE,
}) async => WorkoutTypeResponse.fromJson(
  await (handleResponse(
    await buildHttpResponse("workouttype-list?page=$mPerPage"),
  )),
);

Future<LevelResponse> getLevelListApi({
  int? page = 1,
  int mPerPage = LEVEL_PER_PAGE,
}) async => LevelResponse.fromJson(
  await (handleResponse(await buildHttpResponse("level-list?page=$page"))),
);

Future<ScheduledResponse> getClassSchedule({
  int? page = 1,
  String? selectedDate,
}) async => ScheduledResponse.fromJson(
  await (handleResponse(
    await buildHttpResponse(
      "class-schedule-list?page=$page&date=$selectedDate",
    ),
  )),
);

Future<FitnessBaseResponse> getClassSchedulePlan(Map<String, dynamic> req) async =>
    FitnessBaseResponse.fromJson(
      await (handleResponse(
        await buildHttpResponse(
          "class-schedule-plan-save",
          request: req,
          method: HttpMethod.POST,
        ),
      )),
    );

Future<ServerLanguageResponse> getLanguageList(dynamic versionNo) async =>
    ServerLanguageResponse.fromJson(
      await handleResponse(
        await buildHttpResponse('language-table-list?version_no=$versionNo'),
      ).then((dynamic value) => value),
    );

Future<BlogResponse> getBlogApi(String? isFeatured, {int? page}) async =>
    BlogResponse.fromJson(
      await (handleResponse(
        await buildHttpResponse("post-list?is_featured=$isFeatured&page=$page"),
      )),
    );

Future<BlogResponse> getSearchBlogApi({String? mSearch = ""}) async =>
    BlogResponse.fromJson(
      await (handleResponse(
        await buildHttpResponse("post-list?title=$mSearch"),
      )),
    );

Future<BlogDetailResponse> getBlogDetailApi(Map<String, dynamic> req) async =>
    BlogDetailResponse.fromJson(
      await (handleResponse(
        await buildHttpResponse(
          "post-detail",
          request: req,
          method: HttpMethod.POST,
        ),
      )),
    );

Future<DietDashboardResponse> getDietDashboardApi() async =>
    DietDashboardResponse.fromJson(
      await (handleResponse(await buildHttpResponse("diet-dashboard"))),
    );

Future<DietResponse> getDietApi(
  String? isFeatured,
  bool? isCategory, {
  int? page = 1,
  bool? isAssign = false,
  bool? isFav = false,
  int? categoryId,
}) async {
  if (isFav == true) {
    return DietResponse.fromJson(
      await (handleResponse(
        await buildHttpResponse("get-favourite-diet?page=$page"),
      )),
    );
  } else if (isAssign == true) {
    return DietResponse.fromJson(
      await (handleResponse(
        await buildHttpResponse("assign-diet-list?page=$page"),
      )),
    );
  } else if (isCategory == true) {
    return DietResponse.fromJson(
      await (handleResponse(
        await buildHttpResponse(
          "diet-list?categorydiet_id=$categoryId&page=$page",
        ),
      )),
    );
  } else {
    return DietResponse.fromJson(
      await (handleResponse(
        await buildHttpResponse("diet-list?is_featured=$isFeatured&page=$page"),
      )),
    );
  }
}

Future<CategoryDietResponse> getDietCategoryApi({int? page}) async =>
    CategoryDietResponse.fromJson(
      await (handleResponse(
        await buildHttpResponse("categorydiet-list?page=$page"),
      )),
    );

Future<DashboardResponse> getDashboardApi() async => DashboardResponse.fromJson(
  await handleResponse(await buildHttpResponse('dashboard-detail')),
);

Future<ExerciseResponse> getExerciseApi({
  int? page,
  String? mSearchValue = " ",
  bool? isBodyPart = false,
  int? id,
  bool? isLevel = false,
  bool? isEquipment = false,
  var ids,
  bool? isFilter = false,
}) async {
  if (mSearchValue.isEmptyOrNull) {
    if (isBodyPart == true) {
      return ExerciseResponse.fromJson(
        await handleResponse(
          await buildHttpResponse('exercise-list?bodypart_id=$id&page=$page'),
        ),
      );
    } else if (isEquipment == true) {
      return ExerciseResponse.fromJson(
        await handleResponse(
          await buildHttpResponse(
            'exercise-list?equipment_id=${isFilter == true ? ids : id}&page=$page',
          ),
        ),
      );
    } else if (isLevel == true) {
      return ExerciseResponse.fromJson(
        await handleResponse(
          await buildHttpResponse(
            'exercise-list?level_ids=${isFilter == true ? ids : id}&page=$page',
          ),
        ),
      );
    } else {
      return ExerciseResponse.fromJson(
        await handleResponse(
          await buildHttpResponse('exercise-list?page=$page'),
        ),
      );
    }
  } else {
    if (isBodyPart == true) {
      return ExerciseResponse.fromJson(
        await handleResponse(
          await buildHttpResponse(
            'exercise-list?bodypart_id=$id&title=$mSearchValue',
          ),
        ),
      );
    } else if (isEquipment == true) {
      return ExerciseResponse.fromJson(
        await handleResponse(
          await buildHttpResponse(
            'exercise-list?equipment_id=${isFilter == true ? ids : id}&title=$mSearchValue',
          ),
        ),
      );
    } else if (isLevel == true) {
      return ExerciseResponse.fromJson(
        await handleResponse(
          await buildHttpResponse(
            'exercise-list?level_ids=${isFilter == true ? ids : id}&title=$mSearchValue',
          ),
        ),
      );
    } else {
      return ExerciseResponse.fromJson(
        await handleResponse(
          await buildHttpResponse('exercise-list?title=$mSearchValue'),
        ),
      );
    }
  }
}

Future<ExerciseResponse> getExerciseListApi({int? page}) async =>
    ExerciseResponse.fromJson(
      await handleResponse(
        await buildHttpResponse('get-user-exercise?page=$page'),
      ),
    );

Future<ExerciseDetailResponse> geExerciseDetailApi(int? id) async =>
    ExerciseDetailResponse.fromJson(
      await handleResponse(await buildHttpResponse('exercise-detail?id=$id')),
    );

Future<FitnessBaseResponse> setDietFavApi(Map<String, dynamic> req) async =>
    FitnessBaseResponse.fromJson(
      await handleResponse(
        await buildHttpResponse(
          'set-favourite-diet',
          request: req,
          method: HttpMethod.POST,
        ),
      ),
    );

Future<ProductDashboardResponse> getProductDashboardApi() async =>
    ProductDashboardResponse.fromJson(
      await (handleResponse(await buildHttpResponse("product-dashboard"))),
    );

Future<ProductCategoryResponse> getProductCategoryApi({int? page = 1}) async =>
    ProductCategoryResponse.fromJson(
      await (handleResponse(
        await buildHttpResponse("productcategory-list?page=$page"),
      )),
    );

Future<ProductResponse> getProductApi({
  bool? isCategory = false,
  String? mSearch = "",
  int? productId,
  int? page = 1,
}) async {
  if (isCategory == true) {
    return ProductResponse.fromJson(
      await (handleResponse(
        await buildHttpResponse("product-list?productcategory_id=$productId"),
      )),
    );
  } else {
    if (mSearch.isEmptyOrNull) {
      return ProductResponse.fromJson(
        await (handleResponse(
          await buildHttpResponse("product-list?page=$page"),
        )),
      );
    } else {
      return ProductResponse.fromJson(
        await (handleResponse(
          await buildHttpResponse("product-list?title=$mSearch"),
        )),
      );
    }
  }
}

Future<UserResponse> getUserDataApi({int? id}) async => UserResponse.fromJson(
  await (handleResponse(await buildHttpResponse("user-detail?id=$id"))),
);

Future<UserResponse> setReminderSettingsApi(Map<String, dynamic> req) async =>
    UserResponse.fromJson(
      await handleResponse(
        await buildHttpResponse(
          'set-reminder-settings',
          request: req,
          method: HttpMethod.POST,
        ),
      ),
    );

Future<WorkoutDetailResponse> getWorkoutDetailApi(int? id) async =>
    WorkoutDetailResponse.fromJson(
      await (handleResponse(await buildHttpResponse("workout-detail?id=$id"))),
    );

Future<WorkoutResponse> getWorkoutFilterListApi({
  int? page = 1,
  int? id,
  bool? isFilter,
  dynamic ids,
  bool? isLevel = false,
  bool? isType,
}) async {
  if (isType == true) {
    return WorkoutResponse.fromJson(
      await handleResponse(
        await buildHttpResponse(
          'workout-list?workout_type_id=${isFilter == true ? ids : id}&page=$page',
        ),
      ),
    );
  } else if (isLevel == true) {
    return WorkoutResponse.fromJson(
      await handleResponse(
        await buildHttpResponse(
          'workout-list?level_ids=${isFilter == true ? ids : id}&page=$page',
        ),
      ),
    );
  } else {
    return WorkoutResponse.fromJson(
      await (handleResponse(
        await buildHttpResponse('workout-list?page=$page'),
      )),
    );
  }
}

Future<DayExerciseResponse> getDayExerciseApi(int? id) async =>
    DayExerciseResponse.fromJson(
      await (handleResponse(
        await buildHttpResponse("workoutday-exercise-list?workout_day_id=$id"),
      )),
    );

Future<FitnessBaseResponse> setWorkoutFavApi(Map<String, dynamic> req) async =>
    FitnessBaseResponse.fromJson(
      await handleResponse(
        await buildHttpResponse(
          'set-favourite-workout',
          request: req,
          method: HttpMethod.POST,
        ),
      ),
    );

Future<DietResponse> getDietFavApi() async => DietResponse.fromJson(
  await handleResponse(await buildHttpResponse('get-favourite-workout')),
);

Future<FitnessBaseResponse> setProgressApi(Map<String, dynamic> req) async =>
    FitnessBaseResponse.fromJson(
      await handleResponse(
        await buildHttpResponse(
          'usergraph-save',
          request: req,
          method: HttpMethod.POST,
        ),
      ),
    );

Future<FitnessBaseResponse> deleteProgressApi(Map<String, dynamic> req) async =>
    FitnessBaseResponse.fromJson(
      await handleResponse(
        await buildHttpResponse(
          'usergraph-delete',
          request: req,
          method: HttpMethod.POST,
        ),
      ),
    );

Future<GraphResponse> getProgressApi(
  String? type, {
  int? page = 1,
  String? isFilterType,
  bool? isFilter = false,
}) async {
  if (isFilter == true) {
    return GraphResponse.fromJson(
      await handleResponse(
        await buildHttpResponse(
          'usergraph-list?type=$type&page=$page&duration=$isFilterType',
        ),
      ),
    );
  } else {
    return GraphResponse.fromJson(
      await handleResponse(
        await buildHttpResponse('usergraph-list?type=$type&page=$page'),
      ),
    );
  }
}

Future<UserGraphDetailResponse> getUserGraphApi(String? type) async =>
    UserGraphDetailResponse.fromJson(
      await handleResponse(
        await buildHttpResponse('usergraph-detail?type=$type'),
      ),
    );

Future<FitnessBaseResponse> setUserDailyWaterGoalApi(Map<String, dynamic> req) async =>
    FitnessBaseResponse.fromJson(
      await handleResponse(
        await buildHttpResponse(
          'user-daily-water-goal-save',
          request: req,
          method: HttpMethod.POST,
        ),
      ),
    );

/*Future<WaterResponseModel> getUserDailyWaterGoalApi() async {
  return WaterResponseModel.fromJson(await handleResponse(await buildHttpResponse('user-daily-water-goal-list?type=graph', method: HttpMethod.GET)));
}*/

Future<WaterGraph> getUserDailyWaterGraph({String? filter}) async {
  String url = "v1/user-daily-water-goal-list";
  if (!filter.isEmptyOrNull) {
    url += "?filter=$filter";
  }
  return WaterGraph.fromJson(
    await handleResponse(await buildHttpResponse(url)),
  );
}

Future<FitnessBaseResponse> setDailyStepsGoalApi(Map<String, dynamic> req) async =>
    FitnessBaseResponse.fromJson(
      await handleResponse(
        await buildHttpResponse(
          'user-daily-steps-goal-save',
          request: req,
          method: HttpMethod.POST,
        ),
      ),
    );

Future<WaterResponseModel> getDailyStepsGoalApi() async =>
    WaterResponseModel.fromJson(
      await handleResponse(
        await buildHttpResponse('user-daily-steps-goal-list?type=graph'),
      ),
    );

Future<WaterGraph> getUserDailyStepGraph({String? filter}) async {
  String url = "v1/user-daily-steps-goal-list";
  if (!filter.isEmptyOrNull) {
    url += "?filter=$filter";
  }
  return WaterGraph.fromJson(
    await handleResponse(await buildHttpResponse(url)),
  );
}

Future<AppSettingResponse> getAppSettingApi() async =>
    AppSettingResponse.fromJson(
      await handleResponse(await buildHttpResponse('get-appsetting')),
    );

Future<GetSettingResponse> getSettingApi() async => GetSettingResponse.fromJson(
  await handleResponse(await buildHttpResponse('get-setting')),
);

Future<FitBotListResponse> getFitBotList() async => FitBotListResponse.fromJson(
  await handleResponse(await buildHttpResponse('chatgpt-fit-bot-list')),
);

Future<FitBotSaveDataResponse> saveFitBotData(Map<String, dynamic> req) async =>
    FitBotSaveDataResponse.fromJson(
      await handleResponse(
        await buildHttpResponse(
          'chatgpt-fit-bot-save',
          request: req,
          method: HttpMethod.POST,
        ),
      ),
    );

Future<FitBotSaveDataResponse> deleteFitBotData() async =>
    FitBotSaveDataResponse.fromJson(
      await handleResponse(
        await buildHttpResponse(
          'chatgpt-fit-bot-delete',
          method: HttpMethod.POST,
        ),
      ),
    );

// Start Dashboard region
Future<AppConfigurationResponse> getAppConfiguration() async {
  final it = await handleResponse(
    await buildHttpResponse('mightyblogger/api/v1/blogger/get-configuration'),
  );
  return AppConfigurationResponse.fromJson(it);
}

//subscription
Future<ProgramResponse> getPrograms() async =>
    ProgramResponse.fromJson(
      await (handleResponse(await buildHttpResponse("package-list"))),
    );

Future<SubscribeProgramResponse> subscribeProgramApi(Map<String, dynamic> req) async =>
    SubscribeProgramResponse.fromJson(
      await handleResponse(
        await buildHttpResponse(
          'subscribe-package',
          request: req,
          method: HttpMethod.POST,
        ),
      ),
    );

Future<SubscriptionPlanResponse> getSubScriptionPlanList({
  int page = 1,
}) async => SubscriptionPlanResponse.fromJson(
  await (handleResponse(
    await buildHttpResponse("subscriptionplan-list?page=$page"),
  )),
);

Future<SubscribeProgramResponse> cancelPlanApi(Map<String, dynamic> req) async =>
    SubscribeProgramResponse.fromJson(
      await handleResponse(
        await buildHttpResponse(
          'cancel-subscription',
          request: req,
          method: HttpMethod.POST,
        ),
      ),
    );

Future<PaymentListModel> getPaymentApi() async => PaymentListModel.fromJson(
  await handleResponse(await buildHttpResponse('payment-gateway-list')),
);

Future<DietResponse> getSearchDietApi(
        {String? mSearch = "", int? page = 1}) async =>
    DietResponse.fromJson(
      await (handleResponse(
        await buildHttpResponse("diet-list?title=$mSearch&page=$page"),
      )),
    );

Future<DietModel> getSearchDietListApi() async => DietModel.fromJson(
      await (handleResponse(await buildHttpResponse("diet-list"))),
    );

Future<NotificationResponse> notificationApi() async =>
    NotificationResponse.fromJson(
      await handleResponse(
        await buildHttpResponse('notification-list', method: HttpMethod.POST),
      ),
    );

Future<NotificationResponse> notificationStatusApi(String? id) async =>
    NotificationResponse.fromJson(
      await handleResponse(
        await buildHttpResponse('notification-detail?id=$id'),
      ),
    );

Future<BlogResponse> getVideoApi({int? page = 1}) async =>
    BlogResponse.fromJson(
      await (handleResponse(await buildHttpResponse("post-list?page=$page"))),
    );

Future<SocialLoginResponse> saveScore(Map<String, dynamic> req) async =>
    SocialLoginResponse.fromJson(
      await handleResponse(
        await buildHttpResponse(
          'save-score',
          request: req,
          method: HttpMethod.POST,
        ),
      ),
    );

Future<GameResponse> getGamerRecord({int? page = 1}) async =>
    GameResponse.fromJson(
      await (handleResponse(await buildHttpResponse("get-score?page=$page"))),
    );

Future<PostList> getPostsApi({int? page = 1, int? userId}) async {
  String url = "userpost-list?page=$page";
  if (userId != null) {
    url += "&user_id=$userId";
  }
  return PostList.fromJson(await handleResponse(await buildHttpResponse(url)));
}

Future<PostDetailModel> getPostDetailApi({required int postId}) async =>
    PostDetailModel.fromJson(
      await handleResponse(
        await buildHttpResponse('userpost-detail?id=$postId'),
      ),
    );

Future<FitnessBaseResponse> reportApi(Map<String, dynamic> req) async =>
    FitnessBaseResponse.fromJson(
      await handleResponse(
        await buildHttpResponse(
          'report-on-posting',
          request: req,
          method: HttpMethod.POST,
        ),
      ),
    );

Future<FitnessBaseResponse> saveCommentApi(Map<String, dynamic> req) async =>
    FitnessBaseResponse.fromJson(
      await handleResponse(
        await buildHttpResponse(
          'save-comment',
          request: req,
          method: HttpMethod.POST,
        ),
      ),
    );

Future<PostList> updateCommentApi(Map<String, dynamic> req, int? id) async =>
    PostList.fromJson(
      await handleResponse(
        await buildHttpResponse(
          'comment-update/$id',
          request: req,
          method: HttpMethod.POST,
        ),
      ),
    );

Future<FitnessBaseResponse> likePostApi(Map<String, dynamic> req) async =>
    FitnessBaseResponse.fromJson(
      await handleResponse(
        await buildHttpResponse(
          'like-userpost',
          request: req,
          method: HttpMethod.POST,
        ),
      ),
    );

Future<FitnessBaseResponse> updateReCommentApi(
        Map<String, dynamic> req) async =>
    FitnessBaseResponse.fromJson(
      await handleResponse(
        await buildHttpResponse(
          'update-comment',
          request: req,
          method: HttpMethod.POST,
        ),
      ),
    );

Future<PostList> deletePostMediaApi(Map<String, dynamic> req) async =>
    PostList.fromJson(
      await handleResponse(
        await buildHttpResponse(
          'remove-userpost-media',
          request: req,
          method: HttpMethod.POST,
        ),
      ),
    );

Future<PostList> deletePostApi(Map<String, dynamic> req) async =>
    PostList.fromJson(
      await handleResponse(
        await buildHttpResponse(
          'delete-userpost',
          request: req,
          method: HttpMethod.POST,
        ),
      ),
    );

Future<FitnessBaseResponse> bookMarkPostApi(Map<String, dynamic> req) async =>
    FitnessBaseResponse.fromJson(
      await handleResponse(
        await buildHttpResponse(
          'bookmark-userpost',
          request: req,
          method: HttpMethod.POST,
        ),
      ),
    );

Future<BookmarkPostModel> getBookMarkPostsApi({int? page = 1}) async =>
    BookmarkPostModel.fromJson(
      await handleResponse(
        await buildHttpResponse('my-bookmark-post-list?page=$page'),
      ),
    );

Future<BookmarkPostModel> likesListApi(int id, int? page) async =>
    BookmarkPostModel.fromJson(
      await handleResponse(
        await buildHttpResponse(
          'like-userpost-list?posting_id= $id&page=$page',
        ),
      ),
    );

Future<FitnessBaseResponse> saveReCommentApi(Map<String, dynamic> req) async =>
    FitnessBaseResponse.fromJson(
      await handleResponse(
        await buildHttpResponse(
          'save-comment-reply',
          request: req,
          method: HttpMethod.POST,
        ),
      ),
    );

Future<FitnessBaseResponse> deleteReCommentApi(
        Map<String, dynamic> req) async =>
    FitnessBaseResponse.fromJson(
      await handleResponse(
        await buildHttpResponse(
          'delete-comment',
          request: req,
          method: HttpMethod.POST,
        ),
      ),
    );

Future<FitnessBaseResponse> deleteCommentReplyApi(
        Map<String, dynamic> req) async =>
    FitnessBaseResponse.fromJson(
      await handleResponse(
        await buildHttpResponse(
          'delete-comment-reply',
          request: req,
          method: HttpMethod.POST,
        ),
      ),
    );

Future<CommentListResponse> commentListApi(int id, int? page) async =>
    CommentListResponse.fromJson(
      await handleResponse(
        await buildHttpResponse('comment-list?posting_id=$id&page=$page'),
      ),
    );

Future<UpNextExerciseDataModel> getDayExerciseDetailApi(
  int exerciseId,
  int? workoutDayId,
  String? workoutId,
) async =>
    UpNextExerciseDataModel.fromJson(
      await handleResponse(
        await buildHttpResponse(
          'v1/workoutday-exercise-list?exercise_id=$exerciseId&workout_day_id=$workoutDayId&workout_id=$workoutId',
        ),
      ),
    );

Future<FitnessBaseResponse> storeUserWorkoutExercise(
        Map<String, dynamic> req) async =>
    FitnessBaseResponse.fromJson(
      await handleResponse(
        await buildHttpResponse(
          'v1/store-user-workout-exercise',
          request: req,
          method: HttpMethod.POST,
        ),
      ),
    );

Future<UserWorkoutHistory> getUserWorkoutExerciseApi() async =>
    UserWorkoutHistory.fromJson(
      await handleResponse(
        await buildHttpResponse('v1/get-user-workout-exercise'),
      ),
    );

Future<WorkoutResponse> getLevelWorkoutApi({
  int? page = 1,
  int? id,
  String? mSearchValue,
}) async {
  String url = "workout-list?level_ids=$id&page=$page";
  if (!mSearchValue.isEmptyOrNull) {
    url += "&title=$mSearchValue";
  }
  return WorkoutResponse.fromJson(
    await handleResponse(await buildHttpResponse(url)),
  );
}

Future<DailyPlanResponse> getDailyPlanDetailApi({String? date}) async {
  String url = 'daily-plan-detail';
  if (date.validate().isNotEmpty) {
    url += '?date=$date';
  }
  return DailyPlanResponse.fromJson(
    await handleResponse(await buildHttpResponse(url)),
  );
}

Future<DailyPlanRecipeListResponse> getRecipeFilterListApi({
  required List<String> mealTypes,
  List<int>? recipeCategoryIds,
  List<int>? recipeTagIds,
  int? startCalories,
  int? endCalories,
  int? startProtein,
  int? endProtein,
  int? startCarbs,
  int? endCarbs,
  int? startFats,
  int? endFats,
  int? minPreparationTime,
  int? maxPreparationTime,
  int page = 1,
  String? mSearch,
  int? isFavourite,
}) async {
  String url = 'recipe-filter-list?page=$page';

  if (isFavourite != null) url += '&is_favourite=$isFavourite';

  for (var type in mealTypes) {
    url += '&meal_type[]=$type';
  }
  if (recipeCategoryIds != null) {
    for (var id in recipeCategoryIds) {
      url += '&recipe_category_ids[]=$id';
    }
  }
  if (recipeTagIds != null) {
    for (var id in recipeTagIds) {
      url += '&recipe_tag_ids[]=$id';
    }
  }
  if (startCalories != null) url += '&start_calories=$startCalories';
  if (endCalories != null) url += '&end_calories=$endCalories';
  if (startProtein != null) url += '&start_protein=$startProtein';
  if (endProtein != null) url += '&end_protein=$endProtein';
  if (startCarbs != null) url += '&start_carbs=$startCarbs';
  if (endCarbs != null) url += '&end_carbs=$endCarbs';
  if (startFats != null) url += '&start_fats=$startFats';
  if (endFats != null) url += '&end_fats=$endFats';
  if (minPreparationTime != null) {
    url += '&min_preparation_time=$minPreparationTime';
  }
  if (maxPreparationTime != null) {
    url += '&max_preparation_time=$maxPreparationTime';
  }
  if (!mSearch.isEmptyOrNull) url += '&title=$mSearch';

  return DailyPlanRecipeListResponse.fromJson(
    await handleResponse(await buildHttpResponse(url)),
  );
}

Future<DailyPlanResponse> saveDailyPlanRecipeApi(
        Map<String, dynamic> req) async =>
    DailyPlanResponse.fromJson(
      await handleResponse(
        await buildHttpResponse(
          'save-daily-plan-recipe',
          request: req,
          method: HttpMethod.POST,
        ),
      ),
    );

Future<DailyPlanResponse> deleteDailyPlanRecipeApi(
        Map<String, dynamic> req) async =>
    DailyPlanResponse.fromJson(
      await handleResponse(
        await buildHttpResponse(
          'daily-plan-recipe-delete',
          request: req,
          method: HttpMethod.POST,
        ),
      ),
    );

Future<RecipeDetailResponse> getRecipeDetailApi({
  required int recipeId,
}) async =>
    RecipeDetailResponse.fromJson(
      await handleResponse(await buildHttpResponse('recipe-detail/$recipeId')),
    );

Future<DailyPlanResponse> deleteAllDailyPlanRecipeApi(
        Map<String, dynamic> req) async =>
    DailyPlanResponse.fromJson(
      await handleResponse(
        await buildHttpResponse(
          'daily-plan-recipe-delete-all',
          request: req,
          method: HttpMethod.POST,
        ),
      ),
    );
Future<MacroNutrientResponse> getMacroNutrientApi() async =>
    MacroNutrientResponse.fromJson(
      await handleResponse(await buildHttpResponse('get-macro-nutrient')),
    );

Future<RecipeCategoryResponse> getRecipeCategoryListApi({int page = 1}) async =>
    RecipeCategoryResponse.fromJson(
      await handleResponse(
          await buildHttpResponse('recipecategory-list?page=$page')),
    );

Future<RecipeTagResponse> getRecipeTagListApi({int page = 1}) async =>
    RecipeTagResponse.fromJson(
      await handleResponse(
          await buildHttpResponse('recipetag-list?page=$page')),
    );

Future<FitnessBaseResponse> setFavouriteRecipeApi(
        Map<String, dynamic> req) async =>
    FitnessBaseResponse.fromJson(
      await handleResponse(
        await buildHttpResponse(
          'set-favourite-recipe',
          request: req,
          method: HttpMethod.POST,
        ),
      ),
    );

Future<DailyPlanRecipeListResponse> getFavouriteRecipeApi({
  int? page = 1,
}) async =>
    DailyPlanRecipeListResponse.fromJson(
      await handleResponse(
        await buildHttpResponse('get-favourite-recipe?page=$page'),
      ),
    );

Future<ShoppingListResponse> getShoppingListApi({int page = 1}) async =>
    ShoppingListResponse.fromJson(
      await handleResponse(
        await buildHttpResponse('shopping-list?page=$page'),
      ),
    );

Future<ShoppingListResponse> saveShoppingListApi(
        Map<String, dynamic> req) async =>
    ShoppingListResponse.fromJson(
      await handleResponse(
        await buildHttpResponse(
          'shopping-list-save',
          request: req,
          method: HttpMethod.POST,
        ),
      ),
    );

Future<ShoppingListGenerateResponse> generateShoppingListApi(
        Map<String, dynamic> req) async =>
    ShoppingListGenerateResponse.fromJson(
      await handleResponse(
        await buildHttpResponse(
          'daily-plan-shopping-list-generate',
          request: req,
          method: HttpMethod.POST,
        ),
      ),
    );
Future<ShoppingListDetailResponse> getShoppingListDetailApi(
        {required int id}) async =>
    ShoppingListDetailResponse.fromJson(
      await handleResponse(
        await buildHttpResponse('shopping-list-detail?id=$id'),
      ),
    );

Future<FitnessBaseResponse> shoppingListItemToggleApi(
        Map<String, dynamic> req) async =>
    FitnessBaseResponse.fromJson(
      await handleResponse(
        await buildHttpResponse(
          'shopping-list-item-toggle',
          request: req,
          method: HttpMethod.POST,
        ),
      ),
    );

Future<MeasurementUnitResponse> getMeasurementUnitsApi() async =>
    MeasurementUnitResponse.fromJson(
      await handleResponse(
        await buildHttpResponse('get-measurementunit'),
      ),
    );

Future<FitnessBaseResponse> addShoppingListItemApi(
        Map<String, dynamic> req) async =>
    FitnessBaseResponse.fromJson(
      await handleResponse(
        await buildHttpResponse(
          'shopping-list-item-add',
          request: req,
          method: HttpMethod.POST,
        ),
      ),
    );

Future<FitnessBaseResponse> deleteShoppingListApi(
        Map<String, dynamic> req) async =>
    FitnessBaseResponse.fromJson(
      await handleResponse(
        await buildHttpResponse(
          'shopping-list-delete',
          request: req,
          method: HttpMethod.POST,
        ),
      ),
    );

Future<FoodRecognitionListResponse> getFoodRecognitionListApi({
  String status = 'success',
  int page = 1,
}) async =>
    FoodRecognitionListResponse.fromJson(
      await handleResponse(
        await buildHttpResponse(
          'food-recognition-list?status=$status&page=$page',
        ),
      ),
    );

Future<FoodRecognitionResponse> foodRecognitionApi(File media) async {
  final MultipartRequest multiPartRequest =
      await getMultiPartRequest('food-recognition');
  multiPartRequest.files.add(
    await MultipartFile.fromPath('media', media.path),
  );
  multiPartRequest.headers.addAll(buildHeaderTokens());
  multiPartRequest.headers.remove(HttpHeaders.contentTypeHeader);

  final Response response = await Response.fromStream(
    await multiPartRequest.send(),
  );

  if (response.statusCode.isSuccessful()) {
    return FoodRecognitionResponse.fromJson(jsonDecode(response.body));
  }

  String message = errorSomethingWentWrong;
  try {
    final dynamic body = jsonDecode(response.body);
    if (body is Map<String, dynamic>) {
      if (body['error'] is Map && body['error']['errorDetail'] != null) {
        message = body['error']['errorDetail'].toString();
      } else if (body['message'] != null) {
        message = body['message'].toString();
      }
    }
  } on Exception catch (_) {}
  throw Exception(message);
}
