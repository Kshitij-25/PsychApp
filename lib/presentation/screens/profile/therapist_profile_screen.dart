import 'dart:convert';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:psych_app/presentation/widgets/custom_elevated_button.dart';

import '../../../data/models/psychologist_model.dart';
import '../../../shared/constants/firebase_helper.dart';
import '../../notifiers/chat_notifier.dart';
import '../appointment/book_appointment_screen.dart';
import '../chat/chat_screen.dart';

class TherapistProfileScreen extends HookConsumerWidget {
  static const routeName = '/therapistProfileScreen';
  const TherapistProfileScreen({
    super.key,
    required this.psychologistsData,
  });

  final PsychologistModel psychologistsData;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Uint8List? avatarBytes;

    // Handle avatarData based on storage format
    if (psychologistsData.avatarData != null) {
      if (psychologistsData.avatarData is String) {
        // If stored as a base64-encoded string
        avatarBytes = base64.decode(psychologistsData.avatarData as String);
      } else if (psychologistsData.avatarData is List<dynamic>) {
        // If stored as a list of integers
        avatarBytes = Uint8List.fromList(List<int>.from(psychologistsData.avatarData as List<dynamic>));
      }
    }

    final chatNotifier = ref.read(chatProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        forceMaterialTransparency: true,
        actions: [
          IconButton.filled(
            onPressed: () {},
            icon: Icon(
              CupertinoIcons.heart,
              color: Theme.of(context).colorScheme.primaryContainer,
            ),
            style: IconButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primaryFixed,
            ),
          ),
          SizedBox(width: 15)
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CircleAvatar(
                  radius: 64,
                  child: avatarBytes == null
                      ? Icon(CupertinoIcons.person, size: 20)
                      : ClipOval(
                          child: Image.memory(
                            avatarBytes,
                            fit: BoxFit.cover,
                            width: 128,
                            height: 128,
                          ),
                        ),
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 5,
                  children: [
                    if (psychologistsData.ratings != null)
                      Icon(
                        CupertinoIcons.star_fill,
                        size: 13,
                        color: Colors.amber,
                      ),
                    if (psychologistsData.ratings != null)
                      Text(
                        '${psychologistsData.ratings.toString()}/5',
                        style: Theme.of(context).textTheme.labelMedium?.copyWith(
                              color: Theme.of(context).colorScheme.onSurface,
                              fontWeight: FontWeight.bold,
                            ),
                        textAlign: TextAlign.center,
                      ),
                    if (psychologistsData.reviews != null)
                      Text(
                        '(${psychologistsData.reviews.toString()})',
                        style: Theme.of(context).textTheme.labelMedium?.copyWith(
                              color: Theme.of(context).colorScheme.outline,
                            ),
                        textAlign: TextAlign.center,
                      ),
                  ],
                ),
                SizedBox(height: 16),
                Text(
                  psychologistsData.fullName ?? '',
                  style: Theme.of(context).textTheme.headlineMedium,
                  textAlign: TextAlign.center,
                ),
                Text(
                  psychologistsData.qualification ?? '',
                  style: Theme.of(context).textTheme.bodySmall,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16),
                Wrap(
                  spacing: 5,
                  alignment: WrapAlignment.center,
                  children: psychologistsData.expertise!
                      .map(
                        (expertise) => Chip(
                          visualDensity: VisualDensity.compact,
                          backgroundColor: Theme.of(context).colorScheme.primaryFixed,
                          elevation: 0,
                          side: BorderSide(style: BorderStyle.none),
                          labelStyle: TextStyle(
                            color: Theme.of(context).colorScheme.primaryContainer,
                          ),
                          label: Text(
                            expertise.replaceAll('_', ' ').split(' ').map((word) {
                              return word[0].toUpperCase() + word.substring(1).toLowerCase();
                            }).join(' '),
                          ),
                        ),
                      )
                      .toList(),
                ),
                SizedBox(height: 16),
                Text(
                  'About the specialist',
                  style: Theme.of(context).textTheme.titleLarge,
                  textAlign: TextAlign.start,
                ),
                SizedBox(height: 8),
                Text(
                  psychologistsData.about ?? '',
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.start,
                ),
                SizedBox(height: 16),
                Row(
                  spacing: 5,
                  children: [
                    Text(
                      'Publications',
                      style: Theme.of(context).textTheme.titleLarge,
                      textAlign: TextAlign.start,
                    ),
                    if (psychologistsData.ratings != null)
                      Text(
                        '(${psychologistsData.publications?.length})',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: Theme.of(context).colorScheme.outline,
                            ),
                        textAlign: TextAlign.start,
                      ),
                  ],
                ),
                SizedBox(height: 8),
                psychologistsData.publicationsLinks != null && psychologistsData.publicationsLinks?.length != 0
                    ? SizedBox(
                        height: 240,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: psychologistsData.publicationsLinks?.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 10.0),
                              child: Stack(
                                children: [
                                  Container(
                                    height: 200,
                                    width: 320,
                                    child: CachedNetworkImage(
                                      fit: BoxFit.fill,
                                      imageUrl: psychologistsData.publicationsLinks![index],
                                      cacheKey: psychologistsData.publicationsLinks![index],
                                      memCacheHeight: 1080,
                                      memCacheWidth: 1920,
                                      filterQuality: FilterQuality.high,
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Container(
                                      width: 320,
                                      color: Theme.of(context).colorScheme.secondary,
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        psychologistsData.publications![index],
                                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                              color: Theme.of(context).colorScheme.onSecondary,
                                            ),
                                        textAlign: TextAlign.center,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      )
                    : SizedBox(
                        height: 200,
                        child: Center(
                          child: Text('No Publications listed'),
                        ),
                      ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: CustomElevatedButton(
                        onPressed: () {
                          context.pushNamed(
                            BookAppointmentScreen.routeName,
                            extra: psychologistsData,
                          );
                        },
                        buttonLabel: 'Book an Appointment',
                        buttonStyle: ElevatedButton.styleFrom(
                          enableFeedback: true,
                          backgroundColor: Theme.of(context).buttonTheme.colorScheme!.primaryContainer,
                          foregroundColor: Theme.of(context).buttonTheme.colorScheme!.onPrimaryContainer,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 16),
                    IconButton.filled(
                      onPressed: () async {
                        try {
                          final chatNotifier = ref.read(chatProvider.notifier);
                          List<String> ids = [FirebaseHelper.currentUserId!, psychologistsData.uid!];
                          ids.sort();
                          String chatRoomId = ids.join('_');

                          // Check if already exists without triggering permission error
                          final roomSnapshot = await FirebaseHelper.getDocument('chatRooms', chatRoomId);

                          if (roomSnapshot == null || roomSnapshot.exists == false) {
                            // Create if not exists
                            await chatNotifier.getOrCreateChatRoom(
                              psychologistId: psychologistsData.uid!,
                              userId: FirebaseHelper.currentUserId!,
                            );
                          }

                          context.pushNamed(
                            ChatScreen.routeName,
                            extra: {
                              'psychologistAvatar': psychologistsData.avatarData,
                              'psychologistId': psychologistsData.uid,
                              'psychologistName': psychologistsData.fullName,
                              'userId': FirebaseHelper.currentUserId,
                              'chatRoomId': chatRoomId,
                            },
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Error starting chat: $e')),
                          );
                        }
                      },
                      icon: Icon(
                        CupertinoIcons.chat_bubble_text_fill,
                        color: Theme.of(context).colorScheme.primaryContainer,
                      ),
                      style: IconButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primaryFixed,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
