import 'dart:convert';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../shared/constants/firebase_helper.dart';
import '../../notifiers/auth_notifier.dart';
import '../chat/inbox_screen.dart';
import '../mood/mood_navigator.dart';
import '../notifications/notification_screen.dart';
import '../support/support_screen.dart';
import '../welcome/landing_screen.dart';

class ProfileScreen extends HookConsumerWidget {
  const ProfileScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authNotifier = ref.watch(authStateNotifierProvider.notifier);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 32),
          FutureBuilder<DocumentSnapshot?>(
            future: FirebaseHelper.getUserDocument(FirebaseHelper.currentUserId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return const Center(child: Text('Error fetching user data.'));
              }

              if (!snapshot.hasData || !snapshot.data!.exists) {
                return const Center(child: Text('User document not found.'));
              }

              // Extract user data
              final userData = snapshot.data!.data() as Map<String, dynamic>?;
              if (userData == null) return const SizedBox.shrink();

              Uint8List? avatarBytes;

              // Handle avatarData based on storage format
              if (userData['avatarData'] != null) {
                if (userData['avatarData'] is String) {
                  // If stored as a base64-encoded string
                  avatarBytes = base64.decode(userData['avatarData'] as String);
                } else if (userData['avatarData'] is List<dynamic>) {
                  // If stored as a list of integers
                  avatarBytes = Uint8List.fromList(List<int>.from(userData['avatarData']));
                }
              }

              final fullName = userData['fullName'] ?? 'Unknown User';

              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      if (avatarBytes != null) {
                        showDialog(
                          context: context,
                          builder: (context) => Dialog(
                            child: InteractiveViewer(
                              child: Image.memory(
                                avatarBytes!,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        );
                      }
                    },
                    child: CircleAvatar(
                      radius: 40,
                      child: avatarBytes == null ? Icon(CupertinoIcons.person, size: 20) : null,
                      backgroundImage: avatarBytes != null ? MemoryImage(avatarBytes) : null,
                    ),
                  ),
                  SizedBox(width: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        fullName,
                        textAlign: TextAlign.start,
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      Text(
                        FirebaseHelper.currentUser?.email ?? '',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Theme.of(context).hintColor,
                            ),
                      ),
                    ],
                  ),
                  Spacer(),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      FontAwesomeIcons.penToSquare,
                      color: Theme.of(context).colorScheme.primaryContainer,
                    ),
                  ),
                ],
              );
            },
          ),
          SizedBox(height: 32),
          ListTile(
            onTap: () => context.pushNamed(InboxScreen.routeName),
            leading: Icon(CupertinoIcons.chat_bubble_fill),
            title: Text('Chats'),
            trailing: Icon(CupertinoIcons.chevron_forward),
          ),
          Divider(thickness: 0.5),
          ListTile(
            onTap: () => context.pushNamed(MoodNavigator.routeName),
            leading: Icon(CupertinoIcons.smiley_fill),
            title: Text('Moods & Insights'),
            trailing: Icon(CupertinoIcons.chevron_forward),
          ),
          Divider(thickness: 0.5),
          ListTile(
            leading: Icon(CupertinoIcons.heart_fill),
            title: Text('Favourites'),
            trailing: Icon(CupertinoIcons.chevron_forward),
          ),
          Divider(thickness: 0.5),
          ListTile(
            onTap: () => context.pushNamed(NotificationScreen.routeName),
            leading: Icon(CupertinoIcons.bell_fill),
            title: Text('Notifications'),
            trailing: Icon(CupertinoIcons.chevron_forward),
          ),
          Divider(thickness: 0.5),
          ListTile(
            onTap: () => context.pushNamed(SupportScreen.routeName),
            leading: Icon(CupertinoIcons.gear_solid),
            title: Text('Support'),
            trailing: Icon(CupertinoIcons.chevron_forward),
          ),
          Divider(thickness: 0.5),
          ListTile(
            leading: RotatedBox(
              quarterTurns: -1,
              child: Icon(
                CupertinoIcons.share,
                color: Theme.of(context).colorScheme.error,
              ),
            ),
            title: Text('Sign out'),
            trailing: Icon(CupertinoIcons.chevron_forward),
            onTap: () async {
              // Show confirmation dialog before signing out
              final shouldSignOut = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog.adaptive(
                  title: Text('Sign Out'),
                  content: Text('Are you sure you want to sign out?'),
                  actions: [
                    TextButton(
                      onPressed: () => context.pop(false),
                      child: Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () => context.pop(true),
                      child: Text('Sign Out'),
                    ),
                  ],
                ),
              );

              if (shouldSignOut == true) {
                // Sign out and wait for the user state to update
                await authNotifier.signOut();

                ref.invalidate(authStateNotifierProvider);

                // Redirect to the landing screen only after user is null
                ref.listenManual(
                  authStateNotifierProvider,
                  (previous, next) {
                    if (next.user == null) {
                      context.pushReplacementNamed(LandingScreen.routeName);
                    }
                  },
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
