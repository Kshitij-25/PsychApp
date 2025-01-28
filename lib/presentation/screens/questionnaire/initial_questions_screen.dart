import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../data/local_data_source/intial_questions.dart';
import '../../widgets/custom_elevated_button.dart';
import '../home/home_navigator.dart';

final selectedMyStateProvider = StateProvider.autoDispose<List<String>>((ref) => []);
final selectedRelationshipsProvider = StateProvider.autoDispose<List<String>>((ref) => []);
final selectedWorkStudyProvider = StateProvider.autoDispose<List<String>>((ref) => []);
final selectedHappeningsInLifeProvider = StateProvider.autoDispose<List<String>>((ref) => []);
final selectedTherapistGenderProvider = StateProvider.autoDispose<List<String>>((ref) => []);
final selectedSessionTimeProvider = StateProvider.autoDispose<List<String>>((ref) => []);

class InitialQuestionsScreen extends HookConsumerWidget {
  static const routeName = '/initialQuestionsScreen';
  const InitialQuestionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              _buildTextHeader(context),
              const SizedBox(height: 20),
              _CustomChoiceChipGroup(
                title: 'My State',
                items: myState,
                selectedStateProvider: selectedMyStateProvider,
              ),
              const SizedBox(height: 16),
              _CustomChoiceChipGroup(
                title: 'Relationships',
                items: relationships,
                selectedStateProvider: selectedRelationshipsProvider,
              ),
              const SizedBox(height: 16),
              _CustomChoiceChipGroup(
                title: 'Work, Study',
                items: workStudy,
                selectedStateProvider: selectedWorkStudyProvider,
              ),
              const SizedBox(height: 16),
              _CustomChoiceChipGroup(
                title: 'Happenings in life',
                items: happeningsInLife,
                selectedStateProvider: selectedHappeningsInLifeProvider,
              ),
              const SizedBox(height: 16),
              _CustomChoiceChipGroup(
                title: "Therapist's gender",
                items: therapistGender,
                selectedStateProvider: selectedTherapistGenderProvider,
              ),
              const SizedBox(height: 16),
              _CustomChoiceChipGroup(
                title: 'Session time',
                items: sessionTime,
                selectedStateProvider: selectedSessionTimeProvider,
              ),
              const SizedBox(height: 24),
              CustomElevatedButton(
                buttonLabel: 'Show Psychologists',
                onPressed: () {
                  // Navigate to the next screen or perform the desired action
                  context.go(HomeNavigator.routeName);
                },
                buttonStyle: ElevatedButton.styleFrom(
                  enableFeedback: true,
                  backgroundColor: Theme.of(context).buttonTheme.colorScheme!.primaryContainer,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextHeader(BuildContext context) {
    return Text(
      "What's troubling you?",
      textAlign: TextAlign.start,
      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
    );
  }
}

class _CustomChoiceChipGroup extends StatelessWidget {
  const _CustomChoiceChipGroup({
    Key? key,
    required this.title,
    required this.items,
    required this.selectedStateProvider,
  }) : super(key: key);

  final String title;
  final List<Map<String, String>> items;
  final AutoDisposeStateProvider<List<String>> selectedStateProvider;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          textAlign: TextAlign.start,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 8),
        Consumer(
          builder: (context, ref, child) {
            final selectedStates = ref.watch(selectedStateProvider);
            return Wrap(
              spacing: 8.0,
              children: items.map((item) {
                final isSelected = selectedStates.contains(item['value']);
                return ChoiceChip(
                  showCheckmark: false,
                  label: Text(
                    item['label']!,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(
                      color: isSelected ? Theme.of(context).colorScheme.primaryContainer : Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                  selected: isSelected,
                  selectedColor: Theme.of(context).colorScheme.primaryContainer,
                  onSelected: (bool selected) {
                    ref.read(selectedStateProvider.notifier).update((state) {
                      if (selected) {
                        return [...state, item['value']!];
                      } else {
                        return state.where((value) => value != item['value']).toList();
                      }
                    });
                  },
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }
}
