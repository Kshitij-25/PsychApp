import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../shared/constants/firebase_helper.dart';
import '../../notifiers/chat_notifier.dart';

class ChatScreen extends HookConsumerWidget {
  static const routeName = '/chatScreen';
  const ChatScreen({
    required this.psychologistId,
    required this.psychologistName,
    required this.psychologistAvatar,
    required this.userAvatar,
    required this.userId,
    required this.chatRoomId,
    Key? key,
  }) : super(key: key);

  final String? psychologistId;
  final String? psychologistName;
  final String? psychologistAvatar;
  final String? userAvatar;
  final String userId;
  final String chatRoomId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chatNotifier = ref.read(chatProvider.notifier);
    final messageController = useTextEditingController();

    print('ChatRoomId: $chatRoomId'); // Add in ChatScreen

    final chatMessages = ref.watch(chatStreamProvider(chatRoomId));

    bool isToday(DateTime date) {
      final now = DateTime.now();
      return date.year == now.year && date.month == now.month && date.day == now.day;
    }

    bool isYesterday(DateTime date) {
      final now = DateTime.now().subtract(Duration(days: 1));
      return date.year == now.year && date.month == now.month && date.day == now.day;
    }

    bool isSameWeek(DateTime date) {
      final now = DateTime.now();
      final difference = now.difference(date).inDays;
      return difference < 7 && date.isAfter(now.subtract(Duration(days: now.weekday)));
    }

    bool isSameDay(DateTime date1, DateTime date2) {
      return date1.year == date2.year && date1.month == date2.month && date1.day == date2.day;
    }

    final currentUserId = FirebaseHelper.currentUserId;
    final isPsychologist = currentUserId == psychologistId;
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: Colors.transparent,
        forceMaterialTransparency: true,
        title: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundImage: MemoryImage(base64.decode(isPsychologist ? userAvatar! : psychologistAvatar!)),
            ),
            SizedBox(width: 10),
            Text(
              psychologistName ?? '',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: chatMessages.when(
                data: (messages) {
                  return ListView.builder(
                    reverse: true,
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      // final message = messages[index];
                      final currentMessage = messages.reversed.toList()[index];
                      final previousMessage = index < messages.length - 1 ? messages.reversed.toList()[index + 1] : null;

                      DateTime currentMessageDate;
                      try {
                        currentMessageDate = currentMessage.timestamp != null
                            ? DateFormat('MM/dd/yyyy').parse(DateFormat('MM/dd/yyyy').format(currentMessage.timestamp!))
                            : DateTime.now();
                      } catch (e) {
                        return SizedBox();
                      }

                      // Determine if this is the first message of the day
                      bool isFirstMessageOfDay = index == messages.length - 1 ||
                          (previousMessage != null && previousMessage.timestamp != null && previousMessage.timestamp!.isBefore(currentMessageDate));
                      String headerText = '';
                      if (isToday(currentMessageDate)) {
                        headerText = 'Today';
                      } else if (isYesterday(currentMessageDate)) {
                        headerText = 'Yesterday';
                      } else if (isSameWeek(currentMessageDate)) {
                        headerText = DateFormat('EEEE').format(currentMessageDate);
                      } else {
                        headerText = DateFormat('MM/dd/yyyy').format(currentMessageDate);
                      }
                      // // Add these debug prints
                      // print('isMe Message: ${currentMessage.message}');
                      // print('isMe Sender ID: ${currentMessage.senderId}');
                      // print('isMe Current User ID: ${FirebaseHelper.currentUserId}');
                      // print('isMe Psychologist ID: $psychologistId');

                      // Modify the isMe check
                      final isMe = currentMessage.senderId == FirebaseHelper.currentUserId;

                      return Column(
                        children: [
                          if (isFirstMessageOfDay)
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10.0),
                              child: Center(
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).colorScheme.secondary,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    headerText,
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).colorScheme.onSecondary,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          Align(
                            alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                            child: Container(
                              margin: const EdgeInsets.all(8),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: isMe ? Theme.of(context).colorScheme.primaryContainer : Theme.of(context).colorScheme.tertiaryContainer,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Theme.of(context).shadowColor,
                                    blurRadius: 5,
                                    spreadRadius: .2,
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min, // Prevents taking full width
                                children: [
                                  Flexible(
                                    flex: 4, // 4 parts of the total 5
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          currentMessage.message ?? '',
                                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                                color: isMe
                                                    ? Theme.of(context).colorScheme.onPrimaryContainer
                                                    : Theme.of(context).colorScheme.onTertiaryContainer,
                                              ),
                                          maxLines: null, // Allow the text to use as many lines as needed
                                          softWrap: true, // This ensures the text will wrap to the next line
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Flexible(
                                    flex: 1, // 1 part of the total 5 (takes the remaining space)
                                    child: Text(
                                      DateFormat('HH:mm').format(currentMessage.timestamp ?? DateTime.now()),
                                      textAlign: TextAlign.end,
                                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                            fontSize: 10,
                                            color: isMe
                                                ? Theme.of(context).colorScheme.onPrimaryContainer
                                                : Theme.of(context).colorScheme.onTertiaryContainer,
                                          ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
                loading: () => Center(
                  child: CircularProgressIndicator(),
                ),
                error: (error, stackTrace) => Center(
                  child: Text('Error: ${error.toString()}'),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      maxLines: 5,
                      minLines: 1,
                      controller: messageController,
                      decoration: const InputDecoration(
                        hintText: 'Type a message....',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                          Radius.circular(8),
                        )),
                      ),
                      onTapOutside: (event) => FocusScope.of(context).unfocus(),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      CupertinoIcons.arrow_up_circle,
                      size: 35,
                    ),
                    onPressed: () async {
                      String messageText = messageController.text.trim();
                      if (messageText.isNotEmpty) {
                        final currentUserId = FirebaseHelper.currentUserId;
                        final senderDoc = await FirebaseHelper.getUserDocument(currentUserId);

                        if (senderDoc != null && senderDoc.exists) {
                          String receiverId = '';
                          String receiverName = '';
                          String receiverAvatar = '';

                          final isUser = senderDoc['uid'] == currentUserId;
                          final isPsychologist = await FirebaseHelper.getUserRole(currentUserId) == 'psychologist';

                          if (isUser && isPsychologist) {
                            // If both isUser and isPsychologist are true, send psychologist's details
                            receiverId = userId;
                            receiverName = psychologistName!;
                            receiverAvatar = psychologistAvatar!;
                          } else {
                            // Otherwise, send sender's details
                            receiverId = psychologistId!;
                            receiverName = psychologistName!;
                            receiverAvatar = psychologistAvatar!;
                          }

                          await chatNotifier.sendMessage(
                              userId: currentUserId!,
                              psychologistId: receiverId,
                              message: messageText,
                              userAvatar: senderDoc["avatarData"],
                              userFullName: senderDoc["fullName"],
                              psychologistAvatar: receiverAvatar,
                              psychologistFullName: receiverName,
                              isPsychologist: isPsychologist);

                          messageController.clear();
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Unable to fetch sender information')),
                          );
                        }
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
