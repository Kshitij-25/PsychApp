import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../notifiers/psychologist_profile_creation_notifier.dart';
import 'professoinal_widgets/availablitiy_services.dart';
import 'professoinal_widgets/educational_background.dart';
import 'professoinal_widgets/insurance_legal_documents.dart';
import 'professoinal_widgets/optional_personalization.dart';
import 'professoinal_widgets/preofessional_experience.dart';
import 'professoinal_widgets/professional_credentials.dart';
import 'professoinal_widgets/profile_info.dart';
import 'professoinal_widgets/therapy_approach_techniques.dart';

class ProfessionalProfileCreation extends HookConsumerWidget {
  static const routeName = '/professionalProfileCreation';
  const ProfessionalProfileCreation({super.key, required this.userEmail});

  final String? userEmail;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final professionalformState = ref.watch(psychologistProfileFormProvider);
    final professionalProfileProvider = ref.read(psychologistProfileFormProvider.notifier);

    final _profileFormKey = useState(GlobalKey<FormState>());
    final _credentialsFormKey = useState(GlobalKey<FormState>());
    final _educationalFormKey = useState(GlobalKey<FormState>());
    final _experienceFormKey = useState(GlobalKey<FormState>());
    final _therapyFormKey = useState(GlobalKey<FormState>());
    final _availabilityFormKey = useState(GlobalKey<FormState>());
    final _scrollController = useScrollController();
    final _isLoading = useState(false);
    final stepperIndex = useState(0);

    final multipleStatePractice = useState(false);
    final boardCertified = useState(false);
    final coupleTherapy = useState(false);
    final crisisIntervention = useState(false);
    final newClients = useState(false);
    final acceptInsurance = useState(false);
    final disciplinaryAction = useState(false);
    final misconduct = useState(false);
    final backgroundCheck = useState(false);
    final privacyPolicy = useState(false);

    final fullNameController = useTextEditingController();
    final dobController = useTextEditingController();
    final contactNumberController = useTextEditingController();
    final addressController = useTextEditingController();
    final professionalTitleController = useTextEditingController();
    final licenseNumberController = useTextEditingController();
    final issuingAuthorityController = useTextEditingController();
    final licenseExpireController = useTextEditingController();
    final highestDegreeController = useTextEditingController();
    final institutionNameController = useTextEditingController();
    final graduationDateController = useTextEditingController();
    final experienceController = useTextEditingController();
    final languageController = useTextEditingController();
    final approachOfTherapyController = useTextEditingController();
    final certificationController = useTextEditingController();
    final identityController = useTextEditingController();
    final malpracticeController = useTextEditingController();
    final resumeController = useTextEditingController();
    final healProfessionalController = useTextEditingController();
    final healthJourneyController = useTextEditingController();
    final passionateController = useTextEditingController();

    StepState getStepState(int currentStep, int stepperIndex) {
      if (stepperIndex > currentStep) {
        return StepState.complete; // ✅ Step is completed
      } else if (stepperIndex == currentStep) {
        return StepState.editing; // ✏️ Currently being edited
      } else {
        return StepState.disabled; // 🚫 Future step (disabled)
      }
    }

