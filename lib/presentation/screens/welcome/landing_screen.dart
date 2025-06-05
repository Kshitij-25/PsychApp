import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:psych_app/presentation/widgets/custom_elevated_button.dart';

import '../../../shared/constants/assets.dart';
import '../auth/login_screen.dart';
import '../home/home_navigator.dart';

// providers/psychologist_mode_provider.dart
final psychologistModeProvider = StateProvider<bool>((ref) => false);

class LandingScreen extends HookConsumerWidget {
  static const routeName = '/landingScreen';

  LandingScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isExtended = useState(true);
    final isPsychologistMode = ref.watch(psychologistModeProvider);

    // Initialize the extended state to shrink after 5 seconds.
    useEffect(() {
      final timer = Timer(const Duration(seconds: 5), () {
        isExtended.value = false;
      });
      return timer.cancel; // Clean up the timer when the widget is disposed.
    }, []);

    Future<void> showPsychologistDialog(BuildContext context) async {
      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog.adaptive(
            title: isPsychologistMode ? const Text('User Mode') : const Text('Psychologist Mode'),
            content: isPsychologistMode
                ? const Text('Would you like to switch back to User Mode?')
                : const Text('Would you like to enable Psychologist Mode?'),
            actions: [
              TextButton(
                style: TextButton.styleFrom(
                  splashFactory: NoSplash.splashFactory,
                  overlayColor: Colors.transparent,
                ),
                onPressed: () {
                  ref.read(psychologistModeProvider.notifier).state = isPsychologistMode ? true : false;
                  context.pop();
                  isExtended.value = false;
                },
                child: const Text('Cancel'),
              ),
              TextButton(
                style: TextButton.styleFrom(
                  splashFactory: NoSplash.splashFactory,
                  overlayColor: Colors.transparent,
                ),
                onPressed: () {
                  ref.read(psychologistModeProvider.notifier).state = isPsychologistMode ? false : true;
                  context.pop();
                  Future.delayed(Duration(seconds: 3), () {
                    isExtended.value = false;
                  });
                },
                child: isPsychologistMode ? const Text('Yes') : const Text('Enable'),
              ),
            ],
          );
        },
      );
    }

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Spacer(),
              Expanded(
                flex: 7,
                child: _buildHeaderTextAndLogo(context),
              ),
              Spacer(),
              _buildButtons(context, ref),
              Spacer(flex: 2),
              // _buildDividerWithText(context),
              // SizedBox(height: 20),
              // _buildOtherSignInOptions(context),
              // Spacer(),
            ],
          ),
        ),
      ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
      // floatingActionButton: AnimatedSwitcher(
      //   switchInCurve: Curves.easeInSine,
      //   switchOutCurve: Curves.easeOutSine,
      //   duration: const Duration(milliseconds: 200),
      //   transitionBuilder: (Widget child, Animation<double> animation) {
      //     return ScaleTransition(scale: animation, child: child);
      //   },
      //   child: isExtended.value
      //       ? FloatingActionButton.extended(
      //           key: const ValueKey('extended'),
      //           enableFeedback: true,
      //           label: isPsychologistMode ? const Text('User Mode') : const Text('Psychologist Mode'),
      //           icon: isPsychologistMode ? Icon(CupertinoIcons.person_fill) : const Icon(FontAwesomeIcons.brain),
      //           onPressed: () => showPsychologistDialog(context),
      //         )
      //       : FloatingActionButton.small(
      //           key: const ValueKey('icon'),
      //           enableFeedback: true,
      //           child: isPsychologistMode
      //               ? Icon(
      //                   CupertinoIcons.person_fill,
      //                   size: 20,
      //                 )
      //               : const Icon(
      //                   FontAwesomeIcons.brain,
      //                   size: 15,
      //                 ),
      //           onPressed: () {
      //             isExtended.value = true;
      //             showPsychologistDialog(context);
      //           },
      //         ),
      // ),
    );
  }

  Widget _buildHeaderTextAndLogo(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          child: SvgPicture.asset(
            Assets.splashLogo,
            fit: BoxFit.contain,
          ),
        ),
        Text(
          'MindNest',
          style: Theme.of(context).textTheme.displayMedium?.copyWith(
                color: Theme.of(context).colorScheme.primaryContainer,
              ),
        ),
        // Text(
        //   'Health',
        //   style: Theme.of(context).textTheme.headlineSmall?.copyWith(
        //         color: Theme.of(context).colorScheme.primaryContainer,
        //       ),
        // ),
        // SizedBox(height: 20),
        // Text(
        //   'Start Psychotherapy today',
        //   textAlign: TextAlign.center,
        //   style: Theme.of(context).textTheme.headlineMedium?.copyWith(
        //         fontWeight: FontWeight.bold,
        //       ),
        // ),
        SizedBox(height: 20),
        Text(
          'A safe space for your mental well-being',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).hintColor,
              ),
        ),
      ],
    );
  }

  Widget _buildButtons(BuildContext context, WidgetRef ref) {
    final isPsychologistMode = ref.watch(psychologistModeProvider);
    return Column(
      children: [
        FractionallySizedBox(
          widthFactor: 0.83,
          child: CustomElevatedButton(
            // buttonLabel: isPsychologistMode ? 'Login as a Psychologist ' : 'Login',
            buttonLabel: 'Get Started',
            onPressed: () {
              context.pushNamed(LoginScreen.routeName);
            },
            buttonStyle: ElevatedButton.styleFrom(
              enableFeedback: true,
              backgroundColor: Theme.of(context).buttonTheme.colorScheme!.primaryContainer,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
        // SizedBox(height: 20),
        // FractionallySizedBox(
        //   widthFactor: 0.83,
        //   child: CustomElevatedButton(
        //     buttonLabel: isPsychologistMode ? 'Register as a Psychologist' : 'Register',
        //     onPressed: () {
        //       context.pushNamed(EmailVerificationScreen.routeName);
        //     },
        //     buttonStyle: ElevatedButton.styleFrom(
        //       enableFeedback: true,
        //       // overlayColor: Colors.transparent,
        //       elevation: 0,
        //       backgroundColor: Theme.of(context).buttonTheme.colorScheme!.primaryContainer,
        //       // backgroundColor: Theme.of(context).buttonTheme.colorScheme!.surface,
        //       shape: RoundedRectangleBorder(
        //         borderRadius: BorderRadius.circular(8),
        //       ),
        //     ),
        //     // textStyle: Theme.of(context).textTheme.labelLarge?.copyWith(
        //     //       // color: Theme.of(context).hintColor,
        //     //     ),
        //   ),
        // ),
        SizedBox(height: 20),
        FractionallySizedBox(
          widthFactor: 0.83,
          child: CustomElevatedButton(
            buttonLabel: 'Explore as Guest',
            onPressed: () {
              context.go(HomeNavigator.routeName);
            },
            buttonStyle: ElevatedButton.styleFrom(
              enableFeedback: true,
              overlayColor: Colors.transparent,
              elevation: 0,
              backgroundColor: Theme.of(context).buttonTheme.colorScheme!.surface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            textStyle: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: Theme.of(context).hintColor,
                ),
          ),
        ),
      ],
    );
  }
}
