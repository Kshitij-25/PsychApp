import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

import '../../data/models/user_profile_data/emergeny_contact_model.dart';
import '../../data/models/user_profile_data/therapy_preferences_model.dart';
import '../../data/models/user_profile_data/user_profile_model.dart';

class HiveHelper {
  static const String _profileBoxName = 'userProfileBox';
  static const String _roleBoxName = 'userRoleBox';

  /// Get the user profile box
  static Future<Box<UserProfileModel>> _getProfileBox() async {
    if (!Hive.isBoxOpen(_profileBoxName)) {
      try {
        await Hive.openBox<UserProfileModel>(_profileBoxName);
      } catch (e) {
        rethrow;
      }
    }
    return Hive.box<UserProfileModel>(_profileBoxName);
  }

  /// Get the user role box
  static Future<Box<String>> _getRoleBox() async {
    if (!Hive.isBoxOpen(_roleBoxName)) {
      try {
        await Hive.openBox<String>(_roleBoxName);
      } catch (e) {
        rethrow;
      }
    }
    return Hive.box<String>(_roleBoxName);
  }

  /// Initialize Hive with iOS Document Directory
  static Future<void> init() async {
    final directory = await getApplicationDocumentsDirectory();
    Hive.init(directory.path);

    Hive.registerAdapter(UserProfileModelAdapter());
    Hive.registerAdapter(EmergenyContactModelAdapter());
    Hive.registerAdapter(TherapyPreferencesModelAdapter());

    await _getProfileBox();
    await _getRoleBox();
  }

  /// Save User Data
  static Future<void> saveUserData(Map<String, dynamic> jsonData) async {
    final profileBox = await _getProfileBox();
    final roleBox = await _getRoleBox();

    final userData = UserProfileModel.fromJson(jsonData['profile']);
    final currentUserRole = jsonData['role'];

    await profileBox.put('currentUser', userData);
    await roleBox.put('currentUserRole', currentUserRole);
  }

  /// Get User Data
  static Future<UserProfileModel?> getUserData() async {
    final box = await _getProfileBox();
    if (!box.containsKey('currentUser')) {
      return null;
    }
    return box.get('currentUser');
  }

  static Future<String?> getUserRole() async {
    final box = await _getRoleBox();
    if (!box.containsKey('currentUserRole')) {
      return null;
    }
    return box.get('currentUserRole');
  }

  /// Check if User is Logged In
  static Future<bool> isLoggedIn() async {
    final user = await getUserData();
    return user != null;
  }

  /// Delete User (Logout)
  static Future<void> deleteUser() async {
    final profileBox = await _getProfileBox();
    final roleBox = await _getRoleBox();

    await profileBox.delete('currentUser');
    await roleBox.delete('currentUserRole');
  }

  /// Update User Data
  static Future<void> updateUser(UserProfileModel user) async {
    final profileBox = await _getProfileBox();
    await profileBox.put('currentUser', user);
  }
}
