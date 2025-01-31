import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../data/models/chat_message.dart';
import '../../data/models/chat_room.dart';
import '../../shared/constants/firebase_helper.dart';

final chatProvider = StateNotifierProvider<ChatNotifier, AsyncValue<List<ChatMessage>>>((ref) {
  return ChatNotifier();
});

final chatStreamProvider = StreamProvider.family<List<ChatMessage>, String>((ref, chatRoomId) {
  return FirebaseFirestore.instance
      .collection('chatRooms/$chatRoomId/messages')
      .orderBy('timestamp', descending: false)
      .snapshots()
      .map((snapshot) => snapshot.docs.map((doc) => ChatMessage.fromJson(doc.data())).toList());
});

final chatRoomsProvider = StreamProvider<List<ChatRoom>>((ref) {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return const Stream.empty();

  return FirebaseFirestore.instance
      .collection('chatRooms')
      .where('participants', arrayContains: user.uid)
      .orderBy('lastMessageTimestamp', descending: true)
      .snapshots()
      .handleError((e) => print('Chat rooms error: $e'))
      .map((snapshot) => snapshot.docs
          .map((doc) => ChatRoom.fromJson({
                ...doc.data(),
                'id': doc.id, // Ensure chatRoomId is included
              }))
          .toList());
});

class ChatNotifier extends StateNotifier<AsyncValue<List<ChatMessage>>> {
  ChatNotifier() : super(const AsyncValue.loading());

  final _firestore = FirebaseFirestore.instance;

  Future<String> getOrCreateChatRoom({
    required String psychologistId,
    required String userId,
  }) async {
    final participants = [userId, psychologistId]..sort();

    if (participants.length != 2 || participants[0] == participants[1]) {
      throw Exception('Invalid participants for chat room');
    }
    final chatRoomId = participants.join('_');

    final chatRoomRef = _firestore.collection('chatRooms').doc(chatRoomId);

    try {
      final currentUser = FirebaseAuth.instance.currentUser!;
      if (!participants.contains(currentUser.uid)) {
        throw Exception('User not authorized to create this chat');
      }

      final batch = _firestore.batch();

      final psychologistDoc = await _firestore.collection('psychologist').doc(psychologistId).get();

      final userDoc = await _firestore.collection('users').doc(userId).get();

      batch.set(chatRoomRef, {
        "chatRoomId": chatRoomId,
        "participants": participants,
        "userId": userId,
        "psychologistId": psychologistId,
        "userFullName": userDoc['fullName'],
        "psychologistFullName": psychologistDoc['fullName'],
        "userAvatar": userDoc['avatarData'],
        "psychologistAvatar": psychologistDoc['avatarData'],
        "lastMessage": '',
        "lastMessageTimestamp": Timestamp.now(),
      });

      await batch.commit();
      return chatRoomId;
    } catch (e) {
      if (e is FirebaseException && e.code == 'permission-denied') {
        throw Exception('You are not allowed to create this chat room');
      }
      rethrow;
    }
  }

  Future<void> sendMessage({
    required String userId,
    required String psychologistId,
    required String message,
    required String userAvatar,
    required String userFullName,
    required String psychologistAvatar,
    required String psychologistFullName,
    required bool isPsychologist,
  }) async {
    try {
      final user = FirebaseAuth.instance.currentUser!;
      final participants = [userId, psychologistId]..sort();

      final chatRoomId = participants.join('_');

      final roomSnapshot = await FirebaseHelper.getDocument('chatRooms', chatRoomId);

      if (roomSnapshot?.exists == false) {
        await getOrCreateChatRoom(
          psychologistId: psychologistId,
          userId: userId,
        );
      }

      await _firestore.collection('chatRooms/$chatRoomId/messages').add({
        "senderId": user.uid,
        "message": message,
        "timestamp": Timestamp.now(),
      });

      await _firestore.collection('chatRooms').doc(chatRoomId).update({
        'lastMessage': message,
        'lastMessageTimestamp': Timestamp.now(),
      });
    } catch (e) {
      print('Error sending message: $e');
      rethrow;
    }
  }
}
