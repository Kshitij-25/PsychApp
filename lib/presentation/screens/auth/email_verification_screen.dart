import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../notifiers/icon_state_notifier.dart';
import '../../providers/auth_providers.dart';
import '../../widgets/custom_elevated_button.dart';
import '../profile_creation/professional_profile_creation.dart';
import '../profile_creation/user_profile_creation.dart';
import 'login_screen.dart';

class EmailVerificationScreen extends HookConsumerWidget {
  static const routeName = '/emailVerificationScreen';
  const EmailVerificationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    final confirmPasswordController = useTextEditingController();

    final selectedRole = useState('');

    final formKey = GlobalKey<FormState>();

    final authNotifier = ref.watch(authNotifierProvider.notifier);
    final authState = ref.watch(authNotifierProvider);

    void handleSignUp() async {
      if (selectedRole.value == '') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            content: Text(
              'Please select a role to continue',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onError,
                  ),
            ),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      } else if (selectedRole.value == 'PROFESSIONAL') {
        if (formKey.currentState!.validate()) {
          if (passwordController.text == confirmPasswordController.text)
            try {
              final professionalRegister = await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog.adaptive(
                    title: Text('Register as a Professional'),
                    content: Text('Are you sure you want to continue as a Professional?'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () => context.pop(false),
                        child: Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () => context.pop(true),
                        child: Text('Yes'),
                      ),
                    ],
                  );
                },
              );
              if (professionalRegister == true) {
                final response = await authNotifier.registerUser(
                  emailController.text.toLowerCase().trim(),
                  passwordController.text.trim(),
                  selectedRole.value,
                );

                // ✅ Only navigate if the user is successfully logged in
                if (response != null && response.message == 'User successfully registered') {
                  context.goNamed(
                    ProfessionalProfileCreation.routeName,
                    extra: emailController.text,
                  );
                  // ProfileCreationQuestions.routeName;
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      behavior: SnackBarBehavior.floating,
                      content: Text(
                        response?.message ?? '',
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
          else {
            // ✅ Show error in Snackbar
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                behavior: SnackBarBehavior.floating,
                content: Text(
                  "Passwords don't match",
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
      } else {
        if (passwordController.text == confirmPasswordController.text)
          try {
            final response = await authNotifier.registerUser(
              emailController.text.toLowerCase().trim(),
              passwordController.text.trim(),
              selectedRole.value,
            );

            // ✅ Only navigate if the user is successfully logged in
            if (response != null && response.message == 'User successfully registered') {
              context.goNamed(
                UserProfileCreation.routeName,
                extra: emailController.text,
              );
              // ProfileCreationQuestions.routeName;
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  behavior: SnackBarBehavior.floating,
                  content: Text(
                    response?.message ?? '',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onError,
                        ),
                  ),
                  backgroundColor: Theme.of(context).colorScheme.error,
                ),
              );
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
        else {
          // ✅ Show error in Snackbar
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              behavior: SnackBarBehavior.floating,
              content: Text(
                "Passwords don't match",
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
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: SafeArea(
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
                      confirmPasswordController: confirmPasswordController,
                    ),
                    const Spacer(flex: 1),
                    _buildPhoneNumberField(
                      context,
                      emailController: emailController,
                      passwordController: passwordController,
                      confirmPasswordController: confirmPasswordController,
                      iconState: ref.watch(iconStateProvider),
                      ref: ref,
                    ),
                    const Spacer(flex: 1),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Choose your role:'),
                        Spacer(flex: 3),
                        ChoiceChip(
                          label: Text('User'),
                          selected: selectedRole.value == 'USER',
                          onSelected: (bool selected) {
                            selectedRole.value = selected ? 'USER' : '';
                          },
                          selectedColor: Theme.of(context).colorScheme.primaryContainer,
                          backgroundColor: Theme.of(context).colorScheme.surface,
                          labelStyle: TextStyle(
                            color: selectedRole.value == 'USER' ? Colors.white : Theme.of(context).colorScheme.onSurface,
                          ),
                          showCheckmark: false,
                        ),
                        Spacer(flex: 1),
                        ChoiceChip(
                          label: Text('Professional'),
                          selected: selectedRole.value == 'PROFESSIONAL',
                          onSelected: (bool selected) {
                            selectedRole.value = selected ? 'PROFESSIONAL' : '';
                          },
                          selectedColor: Theme.of(context).colorScheme.primaryContainer,
                          backgroundColor: Theme.of(context).colorScheme.surface,
                          labelStyle: TextStyle(
                            color: selectedRole.value == 'PROFESSIONAL' ? Colors.white : Theme.of(context).colorScheme.onSurface,
                          ),
                          showCheckmark: false,
                        ),
                      ],
                    ),
                    const Spacer(flex: 1),
                    CustomElevatedButton(
                      buttonLabel: 'Next',
                      onPressed: handleSignUp,
                      buttonStyle: ElevatedButton.styleFrom(
                        enableFeedback: true,
                        backgroundColor: Theme.of(context).buttonTheme.colorScheme!.primaryContainer,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    const Spacer(flex: 1),
                    _buildLoginText(context),
                    const Spacer(flex: 5),
                    _buildFooterText(context),
                  ],
                ),
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
    required TextEditingController confirmPasswordController,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            emailController.text = 'kshitijnishu@gmail.com';
            passwordController.text = 'Nishu@2201';
            confirmPasswordController.text = 'Nishu@2201';
          },
          child: FittedBox(
            child: Text(
              'Create Account',
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
            'Sign up to start your journey towards\nbetter mental health and self-care!',
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
    required TextEditingController passwordController,
    required TextEditingController confirmPasswordController,
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
                ref.read(iconStateProvider.notifier).toggleIcon(IconType.registerPassword);
              },
              icon: Icon(
                iconState[IconType.registerPassword]! ? CupertinoIcons.eye_fill : CupertinoIcons.eye_slash_fill,
              ),
            ),
          ),
          obscureText: iconState[IconType.registerPassword]!,
          textInputAction: TextInputAction.next,
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
        SizedBox(height: 10),
        FittedBox(
          child: Text('Confirm Password'),
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: confirmPasswordController,
          decoration: InputDecoration(
            hintText: 'Confirm Password',
            border: OutlineInputBorder(
              borderSide: BorderSide(),
            ),
            suffixIcon: IconButton(
              onPressed: () {
                ref.read(iconStateProvider.notifier).toggleIcon(IconType.confirmPassword);
              },
              icon: Icon(
                iconState[IconType.confirmPassword]! ? CupertinoIcons.eye_fill : CupertinoIcons.eye_slash_fill,
              ),
            ),
          ),
          obscureText: iconState[IconType.confirmPassword]!,
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
            context.pushReplacementNamed(LoginScreen.routeName);
          },
          child: const Text('Login'),
        ),
      ],
    );
  }

  Widget _buildFooterText(BuildContext context) {
    return Text(
      "By signing up you accept the Terms of service\nand Privacy Policy",
      style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).hintColor,
          ),
      textAlign: TextAlign.center,
    );
  }
}
