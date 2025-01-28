import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../shared/constants/firebase_helper.dart';
import '../local_data_source/mood_states.dart';

class MoodStorage {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Map<String, String>> loadMoods(String uid) async {
    try {
      final querySnapshot = await _firestore.collection('users').doc(uid).collection('moods').get();

      final Map<String, String> loadedMoods = {};
      for (var doc in querySnapshot.docs) {
        loadedMoods[doc.id] = doc.data()['overallMood'] as String;
      }
      return loadedMoods;
    } catch (e) {
      print('Error loading moods: $e');
      return {};
    }
  }

  Future<Map<DateTime, Map<String, dynamic>>> loadSavedData() async {
    try {
      final FirebaseFirestore _firestore = FirebaseFirestore.instance;
      final String uid = FirebaseHelper.currentUserId ?? '';
      if (uid.isEmpty) {
        throw Exception('User not authenticated');
      }

      // Query the moods collection for the current user
      final QuerySnapshot querySnapshot = await _firestore.collection('users').doc(uid).collection('moods').get();

      Map<DateTime, Map<String, dynamic>> savedData = {};

      for (var doc in querySnapshot.docs) {
        try {
          final data = doc.data() as Map<String, dynamic>;

          // Convert Timestamp to DateTime
          final DateTime date = (data['timestamp'] as Timestamp).toDate();

          savedData[date] = {
            'mood': data['overallMood'] as String,
            'chips': (data['emotions'] as List<dynamic>).cast<String>(),
            'lastUpdated': (data['lastUpdated'] as Timestamp).toDate(),
          };
        } catch (e) {
          debugPrint('Error parsing document ${doc.id}: $e');
          continue;
        }
      }

      return savedData;
    } catch (e) {
      debugPrint('Error loading mood data: $e');
      return {};
    }
  }

  // Helper method to load data for a specific date range
  Future<Map<DateTime, Map<String, dynamic>>> loadSavedDataForRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      final String uid = FirebaseHelper.currentUserId ?? '';
      if (uid.isEmpty) {
        throw Exception('User not authenticated');
      }

      final QuerySnapshot querySnapshot = await _firestore
          .collection('users')
          .doc(uid)
          .collection('moods')
          .where('timestamp', isGreaterThanOrEqualTo: startDate)
          .where('timestamp', isLessThanOrEqualTo: endDate)
          .get();

      Map<DateTime, Map<String, dynamic>> savedData = {};

      for (var doc in querySnapshot.docs) {
        try {
          final data = doc.data() as Map<String, dynamic>;
          final DateTime date = (data['timestamp'] as Timestamp).toDate();

          savedData[date] = {
            'mood': data['overallMood'] as String,
            'chips': (data['emotions'] as List<dynamic>).cast<String>(),
            'lastUpdated': (data['lastUpdated'] as Timestamp).toDate(),
          };
        } catch (e) {
          debugPrint('Error parsing document ${doc.id}: $e');
          continue;
        }
      }

      return savedData;
    } catch (e) {
      debugPrint('Error loading mood data for range: $e');
      return {};
    }
  }

  // Helper method to load data for a specific month
  Future<Map<DateTime, Map<String, dynamic>>> loadSavedDataForMonth(DateTime month) async {
    final startDate = DateTime(month.year, month.month, 1);
    final endDate = DateTime(month.year, month.month + 1, 0, 23, 59, 59);

    return loadSavedDataForRange(startDate, endDate);
  }

  // Stream version for real-time updates
  Stream<Map<DateTime, Map<String, dynamic>>> streamSavedData() {
    final String uid = FirebaseHelper.currentUserId ?? '';
    if (uid.isEmpty) {
      return Stream.value({});
    }

    return _firestore.collection('users').doc(uid).collection('moods').snapshots().map((snapshot) {
      Map<DateTime, Map<String, dynamic>> savedData = {};

      for (var doc in snapshot.docs) {
        try {
          final data = doc.data();
          final DateTime date = (data['timestamp'] as Timestamp).toDate();

          savedData[date] = {
            'mood': data['overallMood'] as String,
            'chips': (data['emotions'] as List<dynamic>).cast<String>(),
            'lastUpdated': (data['lastUpdated'] as Timestamp).toDate(),
          };
        } catch (e) {
          debugPrint('Error parsing document ${doc.id}: $e');
          continue;
        }
      }

      return savedData;
    });
  }

  Future<void> saveMood({
    required String uid,
    required DateTime selectedDay,
    required Set<String> currentMoods,
    required ValueNotifier<Map<DateTime, String>> moods,
  }) async {
    try {
      final String dateKey = selectedDay.toIso8601String();
      final String overallMood = await determineOverallMoodLocally(currentMoods);

      // Create mood document data
      final moodData = {
        'overallMood': overallMood,
        'emotions': currentMoods.toList(),
        'timestamp': selectedDay,
        'lastUpdated': FieldValue.serverTimestamp(),
      };

      // Save to Firestore
      await _firestore.collection('users').doc(uid).collection('moods').doc(dateKey).set(moodData);

      // Update local state
      moods.value = {
        ...moods.value,
        selectedDay: overallMood,
      };
    } catch (e) {
      print('Error saving mood: $e');
      throw e;
    }
  }

  // Option 1: Client-side mood determination (original approach)
  String determineOverallMoodLocally(Set<String> selectedEmotions) {
    if (selectedEmotions.isEmpty) return "neutral";

    int positiveCount = selectedEmotions.where((e) => positiveEmotions.contains(e)).length;
    int neutralCount = selectedEmotions.where((e) => neutralEmotions.contains(e)).length;
    int negativeCount = selectedEmotions.where((e) => negativeEmotions.contains(e)).length;

    double positiveScore = positiveCount * 1.2;
    double neutralScore = neutralCount * 1.0;
    double negativeScore = negativeCount * 1.1;

    if (positiveScore > neutralScore && positiveScore > negativeScore) {
      return "happy";
    } else if (negativeScore > positiveScore && negativeScore > neutralScore) {
      return "sad";
    } else {
      return "neutral";
    }
  }
}
