import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../notifiers/auth_notifier.dart';
import '../chat/psychologist_inbox.dart';
import '../community/community_home.dart';
import '../community/community_post_screen.dart';
import '../profile/psychologist_profile_panel.dart';
import '../welcome/landing_screen.dart';

class PsychologistHomeNav extends HookConsumerWidget {
  static const routeName = '/psychologistHomeNav';

  const PsychologistHomeNav({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = useState(0);
    final _pageController = usePageController(initialPage: currentIndex.value);

    final authNotifier = ref.watch(authStateNotifierProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        forceMaterialTransparency: true,
        centerTitle: false,
        title: currentIndex.value == 0
            ? Text(
                'Feeds',
                textAlign: TextAlign.start,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              )
            : currentIndex.value == 1
                ? Text(
                    'User Chats',
                    textAlign: TextAlign.start,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  )
                : Text(
                    'Profile',
                    textAlign: TextAlign.start,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
        actions: [
          if (currentIndex.value == 2)
            TextButton(
              onPressed: () => _handleLogout(context, ref, authNotifier),
              child: Text('Logout'),
            ),
        ],
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          currentIndex.value = index;
        },
        physics: const NeverScrollableScrollPhysics(),
        children: [
          CommunityHome(),
          PsychologistInbox(),
          PsychologistProfilePanel(),
        ],
      ),
      bottomNavigationBar: _buildBottomNavBar(context, currentIndex, _pageController),
      floatingActionButton: currentIndex.value == 0
          ? FloatingActionButton(
              child: Icon(CupertinoIcons.plus),
              onPressed: () {
                context.pushNamed(CommunityPostScreen.routeName);
              },
            )
          : null,
    );
  }

  Widget _buildBottomNavBar(
    BuildContext context,
    ValueNotifier<int> currentIndex,
    PageController _pageController,
  ) {
    return BottomNavigationBar(
      currentIndex: currentIndex.value,
      enableFeedback: true,
      type: BottomNavigationBarType.fixed,
      selectedIconTheme: IconThemeData(color: Theme.of(context).colorScheme.primaryContainer),
      selectedLabelStyle: Theme.of(context).bottomNavigationBarTheme.selectedLabelStyle,
      unselectedLabelStyle: Theme.of(context).bottomNavigationBarTheme.unselectedLabelStyle,
      unselectedIconTheme: Theme.of(context).bottomNavigationBarTheme.unselectedIconTheme,
      elevation: 0,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      onTap: (index) {
        _pageController.jumpToPage(index);
        currentIndex.value = index;
      },
      items: [
        BottomNavigationBarItem(
          icon: Icon(FontAwesomeIcons.newspaper),
          label: 'Feeds',
        ),
        BottomNavigationBarItem(
          icon: Icon(CupertinoIcons.chat_bubble_text_fill),
          label: 'Chats',
        ),
        BottomNavigationBarItem(
          icon: Icon(CupertinoIcons.person_fill),
          label: 'Profile',
        ),
      ],
    );
  }

  void _handleLogout(
    BuildContext context,
    WidgetRef ref,
    AuthStateNotifier authNotifier,
  ) async {
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
  }
}
