import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../data/local_data_source/expertise_data.dart';
import '../../../../data/models/professional_profile_data/experience_model.dart';
import '../../../../data/models/professional_profile_data/professional_profile_model.dart';
import '../../../notifiers/psychologist_profile_creation_notifier.dart';
import '../../../widgets/multi_select_widget.dart';

class PreofessionalExperience extends StatelessWidget {
  const PreofessionalExperience({
    super.key,
    required this.formKey,
    required this.coupleTherapy,
    required this.experienceController,
    required this.languageController,
    required this.professionalformState,
  });

  final ValueNotifier<GlobalKey<FormState>> formKey;
  final TextEditingController experienceController;
  final TextEditingController languageController;
  final ProfessionalProfileModel professionalformState;
  final ValueNotifier<bool> coupleTherapy;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey.value,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildSectionHeader(context, 'Professional Experience'),
          SizedBox(height: 20),
          TextFormField(
            controller: experienceController,
            decoration: const InputDecoration(
              labelText: 'Years of Experience in Mental Health Practice*',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.next,
            onTapOutside: (event) => FocusScope.of(context).unfocus(),
            validator: (value) {
              if (experienceController.text.isEmpty) {
                return 'Please enter your years of experience';
              }
              return null;
            },
          ),
          SizedBox(height: 10),
          TextFormField(
            controller: languageController,
            decoration: const InputDecoration(
              labelText: 'Languages Spoken* (Separate with " , ")',
              border: OutlineInputBorder(),
            ),
            textInputAction: TextInputAction.next,
            onTapOutside: (event) => FocusScope.of(context).unfocus(),
            validator: (value) {
              if (languageController.text.isEmpty) {
                return 'Please enter at least one language';
              }
              return null;
            },
          ),
          SizedBox(height: 10),
          // ✅ Areas of Expertise Validation
          // ✅ Areas of Expertise Validation
          FormField<List<String>>(
            validator: (value) {
              if (professionalformState.experience?.expertiseAreas == null || professionalformState.experience!.expertiseAreas!.isEmpty) {
                return 'Please select at least one area of expertise';
              }
              return null;
            },
            builder: (state) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Consumer(builder: (context, ref, _) {
                  return MultiSelectChip(
                    title: 'Areas of Expertise*',
                    options: expertiseFilters.map((filter) => filter['label']!).toList(),
                    selectedValues: professionalformState.experience?.expertiseAreas ?? [],
                    onSelectionChanged: (selectedList) {
                      // ✅ Preserve existing data when updating
                      final currentExperience = professionalformState.experience ?? ExperienceModel();
                      ref.read(psychologistProfileFormProvider.notifier).updateField(
                            professionalformState.copyWith(
                              experience: currentExperience.copyWith(
                                expertiseAreas: selectedList,
                              ),
                            ),
                          );
                      state.didChange(selectedList); // Trigger validation
                    },
                  );
                }),
                if (state.hasError)
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Text(
                      state.errorText!,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.error,
                          ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 10),

// ✅ Preferred Age Group Validation
          FormField<List<String>>(
            validator: (value) {
              if (professionalformState.experience?.preferredAgeGroups == null || professionalformState.experience!.preferredAgeGroups!.isEmpty) {
                return 'Please select at least one preferred age group';
              }
              return null;
            },
            builder: (state) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Consumer(builder: (context, ref, _) {
                  return MultiSelectChip(
                    title: 'Preferred Age Group to Work With*',
                    options: preferredAgeGroup.map((filter) => filter['label']!).toList(),
                    selectedValues: professionalformState.experience?.preferredAgeGroups ?? [],
                    onSelectionChanged: (selectedList) {
                      // ✅ Preserve existing data when updating
                      final currentExperience = professionalformState.experience ?? ExperienceModel();
                      ref.read(psychologistProfileFormProvider.notifier).updateField(
                            professionalformState.copyWith(
                              experience: currentExperience.copyWith(
                                preferredAgeGroups: selectedList,
                              ),
                            ),
                          );
                      state.didChange(selectedList); // Trigger validation
                    },
                  );
                }),
                if (state.hasError)
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Text(
                      state.errorText!,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.error,
                          ),
                    ),
                  ),
              ],
            ),
          ),
          SizedBox(height: 10),
          CheckboxListTile.adaptive(
            dense: true,
            value: coupleTherapy.value,
            checkboxScaleFactor: 1.5,
            onChanged: (value) {
              coupleTherapy.value = value!;
            },
            contentPadding: EdgeInsets.symmetric(horizontal: 0),
            title: Text('Do you offer therapy for couples or groups?'),
          ),
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
