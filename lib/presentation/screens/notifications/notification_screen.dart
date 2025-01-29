import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../notifiers/notification_notifier.dart';

// Notification Settings Page
class NotificationScreen extends HookConsumerWidget {
  static const routeName = '/notificationScreen';
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationSettings = ref.watch(notificationSettingsProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        forceMaterialTransparency: true,
        centerTitle: false,
        title: Text(
          'Notifications',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Master notification toggle
          SwitchListTile.adaptive(
            activeColor: Theme.of(context).colorScheme.primaryContainer,
            title: const Text('Enable Notifications'),
            value: notificationSettings.areNotificationsEnabled,
            onChanged: (bool value) => ref.read(notificationSettingsProvider.notifier).toggleNotifications(value),
          ),

          // Conditional settings when notifications are enabled
          if (notificationSettings.areNotificationsEnabled) ...[
            // Mood Log Notifications
            SwitchListTile.adaptive(
              activeColor: Theme.of(context).colorScheme.primaryContainer,
              title: const Text('Mood Log Notifications'),
              subtitle: const Text('Get daily reminders to log your mood'),
              value: notificationSettings.moodLogNotifications,
              onChanged: (bool value) => ref.read(notificationSettingsProvider.notifier).toggleMoodLogNotifications(value),
            ),

            // Journal Entry Notifications
            SwitchListTile.adaptive(
              activeColor: Theme.of(context).colorScheme.primaryContainer,
              title: const Text('Journal Entry Notifications'),
              subtitle: const Text('Get daily reminders to write journal entries'),
              value: notificationSettings.journalEntryNotifications,
              onChanged: (bool value) => ref.read(notificationSettingsProvider.notifier).toggleJournalEntryNotifications(value),
            ),

            // Notification Time Picker
            ListTile(
              title: const Text('Notification Time'),
              subtitle: Text(
                notificationSettings.notificationTime.format(context),
                style: const TextStyle(color: Colors.blue),
              ),
              trailing: const Icon(Icons.access_time),
              onTap: () => _selectNotificationTime(context, ref),
            ),
          ],
        ],
      ),
    );
  }

  // Time picker method
  Future<void> _selectNotificationTime(BuildContext context, WidgetRef ref) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: ref.read(notificationSettingsProvider).notificationTime,
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
          child: child!,
        );
      },
    );

    if (picked != null) {
      ref.read(notificationSettingsProvider.notifier).updateNotificationTime(picked);
    }
  }
}
