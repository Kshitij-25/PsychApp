import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:psych_app/data/models/journal_entry.dart';

import '../../notifiers/journal_notifier.dart';
import 'widget/journal_card.dart';

class JournalSearchDelegate extends SearchDelegate<String> {
  final List<JournalEntry> journalEntry;

  JournalSearchDelegate(this.journalEntry);

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
    final filteredJournalEntry = journalEntry.where((journal) {
      return (journal.title?.toLowerCase().contains(query.toLowerCase()) ?? false) ||
          (journal.subTitle?.toLowerCase().contains(query.toLowerCase()) ?? false) ||
          (journal.content?.toLowerCase().contains(query.toLowerCase()) ?? false);
    }).toList();

    return ListView.builder(
      itemCount: filteredJournalEntry.length,
      itemBuilder: (context, index) {
        final journal = filteredJournalEntry[index];
        return Consumer(
          builder: (context, ref, _) {
            return JournalCard(
              journal: journal,
              onDismissed: (direction) {
                ref.read(journalProvider.notifier).deleteJournal(journal.id!);
              },
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
            child: Text('Search for Journal Entries'),
          ),
        ),
      );
    }

    final filteredJournalEntry = journalEntry.where((journal) {
      return (journal.title?.toLowerCase().contains(query.toLowerCase()) ?? false) ||
          (journal.subTitle?.toLowerCase().contains(query.toLowerCase()) ?? false) ||
          (journal.content?.toLowerCase().contains(query.toLowerCase()) ?? false);
    }).toList();

    return ListView.builder(
      itemCount: filteredJournalEntry.length,
      itemBuilder: (context, index) {
        final journal = filteredJournalEntry[index];
        return Consumer(
          builder: (context, ref, _) {
            return JournalCard(
              journal: journal,
              onDismissed: (direction) {
                ref.read(journalProvider.notifier).deleteJournal(journal.id!);
              },
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
