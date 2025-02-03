import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../notifiers/notification_notifier.dart';

class NotificationScreen extends ConsumerWidget {
  static const routeName = '/notificationScreen';
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationSettings = ref.watch(notificationSettingsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          SwitchListTile.adaptive(
            title: const Text('Enable Notifications'),
            value: notificationSettings.areNotificationsEnabled,
            onChanged: (value) => ref.read(notificationSettingsProvider.notifier).toggleNotifications(value),
          ),
          if (notificationSettings.areNotificationsEnabled) ...[
            const Divider(),
            SwitchListTile.adaptive(
              title: const Text('Mood Log Reminders'),
              subtitle: const Text('Daily reminders to log your mood'),
              value: notificationSettings.moodLogNotifications,
              onChanged: (value) => ref.read(notificationSettingsProvider.notifier).toggleMoodLogNotifications(value),
            ),
            SwitchListTile.adaptive(
              title: const Text('Journal Entry Reminders'),
              subtitle: const Text('Daily reminders to write journal entries'),
              value: notificationSettings.journalEntryNotifications,
              onChanged: (value) => ref.read(notificationSettingsProvider.notifier).toggleJournalEntryNotifications(value),
            ),
            // SwitchListTile.adaptive(
            //   title: const Text('Chat Notifications'),
            //   subtitle: const Text('Notifications for new messages'),
            //   value: notificationSettings.chatNotifications,
            //   onChanged: (value) => ref.read(notificationSettingsProvider.notifier).toggleChatNotifications(value),
            // ),
            ListTile(
              title: const Text('Notification Time'),
              subtitle: Text(notificationSettings.notificationTime.format(context)),
              trailing: const Icon(Icons.access_time),
              onTap: () => _selectTime(context, ref),
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _selectTime(BuildContext context, WidgetRef ref) async {
    final initialTime = ref.read(notificationSettingsProvider).notificationTime;
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: initialTime,
    );

    if (pickedTime != null) {
      ref.read(notificationSettingsProvider.notifier).updateNotificationTime(pickedTime);
    }
  }
}
