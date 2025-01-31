import 'package:flutter/material.dart';

class NotificationModel {
  final bool areNotificationsEnabled;
  final bool moodLogNotifications;
  final bool journalEntryNotifications;
  final bool chatNotifications;
  final TimeOfDay notificationTime;

  const NotificationModel({
    this.areNotificationsEnabled = true,
    this.moodLogNotifications = true,
    this.journalEntryNotifications = true,
    this.chatNotifications = true,
    this.notificationTime = const TimeOfDay(hour: 20, minute: 0),
  });

  NotificationModel copyWith({
    bool? areNotificationsEnabled,
    bool? moodLogNotifications,
    bool? journalEntryNotifications,
    bool? chatNotifications,
    TimeOfDay? notificationTime,
  }) {
    return NotificationModel(
      areNotificationsEnabled: areNotificationsEnabled ?? this.areNotificationsEnabled,
      moodLogNotifications: moodLogNotifications ?? this.moodLogNotifications,
      journalEntryNotifications: journalEntryNotifications ?? this.journalEntryNotifications,
      chatNotifications: chatNotifications ?? this.chatNotifications,
      notificationTime: notificationTime ?? this.notificationTime,
    );
  }
}