    // Set initial email
    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        professionalProfileProvider.updateField(
          professionalformState.copyWith(email: userEmail),
        );
      });
      return null;
    }, []);

    return Stack(
      children: [
        Scaffold(
          body: SafeArea(
            child: Stepper(
              currentStep: stepperIndex.value.clamp(0, 7),
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
                          stepperIndex.value != 7 ? 'Next' : 'Finish',
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
                  _credentialsFormKey.value,
                  _educationalFormKey.value,
                  _experienceFormKey.value,
                  _therapyFormKey.value,
                  _availabilityFormKey.value,
                  null, // Step 6 (InsuranceLegalDocuments) - No form validation required
                  null, // Step 7 (OptionalPersonalization) - Optional fields, no validation required
                ];

                // Get current form key based on stepperIndex
                final currentFormKey = formKeys[stepperIndex.value];

                // ✅ Validate the current form if it exists
                if (currentFormKey == null || currentFormKey.currentState?.validate() == true) {
                  if (stepperIndex.value < 7) {
                    stepperIndex.value++; // Move to the next step
                  } else {
                    // Final Step - Submit the form or handle final submission logic here
                    // _submitProfessionalProfile();
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
                  isActive: stepperIndex.value == 0,
                  state: getStepState(0, stepperIndex.value),
                  content: ProfileInfo(
                    formKey: _profileFormKey,
                    userEmail: userEmail,
                    professionalProfileProvider: professionalProfileProvider,
                    professionalformState: professionalformState,
                    fullNameController: fullNameController,
                    dobController: dobController,
                    contactNumberController: contactNumberController,
                    addressController: addressController,
                  ),
                ),
                Step(
                  title: Text(''),
                  isActive: stepperIndex.value == 1,
                  state: getStepState(1, stepperIndex.value),
                  content: ProfessionalCredentials(
                    formKey: _credentialsFormKey,
                    professionalTitleController: professionalTitleController,
                    licenseNumberController: licenseNumberController,
                    issuingAuthorityController: issuingAuthorityController,
                    licenseExpireController: licenseExpireController,
                    professionalProfileProvider: professionalProfileProvider,
                    professionalformState: professionalformState,
                    multipleStatePractice: multipleStatePractice,
                    boardCertified: boardCertified,
                  ),
                ),
                Step(
                  title: Text(''),
                  isActive: stepperIndex.value == 2,
                  state: getStepState(2, stepperIndex.value),
                  content: EducationalBackground(
                    formKey: _educationalFormKey,
                    highestDegreeController: highestDegreeController,
                    institutionNameController: institutionNameController,
                    graduationDateController: graduationDateController,
                    professionalProfileProvider: professionalProfileProvider,
                    professionalformState: professionalformState,
                  ),
                ),
                Step(
                  title: Text(''),
                  isActive: stepperIndex.value == 3,
                  state: getStepState(3, stepperIndex.value),
                  content: PreofessionalExperience(
                    formKey: _experienceFormKey,
                    experienceController: experienceController,
                    languageController: languageController,
                    professionalformState: professionalformState,
                    coupleTherapy: coupleTherapy,
                  ),
                ),
                Step(
                  title: Text(''),
                  isActive: stepperIndex.value == 4,
                  state: getStepState(4, stepperIndex.value),
                  content: TherapyApproachTechniques(
                    formKey: _therapyFormKey,
                    professionalformState: professionalformState,
                    crisisIntervention: crisisIntervention,
                    approachOfTherapyController: approachOfTherapyController,
                  ),
                ),
                Step(
                  title: Text(''),
                  isActive: stepperIndex.value == 5,
                  state: getStepState(5, stepperIndex.value),
                  content: AvailablitiyServices(
                    formKey: _availabilityFormKey,
                    professionalformState: professionalformState,
                    newClients: newClients,
                  ),
                ),
                Step(
                  title: Text(''),
                  isActive: stepperIndex.value == 6,
                  state: getStepState(6, stepperIndex.value),
                  content: InsuranceLegalDocuments(
                    acceptInsurance: acceptInsurance,
                    disciplinaryAction: disciplinaryAction,
                    misconduct: misconduct,
                    backgroundCheck: backgroundCheck,
                    privacyPolicy: privacyPolicy,
                    certificationController: certificationController,
                    identityController: identityController,
                    malpracticeController: malpracticeController,
                    resumeController: resumeController,
                  ),
                ),
                Step(
                  title: Text(''),
                  isActive: stepperIndex.value == 7,
                  state: getStepState(7, stepperIndex.value),
                  content: OptionalPersonalization(
                    healProfessionalController: healProfessionalController,
                    healthJourneyController: healthJourneyController,
                    passionateController: passionateController,
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
