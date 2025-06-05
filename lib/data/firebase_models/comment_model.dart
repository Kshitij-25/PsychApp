import 'package:cloud_firestore/cloud_firestore.dart';

class CommentModel {
  final String id;
  final String authorId;
  final String content;
  final DateTime timestamp;

  CommentModel({
    required this.id,
    required this.authorId,
    required this.content,
    required this.timestamp,
  });

  factory CommentModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return CommentModel(
      id: doc.id,
      authorId: data['authorId'],
      content: data['content'],
      timestamp: data['timestamp'].toDate(),
    );
  }
}
