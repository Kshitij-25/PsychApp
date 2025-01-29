// State notifier to handle form data
import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class UserProfileFormNotifier extends StateNotifier<Map<String, dynamic>> {
  UserProfileFormNotifier()
      : super({
          'email': '',
          'fullName': '',
          'gender': '',
          'phoneNumber': '',
          'avatarPath': '',
          'avatarUrl': '',
          'avatarData': '',
          'dateOfBirth': null,
          'emergencyContact': '',
          // 'preferredLanguage': 'English',
          // 'timeZone': '',
          // 'occupation': '',
          // 'stressLevel': 1,
          // 'sleepHours': 8,
          // 'previousTherapy': false,
          // 'medications': [],
          // 'interests': [],
          // 'goals': [],
          'role': 'user',
          'createdAt': DateTime.now(),
          'updatedAt': DateTime.now(),
        });

  void updateField(String field, dynamic value) {
    state = {...state, field: value};
  }

  Future<String?> processImage(String filePath) async {
    try {
      final file = File(filePath);

      // Read file as bytes
      List<int> imageBytes = await file.readAsBytes();

      // Convert to base64
      String base64Image = base64Encode(imageBytes);

      // Check size (1MB limit for Firestore documents)
      if (base64Image.length > 700000) {
        // Leaving some room for other fields
        throw Exception('Image size too large. Please choose a smaller image.');
      }

      return base64Image;
    } catch (e) {
      print('Error processing image: $e');
      rethrow;
    }
  }

  Future<bool> submitProfile(String userId) async {
    try {
      state = {...state, 'updatedAt': DateTime.now()};

      // Process image if exists
      if (state['avatarPath'].isNotEmpty) {
        try {
          final base64Image = await processImage(state['avatarPath']);
          if (base64Image != null) {
            state = {...state, 'avatarData': base64Image};
          }
        } catch (e) {
          print('Image processing failed: $e');
          // Continue with profile creation even if image processing fails
        }
      }

      // Prepare data for Firestore
      final dataToSave = Map<String, dynamic>.from(state);

      if (dataToSave.toString().length > 900000) {
        // Leave room for metadata
        throw Exception('Profile data too large');
      }

      dataToSave.remove('avatarPath');

      // Save to Firestore
      await FirebaseFirestore.instance.collection('users').doc(userId).set(dataToSave, SetOptions(merge: true));

      return true;
    } catch (e) {
      print('Error submitting profile: $e');
      return false;
    }
  }
}

final userProfileFormProvider = StateNotifierProvider<UserProfileFormNotifier, Map<String, dynamic>>(
  (ref) => UserProfileFormNotifier(),
);
