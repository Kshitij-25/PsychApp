import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../../shared/constants/firebase_helper.dart';
import '../../notifiers/user_profile_creation_notifier.dart';
import '../../widgets/custom_elevated_button.dart';
import '../home/home_navigator.dart';

class ProfileCreationQuestions extends HookConsumerWidget {
  static const routeName = '/profileCreationQuestions';

  const ProfileCreationQuestions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formState = ref.watch(userProfileFormProvider);
    final profileForm = ref.read(userProfileFormProvider.notifier);
    final _formKey = useState(GlobalKey<FormState>());
    final _scrollController = useScrollController();
    final _isLoading = useState(false);
    final fullNameCont = useTextEditingController();
    final phoneNumberCont = useTextEditingController();
    final dobCont = useTextEditingController();
    final emergencyContactCont = useTextEditingController();

    // Set initial email
    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        profileForm.updateField('email', FirebaseHelper.currentUser?.email);
      });
      return null;
    }, []);

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Form(
              key: _formKey.value,
              child: SingleChildScrollView(
                controller: _scrollController,
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(
                      child: GestureDetector(
                        onTap: () async {
                          final ImagePicker picker = ImagePicker();
                          final XFile? image = await picker.pickImage(
                            source: ImageSource.gallery,
                            maxWidth: 512,
                            maxHeight: 512,
                            imageQuality: 70,
                          );
                          if (image != null) {
                            profileForm.updateField('avatarPath', image.path);
                          }
                        },
                        child: CircleAvatar(
                          radius: 70,
                          backgroundColor: Theme.of(context).colorScheme.primary,
                          backgroundImage: formState['avatarPath'].isNotEmpty
                              ? FileImage(File(formState['avatarPath']))
                              : formState['avatarUrl'].isNotEmpty
                                  ? NetworkImage(formState['avatarUrl']) as ImageProvider
                                  : null,
                          child: formState['avatarPath'].isEmpty && formState['avatarUrl'].isEmpty
                              ? const Icon(
                                  CupertinoIcons.camera_fill,
                                  size: 30,
                                )
                              : null,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Basic Information',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      initialValue: FirebaseHelper.currentUser?.email,
                      readOnly: true,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(),
                      ),
                      textInputAction: TextInputAction.next,
                      onTapOutside: (event) => FocusScope.of(context).unfocus(),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: fullNameCont,
                      decoration: const InputDecoration(
                        labelText: 'Full Name*',
                        border: OutlineInputBorder(),
                      ),
                      textInputAction: TextInputAction.next,
                      onTapOutside: (event) => FocusScope.of(context).unfocus(),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your name';
                        }
                        return null;
                      },
                      onChanged: (value) => profileForm.updateField('fullName', value),
                    ),
                    const SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: 'Gender*',
                        border: OutlineInputBorder(),
                      ),
                      items: ['Male', 'Female', 'Non-binary', 'Prefer not to say'].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (value) => profileForm.updateField('gender', value),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select your gender';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: phoneNumberCont,
                      decoration: const InputDecoration(
                        labelText: 'Phone Number*',
                        border: OutlineInputBorder(),
                      ),
                      textInputAction: TextInputAction.next,
                      onTapOutside: (event) => FocusScope.of(context).unfocus(),
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your phone number';
                        }
                        return null;
                      },
                      onChanged: (value) => profileForm.updateField('phoneNumber', value),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Additional Information',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: dobCont,
                      decoration: const InputDecoration(
                        labelText: 'Date of Birth',
                        border: OutlineInputBorder(),
                        suffixIcon: Icon(Icons.calendar_today),
                      ),
                      textInputAction: TextInputAction.next,
                      onTapOutside: (event) => FocusScope.of(context).unfocus(),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                      readOnly: true,
                      onTap: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1900),
                          lastDate: DateTime.now(),
                        );
                        dobCont.text = DateFormat('dd-MM-yyyy').format(date!);
                        profileForm.updateField('dateOfBirth', date);
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: emergencyContactCont,
                      decoration: const InputDecoration(
                        labelText: 'Emergency Contact',
                        border: OutlineInputBorder(),
                      ),
                      textInputAction: TextInputAction.done,
                      onTapOutside: (event) => FocusScope.of(context).unfocus(),
                      onChanged: (value) => profileForm.updateField('emergencyContact', value),
                    ),
                    const SizedBox(height: 16),

                    // Preferred Language
                    // DropdownButtonFormField<String>(
                    //   decoration: const InputDecoration(
                    //     labelText: 'Preferred Language',
                    //     border: OutlineInputBorder(),
                    //   ),
                    //   items: ['English', 'Spanish', 'French', 'German', 'Other'].map((String value) {
                    //     return DropdownMenuItem<String>(
                    //       value: value,
                    //       child: Text(value),
                    //     );
                    //   }).toList(),
                    //   onChanged: (value) => profileForm.updateField('preferredLanguage', value),
                    //   value: formState['preferredLanguage'],
                    // ),
                    // const SizedBox(height: 16),

                    // Mental Health Information Section
                    // const Text(
                    //   'Mental Health Information',
                    //   style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    // ),
                    // const SizedBox(height: 16),

                    // // Stress Level
                    // Column(
                    //   crossAxisAlignment: CrossAxisAlignment.start,
                    //   children: [
                    //     const Text('Current Stress Level'),
                    //     Slider(
                    //       value: formState['stressLevel'].toDouble(),
                    //       min: 1,
                    //       max: 10,
                    //       divisions: 9,
                    //       label: formState['stressLevel'].toString(),
                    //       onChanged: (value) => profileForm.updateField('stressLevel', value.round()),
                    //     ),
                    //   ],
                    // ),
                    // const SizedBox(height: 16),

                    // // Previous Therapy Experience
                    // SwitchListTile(
                    //   title: const Text('Previous Therapy Experience'),
                    //   value: formState['previousTherapy'],
                    //   onChanged: (bool value) => profileForm.updateField('previousTherapy', value),
                    // ),
                    // const SizedBox(height: 24),
                    CustomElevatedButton(
                      buttonLabel: 'Next',
                      onPressed: _isLoading.value
                          ? null
                          : () async {
                              if (_formKey.value.currentState!.validate()) {
                                _isLoading.value = true;

                                final success = await profileForm.submitProfile(FirebaseHelper.currentUserId!);

                                _isLoading.value = false;

                                if (success) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      behavior: SnackBarBehavior.floating,
                                      content: Text(
                                        'Profile created successfully',
                                        textAlign: TextAlign.center,
                                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                              color: Theme.of(context).colorScheme.onTertiaryContainer,
                                            ),
                                      ),
                                      backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
                                    ),
                                  );
                                  context.goNamed(HomeNavigator.routeName);
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      behavior: SnackBarBehavior.floating,
                                      content: Text(
                                        'Error creating profile. Please try again.',
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
                            },
                      buttonStyle: ElevatedButton.styleFrom(
                        enableFeedback: true,
                        backgroundColor: Theme.of(context).buttonTheme.colorScheme!.primaryContainer,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (_isLoading.value)
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
        ),
      ),
    );
  }
}
