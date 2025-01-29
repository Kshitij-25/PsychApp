import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../shared/constants/firebase_helper.dart';
import '../../notifiers/chat_notifier.dart';
import 'chat_screen.dart';

class PsychologistInbox extends HookConsumerWidget {
  const PsychologistInbox({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: ref.watch(psychologistChatRoomsProvider(FirebaseHelper.currentUserId ?? '')).when(
            data: (rooms) {
              final psychologistRooms = rooms.where((room) {
                final currentUserId = FirebaseHelper.currentUserId;
                return room.psychologistId == currentUserId;
              }).toList();

              if (psychologistRooms.isEmpty) {
                return Center(
                  child: Text('No chats available.'),
                );
              }

              return ListView.separated(
                itemCount: psychologistRooms.length,
                separatorBuilder: (_, __) => Divider(thickness: 0.3),
                itemBuilder: (context, index) {
                  final room = psychologistRooms[index];
                  Uint8List? avatarBytes;
                  if (room.psychologistAvatar != null) {
                    avatarBytes = base64.decode(room.userAvatar!);
                  }

                  return ListTile(
                    contentPadding: EdgeInsets.only(left: 0),
                    leading: CircleAvatar(
                      radius: 30,
                      backgroundImage: avatarBytes != null ? MemoryImage(avatarBytes) : null,
                    ),
                    title: Text(room.userFullName ?? 'Unknown User'),
                    subtitle: Text(
                      room.lastMessage ?? 'No message',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: Text(
                      room.lastMessageTimestamp != null ? DateFormat.jm().format(room.lastMessageTimestamp as DateTime) : '',
                    ),
                    onTap: () async {
                      List<String> ids = [room.psychologistId ?? '', room.userId ?? ''];
                      ids.sort(); // Ensure consistent ordering
                      String chatRoomId = ids.join('_');

                      // Inside PsychologistHomeNav's onTap
                      context.pushNamed(
                        ChatScreen.routeName,
                        extra: {
                          'psychologistAvatar': room.psychologistAvatar,
                          'psychologistId': room.psychologistId,
                          // 'psychologistName': isPsychologist ? room.userFullName : room.psychologistFullName ?? 'Unknown Psychologist',
                          'psychologistName': room.userFullName,
                          'userId': room.userId, // CORRECT THIS LINE (was room.psychologistId)
                          'chatRoomId': chatRoomId,
                          'userAvatar': room.userAvatar,
                        },
                      );
                    },
                  );
                },
              );
            },
            loading: () => Center(
              child: CircularProgressIndicator(),
            ),
            error: (error, _) {
              print('Error loading chat rooms: $error');
              return Center(
                child: Text(
                  error.toString(),
                ),
              );
            },
          ),
    );
  }
}
