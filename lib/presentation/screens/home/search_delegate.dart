import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../data/firebase_models/psychologist_model.dart';
import '../profile/therapist_profile_screen.dart';
import '../search/widgets/psychologists_card.dart';

class PsychologistSearchDelegate extends SearchDelegate<String> {
  final List<PsychologistModel> psychologistsData;

  PsychologistSearchDelegate(this.psychologistsData);

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final filteredPsychologists = psychologistsData.where((psychologist) {
      return psychologist.fullName!.toLowerCase().contains(query.toLowerCase()) ||
          psychologist.specialization!.toLowerCase().contains(
                query.toLowerCase(),
              );
    }).toList();

    return ListView.builder(
      itemCount: filteredPsychologists.length,
      itemBuilder: (context, index) {
        final psychologist = filteredPsychologists[index];
        return PsychologistsCard(
          psychologistsData: psychologist,
          onTap: () {
            context.pop();
            context.pushNamed(
              TherapistProfileScreen.routeName,
              extra: psychologist,
            );
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          body: Center(
            child: Text('Search for Psychologists'),
          ),
        ),
      );
    }

    final filteredPsychologists = psychologistsData.where((psychologist) {
      return (psychologist.fullName != null && psychologist.fullName!.toLowerCase().contains(query.toLowerCase())) ||
          psychologist.specialization!.toLowerCase().contains(
                query.toLowerCase(),
              );
    }).toList();

    return ListView.builder(
      itemCount: filteredPsychologists.length,
      itemBuilder: (context, index) {
        final psychologist = filteredPsychologists[index];
        return PsychologistsCard(
          psychologistsData: psychologist,
          onTap: () {
            context.pop();
            context.pushNamed(
              TherapistProfileScreen.routeName,
              extra: psychologist,
            );
          },
        );
      },
    );
  }

  @override
  ThemeData appBarTheme(BuildContext context) {
    return Theme.of(context).copyWith(
      appBarTheme: Theme.of(context).appBarTheme.copyWith(
            backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
          ),
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Theme.of(context).colorScheme.secondary,
            ),
        isDense: true,
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
        ),
      ),
      textTheme: TextTheme(
        headlineMedium: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: Theme.of(context).colorScheme.primary,
            ),
      ),
    );
  }
}
