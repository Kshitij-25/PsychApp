import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../notifiers/profile_creation_notifier.dart';
import '../../providers/file_upload_porviders.dart';
import '../questionnaire/questionnaire_permission_screen.dart';
import 'user_widgets/user_step_one.dart';
import 'user_widgets/user_step_two.dart';

class UserProfileCreation extends HookConsumerWidget {
  static const routeName = '/userProfileCreation';

  const UserProfileCreation({
    Key? key,
    required this.userEmail,
  }) : super(key: key);

  final String? userEmail;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProfileFormState = ref.watch(userProfileFormProvider);
    final userProfileForm = ref.read(userProfileFormProvider.notifier);

    final _profileFormKey = useState(GlobalKey<FormState>());
    final stepperIndex = useState(0);
    final _scrollController = useScrollController();
    final _isLoading = useState(false);
    final selectedTitles = useState<List<String>>([]);

    final fullNameController = useTextEditingController();
    final contactNumberController = useTextEditingController();
    final dobController = useTextEditingController();
    final addressController = useTextEditingController();

    final emergencyFullNameController = useTextEditingController();
    final emergencyRelationshipController = useTextEditingController();
    final emergencyContactNumberController = useTextEditingController();
    final languageControllerController = useTextEditingController();

    // Set initial email
    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        userProfileForm.updateField(
          userProfileFormState.copyWith(email: userEmail),
        );
      });
      return null;
    }, []);

    void _submitProfessionalProfile() {
      _isLoading.value = true;

      // Simulate submission delay
      Future.delayed(Duration(seconds: 2), () async {
        _isLoading.value = false;

        bool success = await userProfileForm.submitProfile();

        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              behavior: SnackBarBehavior.floating,
              content: Text(
                'Profile successfully created!',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.white,
                    ),
              ),
              backgroundColor: Colors.green,
            ),
          );
          context.pushReplacementNamed(
            QuestionnairePermissionScreen.routeName,
            extra: userEmail,
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              behavior: SnackBarBehavior.floating,
              content: Text(
                'Failed to submit profile',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onError,
                    ),
              ),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        }
      });
    }

    return Stack(
      children: [
        Scaffold(
          body: SafeArea(
            child: Stepper(
              currentStep: stepperIndex.value.clamp(0, 1),
              clipBehavior: Clip.none,
              elevation: 0,
              controller: _scrollController,
              physics: ScrollPhysics(),
              type: StepperType.horizontal,
              controlsBuilder: (BuildContext context, ControlsDetails details) {
                return Padding(
                  padding: const EdgeInsets.all(15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          enableFeedback: true,
                          elevation: 0,
                          backgroundColor: Theme.of(context).buttonTheme.colorScheme!.surface,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: details.onStepCancel,
                        child: Text(
                          'Back',
                          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                color: Theme.of(context).buttonTheme.colorScheme?.onPrimaryContainer,
                              ),
                        ),
                      ),
                      SizedBox(width: 16.0),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          enableFeedback: true,
                          backgroundColor: Theme.of(context).buttonTheme.colorScheme!.primaryContainer,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: details.onStepContinue,
                        child: Text(
                          stepperIndex.value != 1 ? 'Next' : 'Finish',
                          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                color: Theme.of(context).buttonTheme.colorScheme?.onPrimaryContainer,
                              ),
                        ),
                      ),
                    ],
                  ),
                );
              },
              onStepContinue: () {
                // Step-to-FormKey Mapping
                final formKeys = [
                  _profileFormKey.value,
                  null,
                ];

                // Get current form key based on stepperIndex
                final currentFormKey = formKeys[stepperIndex.value];

                // ✅ Validate the current form if it exists
                if (currentFormKey == null || currentFormKey.currentState?.validate() == true) {
                  if (stepperIndex.value < 1) {
                    stepperIndex.value++; // Move to the next step
                  } else {
                    // Final Step - Submit the form or handle final submission logic here
                    _submitProfessionalProfile();
                  }
                }
              },
              onStepCancel: () {
                if (stepperIndex.value > 0) {
                  stepperIndex.value--;
                }
              },
              steps: [
                Step(
                  title: Text(''),
                  content: UserStepOne(
                      userEmail: userEmail,
                      profileFormKey: _profileFormKey,
                      profileForm: userProfileForm,
                      formState: userProfileFormState,
                      fullNameCont: fullNameController,
                      dobCont: dobController,
                      contactNumberCont: contactNumberController,
                      addressController: addressController,
                      uploadImageTap: () async {
                        final ImagePicker picker = ImagePicker();
                        final XFile? image = await picker.pickImage(source: ImageSource.gallery);

                        if (image != null) {
                          final imageFile = File(image.path);

                          // Upload the image and get the URL
                          final imageUrl = await ref.read(fileUploadProvider.notifier).uploadProfilePicture(imageFile);

                          if (imageUrl != null) {
                            // Update the profile with the uploaded image URL
                            userProfileForm.updateField(
                              userProfileFormState.copyWith(profilePicUrl: imageUrl),
                            );
                          } else {
                            // Handle error case (show toast/snackbar)
                            print("Failed to upload image");
                          }
                        }
                      }),
                ),
                Step(
                  title: Text(''),
                  content: UserStepTwo(
                    userProfileForm: userProfileForm,
                    userProfileFormState: userProfileFormState,
                    emergencyContactNumber: emergencyContactNumberController,
                    emergencyFullName: emergencyFullNameController,
                    emergencyRelationship: emergencyRelationshipController,
                    languageController: languageControllerController,
                    selectedTitles: selectedTitles,
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
    );
  }
}
