import 'dart:developer' show log;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../main.dart';
import '../extensions/constants.dart';
import '../extensions/shared_pref.dart';
import '../models/login_response.dart';
import '../service/base_service.dart';
import '../utils/app_common.dart';
import '../utils/app_constants.dart';

class UserService extends BaseService {
  FirebaseFirestore fireStore = FirebaseFirestore.instance;

  UserService() {
    ref = fireStore.collection(USER_COLLECTION);
  }

  Future<void> updateUserStatus(Map<String, dynamic> data, String id) async =>
      ref!.doc(id).update(data as Map<String, Object?>);

  Future<UserModel> getUser({String? email}) =>
      ref!.where(KEY_EMAIL, isEqualTo: email).limit(1).get().then((value) {
        if (value.docs.length == 1) {
          return UserModel.fromJson(
            value.docs.first.data() as Map<String, dynamic>,
          );
        } else {
          throw Exception('User Not found');
        }
      });

  Future<UserModel> getUserById({String? val}) =>
      ref!.where(KEY_UID, isEqualTo: val).limit(1).get().then((value) {
        if (value.docs.length == 1) {
          return UserModel.fromJson(
            value.docs.first.data() as Map<String, dynamic>,
          );
        } else {
          throw Exception('User Not found');
        }
      });

  @override
  Stream<List<UserModel>> users({String? searchText}) => ref!
      .where(
        KEY_CASE_SEARCH,
        arrayContains: searchText?.isEmpty ?? false
            ? null
            : searchText!.toLowerCase(),
      )
      .snapshots()
      .map(
        (x) => x.docs
            .map((y) => UserModel.fromJson(y.data() as Map<String, dynamic>))
            .toList(),
      );

  Query userWithPagination({String? searchText}) => ref!
      .where(
        KEY_CASE_SEARCH,
        arrayContains: searchText?.isEmpty ?? false
            ? null
            : searchText!.toLowerCase(),
      )
      .orderBy(KEY_FIREBASE_CREATED_AT, descending: true);

  Future<UserModel> userByEmail(String? email) async => await ref!
      .where(KEY_EMAIL, isEqualTo: email)
      .limit(1)
      .get()
      .then((value) {
        if (value.docs.isNotEmpty) {
          return UserModel.fromJson(
            value.docs.first.data() as Map<String, dynamic>,
          );
        } else {
          throw Exception('No User Found');
        }
      });

  Stream<UserModel> singleUser(String? id, {String? searchText}) => ref!
      .where(KEY_UID, isEqualTo: id)
      .limit(1)
      .snapshots()
      .map(
        (event) =>
            UserModel.fromJson(event.docs.first.data() as Map<String, dynamic>),
      );

  Future<UserModel> getUserByUserId({String? id}) =>
      ref!.where(KEY_UID, isEqualTo: id).get().then((value) {
        log(value.docs.toString());
        return UserModel.fromJson(
          value.docs.first.data() as Map<String, dynamic>,
        );
      });

  Future<UserModel> userByMobileNumber(String? phone) async => await ref!
      .where(KEY_PHONE_NUMBER, isEqualTo: phone)
      .limit(1)
      .get()
      .then((value) {
        if (value.docs.isNotEmpty) {
          return UserModel.fromJson(
            value.docs.first.data() as Map<String, dynamic>,
          );
        } else {
          throw Exception(EXCEPTION_NO_USER_FOUND);
        }
      });

  DocumentReference getUserReference({required String uid}) =>
      userService.ref!.doc(uid);

  @override
  Future<void> removeDocument(String? id) => userService.ref!.doc(id).delete();

  Future<String> unBlockUser(Map<String, dynamic> data) async => await ref!
      .doc(getStringAsync(UID))
      .update(data)
      .then((value) => "User Blocked")
      .catchError((Object e) {
        toast(e.toString());
        throw Exception(errorSomethingWentWrong);
      });

  Future<String> blockUser(Map<String, dynamic> data) async => await ref!
      .doc(getStringAsync(UID))
      .update(data)
      .then((value) => "User Blocked")
      .catchError((Object e) {
        toast(e.toString());
        throw Exception(errorSomethingWentWrong);
      });

  Future<bool> isUserBlocked(String uid) async => await userService
      .userByEmail(getStringAsync(EMAIL))
      .then((value) => value.blockedTo!.contains(getUserReference(uid: uid)));

  ///DeleteUserFirebase
  Future<void> deleteUserFirebase() async {
    if (FirebaseAuth.instance.currentUser != null) {
      FirebaseAuth.instance.currentUser!.delete();
      await FirebaseAuth.instance.signOut();
    }
  }
}
