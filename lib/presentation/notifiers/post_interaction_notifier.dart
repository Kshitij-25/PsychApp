// Like/Unlike Provider
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../data/models/comment_model.dart';
import '../../shared/constants/firebase_helper.dart';

final postInteractionProvider = StateNotifierProvider.family<PostInteractionNotifier, AsyncValue<void>, String>((ref, postId) {
  return PostInteractionNotifier(postId);
});

final postCommentsProvider = StreamProvider.family<List<CommentModel>, String>((ref, postId) {
  return FirebaseFirestore.instance
      .collection('posts/$postId/comments')
      .orderBy('timestamp', descending: false)
      .snapshots()
      .map((snapshot) => snapshot.docs.map((doc) => CommentModel.fromFirestore(doc)).toList());
});

class PostInteractionNotifier extends StateNotifier<AsyncValue<void>> {
  final String postId;

  final _firstore = FirebaseFirestore.instance;

  PostInteractionNotifier(this.postId) : super(const AsyncData(null));

  Future<void> toggleLike() async {
    try {
      state = const AsyncValue.loading();
      final user = FirebaseHelper.currentUser!;
      final likeRef = _firstore.collection('posts/$postId/likes').doc(user.uid);

      final exists = (await likeRef.get()).exists;

      await _firstore.runTransaction((transaction) async {
        transaction.update(
          _firstore.collection('posts').doc(postId),
          {
            'likes': exists ? FieldValue.increment(-1) : FieldValue.increment(1),
          },
        );
        if (exists) {
          transaction.delete(likeRef);
        } else {
          transaction.set(
            likeRef,
            {
              'userId': user.uid,
              'timestamp': Timestamp.now(),
            },
          );
        }
      });

      state = const AsyncData(null);
    } catch (e, st) {
      print(e.toString());
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> addComment(String content) async {
    try {
      state = const AsyncValue.loading();
      final user = FirebaseHelper.currentUser!;
      final postRef = FirebaseFirestore.instance.collection('posts').doc(postId);
      final commentRef = postRef.collection('comments');

      await FirebaseFirestore.instance.runTransaction((transaction) async {
        // Add the comment
        transaction.set(commentRef.doc(), {
          'authorId': user.uid,
          'content': content,
          'timestamp': Timestamp.now(),
        });

        // Increment the comment count
        transaction.update(postRef, {
          'commentsCount': FieldValue.increment(1),
        });
      });

      state = const AsyncData(null);
    } catch (e, st) {
      print(e.toString());
      state = AsyncValue.error(e, st);
    }
  }
}
