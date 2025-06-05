import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../data/local_data_source/expertise_data.dart';
import '../../../../data/models/user_profile_data/emergeny_contact_model.dart';
import '../../../../data/models/user_profile_data/therapy_preferences_model.dart';
import '../../../../data/models/user_profile_data/user_profile_model.dart';
import '../../../notifiers/profile_creation_notifier.dart';

class UserStepTwo extends StatelessWidget {
  const UserStepTwo({
    super.key,
    required this.userProfileFormState,
    required this.userProfileForm,
    required this.selectedTitles,
    required this.emergencyFullName,
    required this.emergencyRelationship,
    required this.emergencyContactNumber,
    required this.languageController,
  });

  final UserProfileFormNotifier userProfileForm;
  final UserProfileModel userProfileFormState;
  final ValueNotifier<List<String>> selectedTitles;
  final TextEditingController emergencyFullName;
  final TextEditingController emergencyRelationship;
  final TextEditingController emergencyContactNumber;
  final TextEditingController languageController;

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildSectionHeader(context, 'Emergency Contact'),
          const SizedBox(height: 20),
          TextFormField(
            controller: emergencyFullName,
            decoration: const InputDecoration(
              labelText: 'Full Name',
              border: OutlineInputBorder(),
            ),
            textInputAction: TextInputAction.next,
            onChanged: (value) {
              final emergencyInfo = userProfileFormState.emergencyContact ?? EmergenyContactModel(); // Ensure it's not null

              final updatedEmergencyInfo = emergencyInfo.copyWith(
                emergencyName: value,
              );

              userProfileForm.updateField(
                userProfileFormState.copyWith(emergencyContact: updatedEmergencyInfo),
              );
            },
            onTapOutside: (event) => FocusScope.of(context).unfocus(),
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: emergencyRelationship,
            decoration: const InputDecoration(
              labelText: 'Emergency Relationship',
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
            onChanged: (value) {
              final emergencyInfo = userProfileFormState.emergencyContact ?? EmergenyContactModel(); // Ensure it's not null

              final updatedEmergencyInfo = emergencyInfo.copyWith(
                emergencyRelationship: value,
              );

              userProfileForm.updateField(
                userProfileFormState.copyWith(emergencyContact: updatedEmergencyInfo),
              );
            },
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: emergencyContactNumber,
            decoration: const InputDecoration(
              labelText: 'Emergency Contact Number',
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
            onChanged: (value) {
              final emergencyInfo = userProfileFormState.emergencyContact ?? EmergenyContactModel(); // Ensure it's not null

              final updatedEmergencyInfo = emergencyInfo.copyWith(
                emergencyPhone: value,
              );

              userProfileForm.updateField(
                userProfileFormState.copyWith(emergencyContact: updatedEmergencyInfo),
              );
            },
          ),
          const SizedBox(height: 20),
          _buildSectionHeader(context, 'Therapy Preferences'),
          const SizedBox(height: 20),
          TextFormField(
            controller: languageController,
            decoration: const InputDecoration(
              labelText: 'Languages Spoken* (Separate with " , ")',
              border: OutlineInputBorder(),
            ),
            textInputAction: TextInputAction.next,
            onTapOutside: (event) => FocusScope.of(context).unfocus(),
            onChanged: (value) {
              final existingPreferences = userProfileFormState.therapyPreferences ?? TherapyPreferencesModel(); // Ensure it's not null

              final updatedTherapyPreferences = existingPreferences.copyWith(
                preferredLanguage: value,
              );

              userProfileForm.updateField(
                userProfileFormState.copyWith(therapyPreferences: updatedTherapyPreferences),
              );
              // final updatedTherapyPreferences = (userProfileFormState.therapyPreferences)?.copyWith(
              //   preferredLanguage: value,
              // );

              // userProfileForm.updateField(
              //   userProfileFormState.copyWith(therapyPreferences: updatedTherapyPreferences),
              // );
            },
          ),
          const SizedBox(height: 10),
          Consumer(builder: (context, ref, _) {
            final selectedTherapyMode = userProfileFormState.therapyPreferences?.therapyMode ?? '';

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Preferred Therapy Mode', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8.0,
                  children: therapyModes.map((filter) {
                    final label = filter['label']!;
                    return ChoiceChip(
                      showCheckmark: false,
                      label: Text(label),
                      selected: selectedTherapyMode == label,
                      onSelected: (isSelected) {
                        final existingPreferences = userProfileFormState.therapyPreferences ?? TherapyPreferencesModel(); // Ensure it's not null

                        final updatedTherapyPreferences = existingPreferences.copyWith(
                          therapyMode: isSelected ? label : null,
                        );

                        userProfileForm.updateField(
                          userProfileFormState.copyWith(therapyPreferences: updatedTherapyPreferences),
                        );
                      },
                      selectedColor: Theme.of(context).colorScheme.primaryContainer,
                      backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                      labelStyle: TextStyle(
                        color:
                            selectedTherapyMode == label ? Theme.of(context).colorScheme.onPrimaryContainer : Theme.of(context).colorScheme.onSurface,
                      ),
                    );
                  }).toList(),
                ),
              ],
            );
          }),
          const SizedBox(height: 10),
          // ✅ Preferred Therapy Gender (Single Selection)
          Consumer(builder: (context, ref, _) {
            final selectedGender = userProfileFormState.therapyPreferences?.preferredProfessionalGender ?? '';

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Preferred Therapy Gender', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8.0,
                  children: ['Male', 'Female', 'Non-binary', 'Prefer not to say'].map((label) {
                    return ChoiceChip(
                      showCheckmark: false,
                      label: Text(label),
                      selected: selectedGender == label,
                      onSelected: (isSelected) {
                        final existingPreferences = userProfileFormState.therapyPreferences ?? TherapyPreferencesModel(); // Ensure it's not null

                        final updatedTherapyPreferences = existingPreferences.copyWith(
                          preferredProfessionalGender: isSelected ? label : null,
                        );

                        userProfileForm.updateField(
                          userProfileFormState.copyWith(therapyPreferences: updatedTherapyPreferences),
                        );
                      },
                      selectedColor: Theme.of(context).colorScheme.primaryContainer,
                      backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                      labelStyle: TextStyle(
                        color: selectedGender == label ? Theme.of(context).colorScheme.onPrimaryContainer : Theme.of(context).colorScheme.onSurface,
                      ),
                    );
                  }).toList(),
                ),
              ],
            );
          }),
          const SizedBox(height: 10),
          ExpansionTile(
            title: Text("Select Professional Types", style: Theme.of(context).textTheme.titleMedium),
            dense: true,
            shape: RoundedRectangleBorder(side: BorderSide.none),
            children: professionalTitles.map((title) {
              return CheckboxListTile(
                dense: true,
                title: Text(title['label'] ?? ''),
                subtitle: title['subtitle']!.isNotEmpty ? Text(title['subtitle']!) : null,
                value: selectedTitles.value.contains(title['label']!),
                onChanged: (bool? value) {
                  final newList = List<String>.from(selectedTitles.value);
                  if (value == true) {
                    newList.add(title['label']!);
                  } else {
                    newList.remove(title['label']);
                  }
                  selectedTitles.value = newList;
                  final updatedTherapyPreferences = (userProfileFormState.therapyPreferences)?.copyWith(
                    professionalType: selectedTitles.value.join(', '),
                  );

                  userProfileForm.updateField(
                    userProfileFormState.copyWith(therapyPreferences: updatedTherapyPreferences),
                  );
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
    );
  }
}
