import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  final String id;
  final String authorId;
  final String content;
  final DateTime timestamp;
  final int likes;
  final int commentsCount;
  final String? imageData;

  PostModel({
    required this.id,
    required this.authorId,
    required this.content,
    required this.timestamp,
    this.likes = 0,
    this.commentsCount = 0,
    this.imageData,
  });

  factory PostModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return PostModel(
      id: doc.id,
      authorId: data['authorId'],
      content: data['content'],
      timestamp: data['timestamp'].toDate(),
      likes: data['likes'] ?? 0,
      commentsCount: data['commentsCount'] ?? 0,
      imageData: data['imageData'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'authorId': authorId,
      'content': content,
      'timestamp': Timestamp.now(),
      'likes': likes,
      'commentsCount': commentsCount,
      'imageData': imageData,
    };
  }
}
