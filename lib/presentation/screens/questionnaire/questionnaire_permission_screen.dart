import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../shared/constants/assets.dart';
import '../../widgets/custom_elevated_button.dart';
import '../home/home_navigator.dart';
import 'initial_questions_screen.dart';

class QuestionnairePermissionScreen extends HookConsumerWidget {
  static const routeName = '/questionnairePermissionScreen';
  const QuestionnairePermissionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SvgPicture.asset(
                Assets.questionnaire,
                fit: BoxFit.contain,
                height: 250,
              ),
              SizedBox(height: 16),
              Text(
                "We will select speciallist\naccording to your request",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              SizedBox(height: 16),
              Text(
                'Fill out a questionnaire?',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context).hintColor,
                    ),
              ),
              Spacer(),
              _buildButtons(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButtons(BuildContext context) {
    return Column(
      children: [
        FractionallySizedBox(
          widthFactor: 0.83,
          child: CustomElevatedButton(
            buttonLabel: 'Fill out',
            onPressed: () {
              context.pushNamed(InitialQuestionsScreen.routeName);
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
        SizedBox(height: 8),
        FractionallySizedBox(
          widthFactor: 0.83,
          child: CustomElevatedButton(
            buttonLabel: 'Later',
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
