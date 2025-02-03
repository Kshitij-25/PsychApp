import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pinput/pinput.dart';

import '../../widgets/custom_elevated_button.dart';
import 'set_password_screen.dart';

class OtpScreen extends HookConsumerWidget {
  static const routeName = '/otpScreen';
  const OtpScreen({super.key, this.isResetPassword});

  final bool? isResetPassword;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        forceMaterialTransparency: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Spacer(flex: 1),
            _buildTextHeader(context),
            const Spacer(flex: 1),
            _buildOtpField(context),
            Spacer(flex: 1),
            _buildButtons(context),
            Spacer(flex: 6),
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
            'Verification Code',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        const SizedBox(height: 10),
        FittedBox(
          child: Text(
            'Please enter code sent to number',
            textAlign: TextAlign.start,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).hintColor,
                ),
          ),
        ),
      ],
    );
  }

  Widget _buildOtpField(BuildContext context) {
    return Pinput(
      onCompleted: (pin) => print(pin),
    );
  }

  Widget _buildButtons(BuildContext context) {
    return Column(
      children: [
        FractionallySizedBox(
          widthFactor: 0.83,
          child: CustomElevatedButton(
            buttonLabel: 'Submit',
            onPressed: () {
              context.pushNamed(SetPasswordScreen.routeName, extra: isResetPassword);
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
        SizedBox(height: 20),
        FractionallySizedBox(
          widthFactor: 0.83,
          child: CustomElevatedButton(
            buttonLabel: 'Send again',
            onPressed: () {},
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
