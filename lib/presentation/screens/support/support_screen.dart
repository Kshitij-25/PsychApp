import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SupportScreen extends HookConsumerWidget {
  static const routeName = '/supportScreen';

  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final passwordController = useTextEditingController();

    // final authNotifier = ref.watch(authStateNotifierProvider.notifier);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        forceMaterialTransparency: true,
        centerTitle: false,
        title: Text(
          'Support',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
      ),
      body: Column(
        children: [
          ListTile(
            leading: Icon(
              CupertinoIcons.delete_solid,
              color: Theme.of(context).colorScheme.error,
            ),
            title: Text('Delete Account'),
            onTap: () async {
              // Show confirmation dialog before signing out
              final shouldSignOut = await showDialog<bool>(
                context: context,
                barrierDismissible: false,
                builder: (context) => AlertDialog.adaptive(
                  title: Text('Delete Account'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Please confirm the password to delete the account'),
                      SizedBox(height: 10),
                      Platform.isIOS
                          ? CupertinoTextField(
                              controller: passwordController,
                              obscureText: true,
                              placeholder: 'Password',
                              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                              style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(8),
                              ),
                            )
                          : TextField(
                              controller: passwordController,
                              obscureText: true,
                              decoration: InputDecoration(
                                labelText: 'Password',
                                border: OutlineInputBorder(),
                              ),
                            ),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        passwordController.clear();
                        context.pop(false);
                      },
                      child: Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () => context.pop(true),
                      child: Text('Delete'),
                    ),
                  ],
                ),
              );

              // if (shouldSignOut == true) {
              //   // Sign out and wait for the user state to update
              //   await authNotifier.deleteFirebaseAccount(passwordController.text);

              //   ref.invalidate(authStateNotifierProvider);
              //   passwordController.clear();

              //   // Redirect to the landing screen only after user is null
              //   ref.listenManual(
              //     authStateNotifierProvider,
              //     (previous, next) {
              //       if (next.user == null) {
              //         context.pushReplacementNamed(LandingScreen.routeName);
              //       }
              //     },
              //   );
              // }
            },
          ),
        ],
      ),
    );
  }
}
