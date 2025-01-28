import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../data/local_data_source/psychologists_type.dart';
import '../../../data/models/psychologist_model.dart';
import '../../../shared/constants/firebase_helper.dart';
import '../home/home_navigator.dart';
import '../profile/therapist_profile_screen.dart';
import 'widgets/psychologists_card.dart';

final selectedFilterProvider = StateProvider<String>((ref) => "recommended");

class TherapistSearchScreen extends HookConsumerWidget {
  const TherapistSearchScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final psychologistsData = ref.watch(psychologistProvider);
    final selectedFilter = ref.watch(selectedFilterProvider);

    return Column(
      children: [
        _buildFilterBar(context, ref),
        SizedBox(height: 10),
        StreamBuilder<QuerySnapshot>(
          stream: FirebaseHelper.streamDocuments('psychologist'),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(child: Text('No psychologists found'));
            }

            // Convert snapshot to a list of documents
            final psychologistsData = snapshot.data!.docs.map((doc) {
              // return doc.data() as Map<String, dynamic>;
              return PsychologistModel.fromJson(doc.data() as Map<String, dynamic>);
            }).toList();

            // Filter data based on selectedFilter
            final filteredData = psychologistsData.where((psychologist) {
              if (selectedFilter == "recommended") return true;
              if ((psychologist.specialization as List<dynamic>).contains(selectedFilter)) {
                return true;
              }
              return false;
            }).toList();

            return Expanded(
              child: ListView.builder(
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
              ),
            );
          },
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
