// Posts Stream Provider
import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../data/models/post_model.dart';

final postsProvider = StreamProvider<List<PostModel>>((ref) {
  return FirebaseFirestore.instance
      .collection('posts')
      .orderBy('timestamp', descending: true)
      .snapshots()
      .map((snapshot) => snapshot.docs.map((doc) => PostModel.fromFirestore(doc)).toList());
});

// Providers
final singlePostProvider = StreamProvider.family<PostModel, String>((ref, postId) {
  return FirebaseFirestore.instance.collection('posts').doc(postId).snapshots().map(
        (snapshot) => PostModel.fromFirestore(snapshot),
      );
});

// Post Creation Provider
final createPostProvider = StateNotifierProvider<PostNotifier, AsyncValue<void>>((ref) {
  return PostNotifier();
});

class PostNotifier extends StateNotifier<AsyncValue<void>> {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  PostNotifier({
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance,
        super(const AsyncData(null));

  Future<void> createPost({
    required String content,
    File? imageFile,
  }) async {
    try {
      state = const AsyncValue.loading();

      // Explicit null and authentication checks
      final user = _auth.currentUser;
      if (user == null) {
        throw FirebaseAuthException(code: 'not-authenticated', message: 'User must be logged in to create a post.');
      }

      // Image processing with more robust error handling
      String? imageData;
      if (imageFile != null) {
        try {
          imageData = await processImage(imageFile.path);
        } catch (e) {
          // Handle specific image processing errors
          state = AsyncValue.error(Exception('Failed to process image: ${e.toString()}'), StackTrace.current);
          return;
        }
      }

      // Firestore document creation
      await _firestore.collection('posts').add({
        'authorId': user.uid,
        'content': content.trim(),
        'timestamp': Timestamp.now(),
        'likes': 0,
        'commentsCount': 0,
        'imageData': imageData,
      });

      state = const AsyncData(null);
    } on FirebaseException catch (e) {
      // Specific Firebase error handling
      print('Firebase Error: ${e.code} - ${e.message}');
      state = AsyncValue.error(Exception('Firebase Error: ${e.message}'), StackTrace.current);
    } catch (e, stackTrace) {
      // Generic error handling
      print('Unexpected error: $e');
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<String?> processImage(String filePath) async {
    try {
      final file = File(filePath);

      // Image size and type validation
      final bytes = await file.readAsBytes();
      if (bytes.length > 1 * 1024 * 1024) {
        // 1MB limit
        throw Exception('Image must be smaller than 1MB');
      }

      // Convert to base64
      String base64Image = base64Encode(bytes);

      // Additional validation
      if (base64Image.length > 700000) {
        throw Exception('Processed image too large for Firestore');
      }

      return base64Image;
    } catch (e) {
      print('Image processing error: $e');
      rethrow;
    }
  }
}
