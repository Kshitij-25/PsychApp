import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../data/local_data_source/expertise_data.dart';
import '../../../../data/models/professional_profile_data/professional_profile_model.dart';
import '../../../notifiers/psychologist_profile_creation_notifier.dart';
import '../../../widgets/multi_select_widget.dart';

class TherapyApproachTechniques extends StatelessWidget {
  const TherapyApproachTechniques({
    super.key,
    required this.formKey,
    required this.approachOfTherapyController,
    required this.crisisIntervention,
    required this.professionalformState,
  });

  final ValueNotifier<GlobalKey<FormState>> formKey;
  final ProfessionalProfileModel professionalformState;
  final ValueNotifier<bool> crisisIntervention;
  final TextEditingController approachOfTherapyController;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey.value,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildSectionHeader(context, 'Therapy Approach & Techniques'),
          SizedBox(height: 20),
          // ✅ Therapeutic Modalities Validation
          FormField<List<String>>(
            validator: (value) {
              if (professionalformState.therapeuticModalities == null || professionalformState.therapeuticModalities!.isEmpty) {
                return 'Please select at least one therapeutic modality';
              }
              return null;
            },
            builder: (state) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Consumer(builder: (context, ref, _) {
                  return MultiSelectChip(
                    title: 'Therapeutic Modalities Practiced*',
                    options: modalitiesPracticed.map((filter) => filter['label']!).toList(),
                    selectedValues: professionalformState.therapeuticModalities ?? [],
                    onSelectionChanged: (selectedList) {
                      ref.read(psychologistProfileFormProvider.notifier).updateField(
                            professionalformState.copyWith(therapeuticModalities: selectedList),
                          );
                      state.didChange(selectedList); // ✅ Trigger validation
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
            value: crisisIntervention.value,
            checkboxScaleFactor: 1.5,
            onChanged: (value) {
              crisisIntervention.value = value!;
            },
            contentPadding: EdgeInsets.symmetric(horizontal: 0),
            title: Text('Do you offer crisis intervention support?'),
          ),
          SizedBox(height: 10),
          TextFormField(
            controller: approachOfTherapyController,
            maxLines: 5,
            decoration: const InputDecoration(
              hintText: 'Describe your approach to therapy in a few sentences: (Optional)',
              border: OutlineInputBorder(),
            ),
            textInputAction: TextInputAction.next,
            onTapOutside: (event) => FocusScope.of(context).unfocus(),
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
