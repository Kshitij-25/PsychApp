import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../notifiers/auth_notifier.dart';
import '../welcome/landing_screen.dart';

class PsychologistHomeNav extends HookConsumerWidget {
  static const routeName = '/psychologistHomeNav';

  const PsychologistHomeNav({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authNotifier = ref.watch(authStateNotifierProvider.notifier);

    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: TextButton(
          onPressed: () async {
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
          child: Text('data'),
        ),
      ),
    );
  }
}
