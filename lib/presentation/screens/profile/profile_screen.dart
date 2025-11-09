import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../data/models/user_profile_data/user_profile_model.dart';
import '../../../shared/constants/hive_helper.dart';
import '../../providers/auth_providers.dart';
import '../auth/login_screen.dart';
import '../chat/inbox_screen.dart';
import '../mood/mood_navigator.dart';
import '../notifications/notification_screen.dart';
import '../support/support_screen.dart';
import '../welcome/landing_screen.dart';

class ProfileScreen extends HookConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProfile = useState<UserProfileModel?>(null);

    final authNotifier = ref.watch(authNotifierProvider.notifier);
    final authState = ref.watch(authNotifierProvider);

    Future<void> loadUserProfile() async {
      final profile = await HiveHelper.getUserData();
      userProfile.value = profile;
    }

    useEffect(
      () {
        loadUserProfile();
        return null;
      },
      [],
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 32),
          Row(
            crossAxisAlignment: userProfile.value != null
                ? CrossAxisAlignment.start
                : CrossAxisAlignment.center,
            children: [
              // Profile Picture
              GestureDetector(
                onTap: () {
                  if (userProfile.value != null) {
                    showDialog(
                      context: context,
                      builder: (context) => Dialog(
                        child: InteractiveViewer(
                          child: CachedNetworkImage(
                            imageUrl: userProfile.value?.profilePicUrl ?? '',
                            cacheKey: userProfile.value?.profilePicUrl,
                          ),
                        ),
                      ),
                    );
                  }
                },
                child: CircleAvatar(
                  radius: 40,
                  child: (userProfile.value?.profilePicUrl == null ||
                          userProfile.value?.profilePicUrl == '')
                      ? Icon(
                          CupertinoIcons.person_fill,
                          size: 30,
                        )
                      : null,
                  backgroundImage: (userProfile.value?.profilePicUrl != null &&
                          userProfile.value?.profilePicUrl != '')
                      ? CachedNetworkImageProvider(
                          userProfile.value!.profilePicUrl!,
                          cacheKey: userProfile.value!.profilePicUrl,
                        )
                      : null,
                ),
              ),
              SizedBox(width: 20),
              // User Info Column with Responsive Text
              if (userProfile.value?.fullName != null &&
                  userProfile.value?.fullName != '')
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          userProfile.value?.fullName ?? '',
                          textAlign: TextAlign.start,
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          userProfile.value?.email ?? '',
                          textAlign: TextAlign.start,
                          style:
                              Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    color: Theme.of(context).hintColor,
                                  ),
                        ),
                      ),
                    ],
                  ),
                ),
              // Guest Info Column with Responsive Text
              if (userProfile.value?.fullName == null ||
                  userProfile.value?.fullName == '')
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          'Guest User',
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          'Join us! Sign in to enjoy all features\nand a tailored experience.',
                          textAlign: TextAlign.left,
                          style:
                              Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    color: Theme.of(context).hintColor,
                                  ),
                        ),
                      ),
                    ],
                  ),
                ),
              if (userProfile.value?.fullName != null &&
                  userProfile.value?.fullName != '')
                Spacer(),
              // Edit Profile Button
              if (userProfile.value?.fullName != null &&
                  userProfile.value?.fullName != '')
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    FontAwesomeIcons.penToSquare,
                    color: Theme.of(context).colorScheme.primaryContainer,
                  ),
                ),
            ],
          ),
          SizedBox(height: 32),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  if (userProfile.value != null)
                    ListTile(
                      onTap: () => context.pushNamed(InboxScreen.routeName),
                      leading: Icon(CupertinoIcons.chat_bubble_fill),
                      title: Text('Chats'),
                      trailing: Icon(CupertinoIcons.chevron_forward),
                    ),
                  if (userProfile.value != null) Divider(thickness: 0.5),
                  ListTile(
                    onTap: () => context.pushNamed(MoodNavigator.routeName),
                    leading: Icon(CupertinoIcons.smiley_fill),
                    title: Text('Moods & Insights'),
                    trailing: Icon(CupertinoIcons.chevron_forward),
                  ),
                  Divider(thickness: 0.5),
                  if (userProfile.value != null)
                    ListTile(
                      leading: Icon(CupertinoIcons.heart_fill),
                      title: Text('Favourites'),
                      trailing: Icon(CupertinoIcons.chevron_forward),
                    ),
                  if (userProfile.value != null) Divider(thickness: 0.5),
                  if (userProfile.value != null)
                    ListTile(
                      onTap: () =>
                          context.pushNamed(NotificationScreen.routeName),
                      leading: Icon(CupertinoIcons.bell_fill),
                      title: Text('Notifications'),
                      trailing: Icon(CupertinoIcons.chevron_forward),
                    ),
                  if (userProfile.value != null) Divider(thickness: 0.5),
                  if (userProfile.value != null)
                    ListTile(
                      onTap: () => context.pushNamed(SupportScreen.routeName),
                      leading: Icon(CupertinoIcons.gear_solid),
                      title: Text('Support'),
                      trailing: Icon(CupertinoIcons.chevron_forward),
                    ),
                  if (userProfile.value != null) Divider(thickness: 0.5),
                  if (userProfile.value != null)
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
                          final response = await authNotifier.logoutUser();

                          if (response == true) {
                            context
                                .pushReplacementNamed(LandingScreen.routeName);
                          }
                        }
                      },
                    ),
                  if (userProfile.value == null)
                    ListTile(
                      leading: Icon(
                        CupertinoIcons.lock,
                        // color: Theme.of(context).colorScheme.error,
                      ),
                      title: Text('Login Now'),
                      trailing: Icon(CupertinoIcons.chevron_forward),
                      onTap: () {
                        context.replaceNamed(LoginScreen.routeName);
                      },
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
