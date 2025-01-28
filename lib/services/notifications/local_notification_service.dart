import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class LocalNotificationService {
  static final LocalNotificationService _instance = LocalNotificationService._internal();
  factory LocalNotificationService() => _instance;

  static final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  LocalNotificationService._internal();

  Future<void> onDidReceiveLocalNotification(int id, String? title, String? body, String? payload) async {
    // Handle notification when app is in background or terminated
    print('iOS Local Notification: $title - $body');
    // You can also navigate or show a dialog here
  }

  static Future<void> initialize() async {
    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');

    final DarwinInitializationSettings initializationSettingsIOS = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await _flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: (NotificationResponse response) async {
      // Handle notification tap
      if (response.payload != null) {
        print('Notification payload: ${response.payload}');
        // Navigate to a specific screen if needed
      }
    });

    tz.initializeTimeZones();
    final location = tz.getLocation('Asia/Kolkata');
    tz.setLocalLocation(location);
  }

  Future<void> requestPermission() async {
    // Android permissions
    final bool? granted = await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();

    if (granted == false) {
      print('Notification permissions denied on Android.');
    }

    // iOS permissions
    await _flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  Future<void> scheduleNotificationForOneMinute() async {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    print(tz.local);
    final tz.TZDateTime scheduledTime = now.add(Duration(minutes: 1)); // Add 1 minute

    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'one_minute_reminder',
      'Mood Tracker Reminders',
      channelDescription: 'Encourages users to track their moods daily',
      importance: Importance.high,
      priority: Priority.high,
    );

    const DarwinNotificationDetails iOSDetails = DarwinNotificationDetails(
      presentAlert: true, // Show alert
      presentBadge: true, // Update badge
      presentSound: true, // Play sound
    );

    const NotificationDetails platformDetails = NotificationDetails(
      android: androidDetails,
      iOS: iOSDetails,
    );

    await LocalNotificationService._flutterLocalNotificationsPlugin.zonedSchedule(
      0, // Notification ID
      'Track Your Mood', // Title
      'How are you feeling today? Tap to track your mood!',
      scheduledTime, // Scheduled time (1 minute from now)
      platformDetails,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
      androidScheduleMode: AndroidScheduleMode.exact,
    );
  }

  Future<void> scheduleDailyMoodReminder(int hour, int minute) async {
    print('Scheduled time: $hour $minute');

    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'daily_mood_reminder',
      'Mood Tracker Reminders',
      channelDescription: 'Encourages users to track their moods daily',
      importance: Importance.high,
      priority: Priority.high,
      showWhen: false,
    );

    const DarwinNotificationDetails iOSDetails = DarwinNotificationDetails(
      presentAlert: true, // Show alert
      presentBadge: true, // Update badge
      presentSound: true, // Play sound
    );

    const NotificationDetails platformDetails = NotificationDetails(
      android: androidDetails,
      iOS: iOSDetails,
    );

    await _flutterLocalNotificationsPlugin.zonedSchedule(
      0, // Notification ID
      'Track Your Mood', // Title
      'How are you feeling today? Tap to track your mood!', // Body
      _nextInstanceOfSpecificTime(hour, minute), // Scheduled time
      platformDetails,
      // androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
      androidScheduleMode: AndroidScheduleMode.exact,
    );
  }

  tz.TZDateTime _nextInstanceOfSpecificTime(int hour, int minute) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  Future<void> cancelAllNotifications() async {
    await _flutterLocalNotificationsPlugin.cancelAll();
  }

  Future<void> cancelNotificationById(int id) async {
    await _flutterLocalNotificationsPlugin.cancel(id);
  }

  Future<void> scheduleJournalEntryReminder(int hour, int minute) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'daily_journal_reminder',
      'Journal Tracker Reminders',
      channelDescription: 'Encourages users to write daily journal entries',
      importance: Importance.high,
      priority: Priority.high,
      showWhen: false,
    );

    const DarwinNotificationDetails iOSDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails platformDetails = NotificationDetails(
      android: androidDetails,
      iOS: iOSDetails,
    );

    await _flutterLocalNotificationsPlugin.zonedSchedule(
      1, // Different notification ID for journal entries
      'Journal Time',
      'Take a moment to reflect. Write in your journal today!',
      _nextInstanceOfSpecificTime(hour, minute),
      platformDetails,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
      androidScheduleMode: AndroidScheduleMode.exact,
    );
  }

  // Method to schedule both mood and journal notifications
  Future<void> scheduleAllNotifications(bool moodNotificationsEnabled, bool journalNotificationsEnabled, int hour, int minute) async {
    // Cancel existing notifications first
    await cancelAllNotifications();

    // Schedule mood notifications if enabled
    if (moodNotificationsEnabled) {
      await scheduleDailyMoodReminder(hour, minute);
    }

    // Schedule journal notifications if enabled
    if (journalNotificationsEnabled) {
      await scheduleJournalEntryReminder(hour, minute);
    }
  }
}
