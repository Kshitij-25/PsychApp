import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../data/local_data_source/psychologists_type.dart';
import '../../../data/models/psychologist_model.dart';
import '../../../shared/constants/firebase_helper.dart';
import '../profile/therapist_profile_screen.dart';
import 'widgets/psychologists_card.dart';

final selectedFilterProvider = StateProvider<String>((ref) => "recommended");

final psychologistStreamProvider = StreamProvider<List<PsychologistModel>>((ref) {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    throw Exception('User not authenticated');
  }

  return FirebaseHelper.streamDocuments('psychologist').map((snapshot) {
    return snapshot.docs.map((doc) => PsychologistModel.fromJson(doc.data() as Map<String, dynamic>)).toList();
  });
});

class TherapistSearchScreen extends HookConsumerWidget {
  const TherapistSearchScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedFilter = ref.watch(selectedFilterProvider);

    return Column(
      children: [
        _buildFilterBar(context, ref),
        SizedBox(height: 10),
        ref.watch(psychologistStreamProvider).when(
              data: (psychologistsData) {
                // Helper function to normalize strings for comparison
                String normalizeString(String input) {
                  return input
                      .toLowerCase()
                      .replaceAll('-', '_') // Convert hyphens to underscores
                      .replaceAll(' ', '_'); // Convert spaces to underscores
                }

                // In your filter logic
                final filteredData = psychologistsData.where((psychologist) {
                  if (selectedFilter == "recommended") return true;

                  final userInput = normalizeString(selectedFilter);
                  final specialization = psychologist.specialization;

                  if (specialization != null) {
                    final specializationList = specialization is List<dynamic> ? specialization : [specialization];
                    return (specializationList as List<dynamic>).map((e) => normalizeString(e.toString())).contains(userInput);
                  }
                  return false;
                }).toList();

                return Expanded(
                  child: filteredData.isNotEmpty
                      ? ListView.builder(
                          itemCount: filteredData.length,
                          itemBuilder: (context, index) {
                            return PsychologistsCard(
                              psychologistsData: filteredData[index],
                              onTap: () {
                                context.pushNamed(
                                  TherapistProfileScreen.routeName,
                                  extra: filteredData[index],
                                );
                              },
                            );
                          },
                        )
                      : Center(
                          child: Text('No psychologists found'),
                        ),
                );
              },
              loading: () => Center(
                child: CircularProgressIndicator(),
              ),
              error: (error, stackTrace) => Center(
                child: Text('Error: ${error.toString()}'),
              ),
            ),
      ],
    );
  }
}

Widget _buildFilterBar(BuildContext context, WidgetRef ref) {
  final selectedFilter = ref.watch(selectedFilterProvider);
  return Row(
    spacing: 5,
    children: [
      IconButton.filled(
        onPressed: () {},
        icon: Icon(
          Icons.tune,
          color: Theme.of(context).colorScheme.onPrimaryFixed,
        ),
        style: IconButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.primaryFixed,
        ),
      ),
      Expanded(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: specializationFilters
                .map(
                  (filter) => _FilterChipButton(
                    label: filter["label"] ?? "",
                    value: filter["value"] ?? "",
                    isSelected: selectedFilter == filter["value"],
                    onTap: () {
                      ref.read(selectedFilterProvider.notifier).state = filter["value"] ?? "";
                    },
                  ),
                )
                .toList(),
          ),
        ),
      ),
    ],
  );
}

class _FilterChipButton extends StatelessWidget {
  final String label;
  final String value;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChipButton({
    Key? key,
    required this.label,
    required this.value,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Theme.of(context).colorScheme.primaryContainer : Theme.of(context).colorScheme.primaryFixed,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Theme.of(context).colorScheme.onPrimaryContainer : Theme.of(context).colorScheme.onPrimaryFixed,
          ),
        ),
      ),
    );
  }
}
