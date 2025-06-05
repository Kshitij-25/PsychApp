import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../data/local_data_source/expertise_data.dart';
import '../../../../data/models/professional_profile_data/education_history_model.dart';
import '../../../../data/models/professional_profile_data/professional_profile_model.dart';
import '../../../notifiers/psychologist_profile_creation_notifier.dart';
import '../../../widgets/multi_select_widget.dart';

class EducationalBackground extends StatelessWidget {
  const EducationalBackground({
    super.key,
    required this.formKey,
    required this.graduationDateController,
    required this.highestDegreeController,
    required this.institutionNameController,
    required this.professionalProfileProvider,
    required this.professionalformState,
  });

  final ValueNotifier<GlobalKey<FormState>> formKey;
  final TextEditingController highestDegreeController;
  final TextEditingController institutionNameController;
  final TextEditingController graduationDateController;
  final PsychologistProfileCreationNotifier professionalProfileProvider;
  final ProfessionalProfileModel professionalformState;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey.value, // Ensure you're wrapping this in a Form
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildSectionHeader(context, 'Educational Background'),
          const SizedBox(height: 20),

          // ✅ Highest Degree Obtained (Validation Added)
          TextFormField(
            controller: highestDegreeController,
            decoration: const InputDecoration(
              labelText: 'Highest Degree Obtained*',
              border: OutlineInputBorder(),
            ),
            textInputAction: TextInputAction.next,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter your highest degree obtained';
              }
              return null;
            },
            onTapOutside: (event) => FocusScope.of(context).unfocus(),
          ),
          const SizedBox(height: 10),

          // ✅ Institution Name (Validation Added)
          TextFormField(
            controller: institutionNameController,
            decoration: const InputDecoration(
              labelText: 'Institution Name*',
              border: OutlineInputBorder(),
            ),
            textInputAction: TextInputAction.next,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter the name of your institution';
              }
              return null;
            },
            onTapOutside: (event) => FocusScope.of(context).unfocus(),
          ),
          const SizedBox(height: 10),

          // ✅ Year of Graduation (Validation Added)
          TextFormField(
            controller: graduationDateController,
            decoration: const InputDecoration(
              labelText: 'Year of Graduation*',
              border: OutlineInputBorder(),
              suffixIcon: Icon(Icons.calendar_today),
            ),
            textInputAction: TextInputAction.next,
            readOnly: true,
            validator: (value) {
              if (graduationDateController.text.isEmpty) {
                return 'Please select your year of graduation';
              }
              return null;
            },
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
            onTapOutside: (event) => FocusScope.of(context).unfocus(),
            onTap: () async {
              final date = await showDialog<DateTime>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Select Year'),
                  content: SizedBox(
                    width: 300,
                    height: 300,
                    child: YearPicker(
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                      selectedDate: DateTime.now(),
                      onChanged: (DateTime dateTime) {
                        Navigator.pop(context, dateTime);
                      },
                    ),
                  ),
                ),
              );
              if (date != null) {
                // ✅ Update the text field with the selected year
                graduationDateController.text = DateFormat('yyyy').format(date);

                // ✅ Update the professional form state
                professionalProfileProvider.updateField(
                  professionalformState.copyWith(
                    educationHistory: [
                      ...?professionalformState.educationHistory,
                      EducationHistoryModel(graduationYear: date.year),
                    ],
                  ),
                );
              }
            },
          ),
          const SizedBox(height: 20),

          // ✅ Specializations (MultiSelectChip with Validation)
          Consumer(
            builder: (context, ref, _) {
              // Extract specializationsList from the education history
              final selectedSpecializations =
                  professionalformState.educationHistory?.expand((edu) => edu.specializationsList ?? []).toList().cast<String>() ?? [];

              return FormField<List<String>>(
                initialValue: selectedSpecializations,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select at least one specialization';
                  }
                  return null;
                },
                builder: (state) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MultiSelectChip(
                      title: 'Select Specializations*',
                      options: specializationFilters.map((filter) => filter['label']!).toList(),
                      selectedValues: selectedSpecializations,
                      onSelectionChanged: (selectedList) {
                        // Update the specializationsList in the first education history record
                        final updatedEducationHistory =
                            (professionalformState.educationHistory ?? []).map((edu) => edu.copyWith(specializationsList: selectedList)).toList();

                        ref.read(psychologistProfileFormProvider.notifier).updateField(
                              professionalformState.copyWith(educationHistory: updatedEducationHistory),
                            );

                        state.didChange(selectedList); // Trigger validation
                      },
                    ),
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
              );
            },
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
