import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:psych_app/firebase_options.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
import 'services/netwok/network_helper.dart';
import 'services/notifications/local_notification_service.dart';
import 'shared/routers/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

// Wrap Firebase initialization in try-catch for better error handling
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    debugPrint('Firebase initialization error: $e');
    // Handle initialization error gracefully
  }

  // Optional: Enable offline persistence
  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
    cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
    sslEnabled: true,
    host: 'firestore.googleapis.com',
  );
  // Add error handling for Flutter errors
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    debugPrint('Flutter error: ${details.exception}');
  };
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  await dotenv.load();

  final prefs = await SharedPreferences.getInstance();

  NetworkHelper.initialize(); // Add this

  await AppRouter.setupRoutes();

  // Initialize notification service
  await LocalNotificationService.initialize();
  // await LocalNotificationService().requestPermission();

  if (kDebugMode) {
    prefs.clear();
  }

  if (kDebugMode) {
    HttpOverrides.global = CustomHttpOverrides();
  }

  runApp(ProviderScope(child: const MainApp()));
}

class CustomHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}
