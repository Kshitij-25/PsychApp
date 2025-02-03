import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../shared/constants/assets.dart';
import '../../widgets/custom_elevated_button.dart';
import 'landing_screen.dart';

// State provider to manage the current onboarding page index
final onboardingPageProvider = StateProvider<int>((ref) => 0);

class OnboardingScreen extends HookConsumerWidget {
  static const routeName = '/onboardingScreen';
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pageController = usePageController();
    final currentIndex = ref.watch(onboardingPageProvider);

    final List<OnboardingContent> onboardingData = [
      OnboardingContent(
        image: Assets.videoConsultation,
        title: 'Video consultations with\npsychologists',
      ),
      OnboardingContent(
        image: Assets.moodTracking,
        title: 'Tracking mood and emotional\nstate',
      ),
      OnboardingContent(
        image: Assets.qualifiedTherapist,
        title: 'Selection of a qualified\npsychologist',
      ),
      OnboardingContent(
        image: Assets.qualityLife,
        title: 'Improving the quality of life\nand self-perception',
      ),
    ];

    void onNext() {
      if (currentIndex < onboardingData.length - 1) {
        pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeIn,
        );
      } else {
        finishOnboarding(context);
      }
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        forceMaterialTransparency: true,
        elevation: 0,
        actions: [
          if (currentIndex < onboardingData.length - 1)
            TextButton(
              onPressed: () => finishOnboarding(context),
              child: Text(
                'Skip',
                style: TextStyle(
                  color: Theme.of(context).hintColor,
                ),
              ),
            ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Onboarding content
            Expanded(
              flex: 4,
              child: PageView.builder(
                controller: pageController,
                onPageChanged: (index) => ref.read(onboardingPageProvider.notifier).state = index,
                itemCount: onboardingData.length,
                itemBuilder: (context, index) {
                  final content = onboardingData[index];
                  return OnboardingPage(content: content);
                },
              ),
            ),
            // Next button
            Expanded(
              flex: 0,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: FractionallySizedBox(
                  widthFactor: 0.75,
                  child: CustomElevatedButton(
                    onPressed: onNext,
                    buttonStyle: ElevatedButton.styleFrom(
                      enableFeedback: true,
                      backgroundColor: Theme.of(context).buttonTheme.colorScheme!.primaryContainer,
                      foregroundColor: Theme.of(context).buttonTheme.colorScheme!.onPrimaryContainer,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    buttonLabel: currentIndex == onboardingData.length - 1 ? 'Finish' : 'Next',
                  ),
                ),
              ),
            ),
            // Dots indicator
            Expanded(
              flex: 1,
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    onboardingData.length,
                    (index) => AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.only(right: 8.0),
                      height: 8.0,
                      width: currentIndex == index ? 24.0 : 8.0,
                      decoration: BoxDecoration(
                        color: currentIndex == index ? Colors.blue : Colors.grey,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void finishOnboarding(BuildContext context) {
    context.go(LandingScreen.routeName);
  }
}

class OnboardingContent {
  final String image;
  final String title;

  OnboardingContent({required this.image, required this.title});
}

class OnboardingPage extends StatelessWidget {
  final OnboardingContent content;

  const OnboardingPage({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Image area
        Expanded(
          flex: 3,
          child: SvgPicture.asset(content.image), // Replace with actual images
        ),
        // Title area
        Expanded(
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                content.title,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
