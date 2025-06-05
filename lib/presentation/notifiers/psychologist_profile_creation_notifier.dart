// State notifier to handle form data
import 'dart:convert';
import 'dart:io';

import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../data/models/professional_profile_data/professional_profile_model.dart';

class PsychologistProfileCreationNotifier extends StateNotifier<ProfessionalProfileModel> {
  PsychologistProfileCreationNotifier() : super(ProfessionalProfileModel());

  void updateField(ProfessionalProfileModel professionalProfile) {
    state = professionalProfile;
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
    // try {
    //   var updatedState = state.copyWith(updatedAt: DateTime.now());

    //   // Process image if exists
    //   if (updatedState.avatarPath!.isNotEmpty) {
    //     try {
    //       final base64Image = await processImage(updatedState.avatarPath!);
    //       if (base64Image != null) {
    //         updatedState = updatedState.copyWith(avatarData: base64Image);
    //       }
    //     } catch (e) {
    //       print('Image processing failed: $e');
    //       // Continue with profile creation even if image processing fails
    //     }
    //   }

    //   // Prepare data for Firestore
    //   final dataToSave = updatedState.toJson();

    //   if (dataToSave.toString().length > 900000) {
    //     // Leave room for metadata
    //     throw Exception('Profile data too large');
    //   }

    //   dataToSave.remove('avatarPath');

    //   // Save to Firestore
    //   await FirebaseFirestore.instance.collection('psychologist').doc(userId).set(dataToSave, SetOptions(merge: true));

    //   return true;
    // } catch (e) {
    //   print('Error submitting profile: $e');
    //   return false;
    // }
    return false; // Ensure a boolean is always returned
  }
}

final psychologistProfileFormProvider = StateNotifierProvider<PsychologistProfileCreationNotifier, ProfessionalProfileModel>(
  (ref) => PsychologistProfileCreationNotifier(),
);
