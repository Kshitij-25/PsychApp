import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../widgets/custom_elevated_button.dart';

class ForgotPasswordScreen extends HookConsumerWidget {
  static const routeName = '/forgotPasswordScreen';
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emailController = useTextEditingController();

    final formKey = GlobalKey<FormState>();

    // final authNotifier = ref.watch(authStateNotifierProvider.notifier);
    // final authState = ref.watch(authStateNotifierProvider);

    void handleForgetPassword() async {
      if (formKey.currentState!.validate()) {
        // try {
        //   await authNotifier.resetPassword(email: emailController.text);

        //   ScaffoldMessenger.of(context).showSnackBar(
        //     SnackBar(
        //       behavior: SnackBarBehavior.floating,
        //       content: Text(
        //         'Please check your email to reset password',
        //         textAlign: TextAlign.center,
        //         style: Theme.of(context).textTheme.bodySmall?.copyWith(
        //               color: Theme.of(context).colorScheme.onTertiaryContainer,
        //             ),
        //       ),
        //       backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
        //     ),
        //   );

        //   context.pop();
        // } catch (e) {
        //   ScaffoldMessenger.of(context).showSnackBar(
        //     SnackBar(
        //       behavior: SnackBarBehavior.floating,
        //       content: Text(
        //         e.toString().replaceFirst("Exception: ", ""),
        //         textAlign: TextAlign.center,
        //         style: Theme.of(context).textTheme.bodySmall?.copyWith(
        //               color: Theme.of(context).colorScheme.onError,
        //             ),
        //       ),
        //       backgroundColor: Theme.of(context).colorScheme.error,
        //     ),
        //   );
        // }
      }
    }

    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            forceMaterialTransparency: true,
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: SafeArea(
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Spacer(flex: 1),
                    _buildTextHeader(context, emailController),
                    const Spacer(flex: 1),
                    _buildPhoneNumberField(
                      context,
                      emailController: emailController,
                    ),
                    const Spacer(flex: 1),
                    CustomElevatedButton(
                      buttonLabel: 'Submit',
                      onPressed: handleForgetPassword,
                      buttonStyle: ElevatedButton.styleFrom(
                        enableFeedback: true,
                        backgroundColor: Theme.of(context).buttonTheme.colorScheme!.primaryContainer,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    const Spacer(flex: 10),
                  ],
                ),
              ),
            ),
          ),
        ),
        // if (authState.isLoading)
        //   Container(
        //     color: Colors.black87,
        //     child: Center(
        //       child: CircularProgressIndicator(
        //         backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        //         color: Theme.of(context).colorScheme.onPrimaryContainer,
        //       ),
        //     ),
        //   ),
      ],
    );
  }

  Widget _buildTextHeader(BuildContext context, TextEditingController emailController) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () => emailController.text = 'kshitijnishu@gmail.com',
          child: FittedBox(
            child: Text(
              'Reset Password',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        FittedBox(
          child: Text(
            'Confirm your Email Address',
            textAlign: TextAlign.start,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).hintColor,
                ),
          ),
        ),
      ],
    );
  }

  Widget _buildPhoneNumberField(
    BuildContext context, {
    required TextEditingController emailController,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FittedBox(
          child: Text('Email Address'),
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: emailController,
          decoration: InputDecoration(
            hintText: 'Enter your email address',
            border: OutlineInputBorder(
              borderSide: BorderSide(),
            ),
          ),
          textInputAction: TextInputAction.done,
          autofillHints: [AutofillHints.email],
          enableSuggestions: true,
          onTapOutside: (event) => FocusScope.of(context).unfocus(),
          keyboardType: TextInputType.emailAddress,
          validator: (value) {
            const emailRegex = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
            if (value!.isEmpty) {
              return 'Email cannot be empty';
            } else if (!RegExp(emailRegex).hasMatch(value)) {
              return 'Please enter a valid email address';
            }
            return null; // Valid email
          },
        ),
      ],
    );
  }

  Widget _buildLoginText(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Already have an account?"),
        TextButton(
          style: TextButton.styleFrom(
            visualDensity: VisualDensity.compact,
            padding: const EdgeInsets.only(left: 0),
            overlayColor: Colors.transparent,
          ),
          onPressed: () {
            // context.pushReplacementNamed(LoginScreen.routeName);
          },
          child: const Text('Login'),
        ),
      ],
    );
  }

  Widget _buildFooterText(BuildContext context) {
    return Text(
      "By signing up you accept the Terms of service\nand Privacy Policy",
      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: Theme.of(context).hintColor,
          ),
      textAlign: TextAlign.center,
    );
  }
}
