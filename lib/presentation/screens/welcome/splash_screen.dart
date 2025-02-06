import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../shared/constants/assets.dart';
import 'onboarding_screen.dart';

class SplashScreen extends HookConsumerWidget {
  static const routeName = '/splashScreen';
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useEffect(() {
      Future.delayed(const Duration(seconds: 3), () {
        context.go(OnboardingScreen.routeName);
      });
      return null;
    }, []);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              Assets.splashLogo,
              fit: BoxFit.contain,
              height: 250,
            ),
            // Image.asset(
            //   'assets/logos/Psych-App.png',
            //   height: 300,
            // ),
            Text(
              'MindNest',
              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
            ),
            // Text(
            //   'Health',
            //   style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            //         color: Theme.of(context).colorScheme.onPrimaryContainer,
            //       ),
            // ),
          ],
        ),
      ),
    );
  }
}
