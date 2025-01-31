// Provider for managing notification settings
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../services/notifications/local_notification_service.dart';

final notificationSettingsProvider = StateNotifierProvider<NotificationSettingsNotifier, NotificationSettings>((ref) {
  return NotificationSettingsNotifier();
});

// Notification Settings Data Class
class NotificationSettings {
  final bool areNotificationsEnabled;
  final bool moodLogNotifications;
  final bool journalEntryNotifications;
  final TimeOfDay notificationTime;

  const NotificationSettings({
    this.areNotificationsEnabled = true,
    this.moodLogNotifications = true,
    this.journalEntryNotifications = true,
    this.notificationTime = const TimeOfDay(hour: 20, minute: 0),
  });

  NotificationSettings copyWith({
    bool? areNotificationsEnabled,
    bool? moodLogNotifications,
    bool? journalEntryNotifications,
    TimeOfDay? notificationTime,
  }) {
    return NotificationSettings(
      areNotificationsEnabled: areNotificationsEnabled ?? this.areNotificationsEnabled,
      moodLogNotifications: moodLogNotifications ?? this.moodLogNotifications,
      journalEntryNotifications: journalEntryNotifications ?? this.journalEntryNotifications,
      notificationTime: notificationTime ?? this.notificationTime,
    );
  }
}

// Notifier for managing notification settings
class NotificationSettingsNotifier extends StateNotifier<NotificationSettings> {
  NotificationSettingsNotifier() : super(const NotificationSettings()) {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    state = NotificationSettings(
      areNotificationsEnabled: prefs.getBool('notifications_enabled') ?? true,
      moodLogNotifications: prefs.getBool('mood_log_notifications') ?? true,
      journalEntryNotifications: prefs.getBool('journal_entry_notifications') ?? true,
      notificationTime: TimeOfDay(
        hour: prefs.getInt('notification_hour') ?? 20,
        minute: prefs.getInt('notification_minute') ?? 0,
      ),
    );
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notifications_enabled', state.areNotificationsEnabled);
    await prefs.setBool('mood_log_notifications', state.moodLogNotifications);
    await prefs.setBool('journal_entry_notifications', state.journalEntryNotifications);
    await prefs.setInt('notification_hour', state.notificationTime.hour);
    await prefs.setInt('notification_minute', state.notificationTime.minute);
  }

  void toggleNotifications(bool value) {
    state = state.copyWith(areNotificationsEnabled: value);
    _saveSettings();
    _updateNotificationSchedule();
  }

  void toggleMoodLogNotifications(bool value) {
    state = state.copyWith(moodLogNotifications: value);
    _saveSettings();
    _updateNotificationSchedule();
  }

  void toggleJournalEntryNotifications(bool value) {
    state = state.copyWith(journalEntryNotifications: value);
    _saveSettings();
    _updateNotificationSchedule();
  }

  void updateNotificationTime(TimeOfDay time) {
    state = state.copyWith(notificationTime: time);
    _saveSettings();
    _updateNotificationSchedule();
  }

  void _updateNotificationSchedule() {
    final localNotificationService = LocalNotificationService();

    if (state.areNotificationsEnabled) {
      localNotificationService.scheduleAllNotifications(
        state.moodLogNotifications,
        state.journalEntryNotifications,
        state.notificationTime.hour,
        state.notificationTime.minute,
      );
    } else {
      localNotificationService.cancelAllNotifications();
    }
  }
}

// import 'package:flutter/material.dart';
// import 'package:hooks_riverpod/hooks_riverpod.dart';

// import '../../data/models/notification_model.dart';

// class NotificationSettingsNotifier extends StateNotifier<NotificationModel> {
//   NotificationSettingsNotifier() : super(const NotificationModel());

//   void toggleNotifications(bool value) {
//     state = state.copyWith(areNotificationsEnabled: value);
//   }

//   void toggleMoodLogNotifications(bool value) {
//     state = state.copyWith(moodLogNotifications: value);
//   }

//   void toggleJournalEntryNotifications(bool value) {
//     state = state.copyWith(journalEntryNotifications: value);
//   }

//   void toggleChatNotifications(bool value) {
//     state = state.copyWith(chatNotifications: value);
//   }

//   void updateNotificationTime(TimeOfDay newTime) {
//     state = state.copyWith(notificationTime: newTime);
//   }
// }

// final notificationSettingsProvider = StateNotifierProvider<NotificationSettingsNotifier, NotificationModel>(
//   (ref) => NotificationSettingsNotifier(),
// );
