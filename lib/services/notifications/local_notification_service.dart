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
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:dio/dio.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:googleapis_auth/auth_io.dart' as auth;
// import 'package:timezone/data/latest.dart' as tz;
// import 'package:timezone/timezone.dart' as tz;

// import '../../shared/constants/firebase_helper.dart';

// class LocalNotificationService {
//   static final LocalNotificationService _instance = LocalNotificationService._internal();
//   factory LocalNotificationService() => _instance;

//   static final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();
//   static final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

//   LocalNotificationService._internal();

//   static final _dio = Dio();

//   static Future<void> initialize() async {
//     const AndroidInitializationSettings androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
//     const DarwinInitializationSettings iosSettings = DarwinInitializationSettings(
//       requestAlertPermission: true,
//       requestBadgePermission: true,
//       requestSoundPermission: true,
//     );

//     const InitializationSettings settings = InitializationSettings(
//       android: androidSettings,
//       iOS: iosSettings,
//     );

//     await _notificationsPlugin.initialize(settings);
//     await _initializeFirebase();
//     await _setupInteractedMessage();
//     tz.initializeTimeZones();
//   }

//   static Future<void> _initializeFirebase() async {
//     await Firebase.initializeApp();

//     await _firebaseMessaging.requestPermission(
//       alert: true,
//       badge: true,
//       sound: true,
//       provisional: false,
//     );

//     // Set foreground notification options
//     await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
//       alert: true,
//       badge: true,
//       sound: true,
//     );

//     // Handle APNS token explicitly
//     final apnsToken = await _firebaseMessaging.getAPNSToken();
//     print('APNS Token: $apnsToken');

//     // Handle FCM token updates
//     // await _handleFCMToken();
//   }

//   static Future<void> _handleFCMToken() async {
//     final user = FirebaseHelper.currentUser;
//     if (user == null) return;
//     final userRole = await FirebaseHelper.getUserRole(user.uid);
//     final token = await _firebaseMessaging.getToken();

//     if (token != null) {
//       await FirebaseFirestore.instance.collection(userRole == 'users' ? 'users' : 'psychologist').doc(user.uid).update({
//         'fcmTokens': FieldValue.arrayUnion([token]),
//       });
//     }

//     _firebaseMessaging.onTokenRefresh.listen((newToken) async {
//       await FirebaseFirestore.instance.collection(userRole == 'users' ? 'users' : 'psychologist').doc(user.uid).update({
//         'fcmTokens': FieldValue.arrayUnion([newToken]),
//       });
//     });
//   }

//   static Future<void> _setupInteractedMessage() async {
//     RemoteMessage? initialMessage = await _firebaseMessaging.getInitialMessage();
//     if (initialMessage != null) {
//       _handleMessage(initialMessage);
//     }

//     FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
//     FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
//   }

//   static void _handleForegroundMessage(RemoteMessage message) {
//     _showNotification(message);
//   }

//   static void _handleMessage(RemoteMessage message) {
//     if (message.data['type'] == 'chat') {
//       // Navigate to chat screen
//       print('Navigate to chat with ${message.data['senderId']}');
//     }
//   }

//   static Future<void> _showNotification(RemoteMessage message) async {
//     final notification = message.notification;
//     final android = message.notification?.android;
//     final iOS = message.notification?.apple;

//     if (notification == null) return;

//     await _notificationsPlugin.show(
//       message.hashCode,
//       notification.title,
//       notification.body,
//       NotificationDetails(
//         android: AndroidNotificationDetails(
//           android?.channelId ?? 'high_importance_channel',
//           android?.channelId ?? 'High Importance Notifications',
//           importance: Importance.max,
//           priority: Priority.high,
//         ),
//         iOS: DarwinNotificationDetails(
//           presentAlert: true,
//           presentBadge: true,
//           presentSound: true,
//         ),
//       ),
//     );
//   }

//   static Future<void> scheduleDailyReminder(TimeOfDay time) async {
//     final now = tz.TZDateTime.now(tz.local);
//     var scheduledDate = tz.TZDateTime(
//       tz.local,
//       now.year,
//       now.month,
//       now.day,
//       time.hour,
//       time.minute,
//     );

//     if (scheduledDate.isBefore(now)) {
//       scheduledDate = scheduledDate.add(const Duration(days: 1));
//     }

//     await _notificationsPlugin.zonedSchedule(
//       0,
//       'Daily Reminder',
//       'Time to check in with your mood and journal!',
//       scheduledDate,
//       const NotificationDetails(
//         android: AndroidNotificationDetails(
//           'daily_reminder',
//           'Daily Reminders',
//           importance: Importance.high,
//         ),
//         iOS: DarwinNotificationDetails(
//           presentAlert: true,
//           presentBadge: true,
//           presentSound: true,
//         ),
//       ),
//       uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
//       matchDateTimeComponents: DateTimeComponents.time,
//       androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
//     );
//   }

//   static Future<String> getAccessToken() async {
//     final serviceAccountJson = {
//       "type": "service_account",
//       "project_id": "briefsea",
//       "private_key_id": dotenv.env['PRIVATE_KEY_ID'],
//       "private_key": dotenv.env['PRIVATE_KEY'],
//       "client_email": dotenv.env['Client_Email'],
//       "client_id": dotenv.env['Client_ID'],
//       "auth_uri": "https://accounts.google.com/o/oauth2/auth",
//       "token_uri": "https://oauth2.googleapis.com/token",
//       "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
//       "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-wnmhm%40briefsea.iam.gserviceaccount.com",
//       "universe_domain": "googleapis.com"
//     };

//     final client = await auth.clientViaServiceAccount(
//       auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
//       ['https://www.googleapis.com/auth/firebase.messaging'],
//     );

//     return client.credentials.accessToken.data;
//   }

//   static Future<void> sendChatNotification({
//     required String recipientId,
//     required String message,
//     required String senderId,
//   }) async {
//     final userDoc = await FirebaseFirestore.instance.collection('users').doc(recipientId).get();
//     final tokens = List<String>.from(userDoc.data()?['fcmTokens'] ?? []);

//     final accessToken = await getAccessToken();

//     if (tokens.isEmpty) return;

//     // final serverKey = 'YOUR_FIREBASE_SERVER_KEY';
//     // final headers = {
//     //   'Content-Type': 'application/json',
//     //   'Authorization': 'key=$serverKey',
//     // };

//     // final payload = {
//     //   "message": {
//     //     "token": userToken,
//     //     "notification": {"body": body, "title": title},
//     //     "data": {
//     //       if (threadId != null) 'threadId': threadId,
//     //       if (conversationId != null) 'conversationId': conversationId,
//     //     }
//     //   }
//     // };

//     final payload = {
//       'registration_ids': tokens,
//       'notification': {
//         'title': 'New Message',
//         'body': message,
//         'sound': 'default',
//       },
//       'data': {
//         'type': 'chat',
//         'senderId': senderId,
//         'click_action': 'FLUTTER_NOTIFICATION_CLICK',
//       },
//     };

//     // final response = await http.post(
//     //   Uri.parse('https://fcm.googleapis.com/fcm/send'),
//     //   headers: headers,
//     //   body: jsonEncode(payload),
//     // );
//     final response = await _dio.post(
//       "https://fcm.googleapis.com/v1/projects/mental-health/messages:send",
//       data: payload,
//       options: Options(
//         headers: {
//           "Authorization": 'Bearer $accessToken',
//           'Content-Type': 'application/json',
//         },
//       ),
//     );

//     if (response.statusCode != 200) {
//       throw Exception('FCM request failed: ${response.data}');
//     }
//   }
// }
