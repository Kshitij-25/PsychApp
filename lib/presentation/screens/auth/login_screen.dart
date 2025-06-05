import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../notifiers/icon_state_notifier.dart';
import '../../providers/auth_providers.dart';
import '../../widgets/custom_elevated_button.dart';
import '../home/home_navigator.dart';
import '../home/psychologist_home_nav.dart';
import 'email_verification_screen.dart';
import 'forgot_password_screen.dart';

class LoginScreen extends HookConsumerWidget {
  static const routeName = '/loginScreen';
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();

    final formKey = GlobalKey<FormState>();

    final authNotifier = ref.watch(authNotifierProvider.notifier);
    final authState = ref.watch(authNotifierProvider);

    void handleSignIn() async {
      if (formKey.currentState!.validate()) {
        try {
          final prefs = await SharedPreferences.getInstance();

          final user = await authNotifier.login(
            emailController.text.toLowerCase().trim(),
            passwordController.text.trim(),
          );

          // ✅ Only navigate if the user is successfully logged in
          if (user != null) {
            final String? userRole = prefs.getString('userRole');

            ref.read(isGuestLoginProvider.notifier).state = false;

            if (userRole == "USER") {
              context.goNamed(HomeNavigator.routeName);
            } else {
              context.goNamed(PsychologistHomeNav.routeName);
            }
          }
        } catch (e) {
          // ✅ Show error in Snackbar
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              behavior: SnackBarBehavior.floating,
              content: Text(
                e.toString().replaceFirst("Exception: ", ""),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onError,
                    ),
              ),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        }
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
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Spacer(flex: 1),
                  _buildTextHeader(
                    context,
                    emailController: emailController,
                    passwordController: passwordController,
                  ),
                  const Spacer(flex: 1),
                  _buildTextField(
                    context,
                    emailController: emailController,
                    passwordController: passwordController,
                    iconState: ref.watch(iconStateProvider),
                    ref: ref,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: TextButton(
                      onPressed: () {
                        context.pushNamed(ForgotPasswordScreen.routeName);
                      },
                      style: TextButton.styleFrom(
                        overlayColor: Colors.transparent,
                      ),
                      child: const Text('Forgot password?'),
                    ),
                  ),
                  const Spacer(flex: 1),
                  CustomElevatedButton(
                    buttonLabel: 'Log In',
                    onPressed: handleSignIn,
                    buttonStyle: ElevatedButton.styleFrom(
                      enableFeedback: true,
                      backgroundColor: Theme.of(context).buttonTheme.colorScheme!.primaryContainer,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const Spacer(flex: 2),
                  _buildDividerWithText(context),
                  const Spacer(flex: 1),
                  _buildOtherSignInOptions(context),
                  const Spacer(flex: 2),
                  _buildFooterText(context),
                  const Spacer(flex: 1),
                ],
              ),
            ),
          ),
        ),
        if (authState.isLoading)
          Container(
            color: Colors.black87,
            child: Center(
              child: CircularProgressIndicator(
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildTextHeader(
    BuildContext context, {
    required TextEditingController emailController,
    required TextEditingController passwordController,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            emailController.text = 'kshitijnishu@gmail.com';
            passwordController.text = 'Nishu@2201';
          },
          onDoubleTap: () {
            emailController.text = 'kshitij@gmail.com';
            passwordController.text = 'Nishu@2201';
          },
          child: FittedBox(
            child: Text(
              'Login Account',
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
            'Hello, Welcome back to your account!',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).hintColor,
                ),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField(
    BuildContext context, {
    required TextEditingController emailController,
    required TextEditingController passwordController,
    required Map<IconType, bool> iconState,
    required WidgetRef ref,
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
          textInputAction: TextInputAction.next,
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
        SizedBox(height: 10),
        FittedBox(
          child: Text('Password'),
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: passwordController,
          decoration: InputDecoration(
            hintText: 'Enter Password',
            border: OutlineInputBorder(
              borderSide: BorderSide(),
            ),
            suffixIcon: IconButton(
              onPressed: () {
                ref.read(iconStateProvider.notifier).toggleIcon(IconType.loginPassword);
              },
              icon: Icon(
                iconState[IconType.loginPassword]! ? CupertinoIcons.eye_fill : CupertinoIcons.eye_slash_fill,
              ),
            ),
          ),
          obscureText: iconState[IconType.loginPassword]!,
          textInputAction: TextInputAction.done,
          autofillHints: [AutofillHints.password],
          enableSuggestions: true,
          onTapOutside: (event) => FocusScope.of(context).unfocus(),
          keyboardType: TextInputType.visiblePassword,
          validator: (value) {
            if (value!.isEmpty) {
              return 'Password cannot be empty';
            } else if (value.length < 6) {
              return 'Password must be at least 6 characters';
            }
            return null; // Valid password
          },
        ),
      ],
    );
  }

  Widget _buildDividerWithText(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          child: Divider(thickness: 2),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: FittedBox(
            child: Text(
              "Continue with",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ),
        const Expanded(
          child: Divider(thickness: 2),
        ),
      ],
    );
  }

  Widget _buildOtherSignInOptions(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        IconButton(
          iconSize: 30,
          onPressed: () {},
          icon: const Icon(FontAwesomeIcons.google),
        ),
        // IconButton(
        //   iconSize: 30,
        //   onPressed: () {},
        //   icon: const Icon(FontAwesomeIcons.facebook),
        // ),
        // IconButton(
        //   iconSize: 35,
        //   onPressed: () {},
        //   icon: const Icon(FontAwesomeIcons.apple),
        // ),
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
            context.pushReplacementNamed(EmailVerificationScreen.routeName);
          },
          child: const Text('Register'),
        ),
      ],
    );
  }
}
