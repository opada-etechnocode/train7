import '../utils/shared_import.dart';

UserWorkoutHistory userWorkoutHistoryFromJson(String str) =>
    UserWorkoutHistory.fromJson(json.decode(str));

String userWorkoutHistoryToJson(UserWorkoutHistory data) =>
    json.encode(data.toJson());

class UserWorkoutHistory {
  UserWorkoutHistory({required this.pagination, required this.data});

  Pagination pagination;
  List<WorkoutHistoryData> data;

  factory UserWorkoutHistory.fromJson(Map<String, dynamic> json) =>
      UserWorkoutHistory(
        pagination: Pagination.fromJson(json["pagination"]),
        data: List<WorkoutHistoryData>.from(
          json["data"].map((dynamic x) => WorkoutHistoryData.fromJson(x)),
        ),
      );

  Map<String, dynamic> toJson() => {
    "pagination": pagination.toJson(),
    "data": List<dynamic>.from(data.map((dynamic x) => x.toJson())),
  };
}

class WorkoutHistoryData {
  WorkoutHistoryData({
    required this.exerciseImage,
    required this.workoutImage,
    required this.updatedAt,
    required this.exerciseId,
    required this.workoutDayId,
    required this.workoutTitle,
    required this.createdAt,
    required this.id,
    required this.workoutId,
    required this.exerciseIsPremium,
    required this.exerciseTitle,
  });

  String exerciseImage;
  String workoutImage;
  DateTime updatedAt;
  int exerciseId;
  int workoutDayId;
  String workoutTitle;
  DateTime createdAt;
  int id;
  int workoutId;
  int exerciseIsPremium;
  String exerciseTitle;

  factory WorkoutHistoryData.fromJson(Map<String, dynamic> json) =>
      WorkoutHistoryData(
        exerciseImage: json["exercise_image"],
        workoutImage: json["workout_image"],
        updatedAt: DateTime.parse(json["updated_at"]),
        exerciseId: json["exercise_id"],
        workoutDayId: json["workout_day_id"],
        workoutTitle: json["workout_title"],
        createdAt: DateTime.parse(json["created_at"]),
        id: json["id"],
        workoutId: json["workout_id"],
        exerciseIsPremium: json["exercise_is_premium"],
        exerciseTitle: json["exercise_title"],
      );

  Map<String, dynamic> toJson() => {
    "exercise_image": exerciseImage,
    "workout_image": workoutImage,
    "updated_at": updatedAt.toIso8601String(),
    "exercise_id": exerciseId,
    "workout_day_id": workoutDayId,
    "workout_title": workoutTitle,
    "created_at": createdAt.toIso8601String(),
    "id": id,
    "workout_id": workoutId,
    "exercise_is_premium": exerciseIsPremium,
    "exercise_title": exerciseTitle,
  };
}
