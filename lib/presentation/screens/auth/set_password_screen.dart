import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:psych_app/presentation/screens/profile_creation/profile_creation_questions.dart';

import '../../widgets/custom_elevated_button.dart';
import '../questionnaire/questionnaire_permission_screen.dart';
import '../welcome/landing_screen.dart';
import 'login_screen.dart';

class SetPasswordScreen extends HookConsumerWidget {
  static const routeName = '/setPasswordScreen';
  const SetPasswordScreen({super.key, this.isResetPassword});

  final bool? isResetPassword;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isPsychologistMode = ref.watch(psychologistModeProvider);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        forceMaterialTransparency: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Spacer(flex: 1),
            _buildTextHeader(context),
            const Spacer(flex: 1),
            _buildTextField(
              context,
              'New password',
            ),
            const SizedBox(height: 10),
            _buildTextField(
              context,
              'Confirm Password',
            ),
            const Spacer(flex: 1),
            CustomElevatedButton(
              buttonLabel: 'Next',
              onPressed: () {
                if (isResetPassword != null && isResetPassword == true) {
                  Navigator.popUntil(context, ModalRoute.withName(LoginScreen.routeName));
                } else if (isPsychologistMode) {
                  context.pushNamed(ProfileCreationQuestions.routeName);
                } else
                  context.pushNamed(QuestionnairePermissionScreen.routeName);
              },
              buttonStyle: ElevatedButton.styleFrom(
                enableFeedback: true,
                backgroundColor: Theme.of(context).buttonTheme.colorScheme!.primaryContainer,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const Spacer(flex: 1),
            _buildFooterText(context),
            const Spacer(flex: 7),
          ],
        ),
      ),
    );
  }

  Widget _buildTextHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FittedBox(
          child: Text(
            'Set Password',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        const SizedBox(height: 10),
        FittedBox(
          child: Text(
            'Create password and confirm it below',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).hintColor,
                ),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField(BuildContext context, String? textFieldLabel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FittedBox(
          child: Text(textFieldLabel ?? ''),
        ),
        const SizedBox(height: 10),
        TextField(
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }

  Widget _buildFooterText(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Don't have an account?"),
        TextButton(
          style: TextButton.styleFrom(
            visualDensity: VisualDensity.compact,
            padding: const EdgeInsets.only(left: 5),
            overlayColor: Colors.transparent,
          ),
          onPressed: () {
            context.pushReplacementNamed(LoginScreen.routeName);
          },
          child: const Text('Register'),
        ),
      ],
    );
  }
}
