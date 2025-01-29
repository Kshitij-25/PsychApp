import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../data/models/journal_entry.dart';
import '../../notifiers/journal_notifier.dart';
import 'create_journal_screen.dart';
import 'journal_delegate.dart';
import 'widget/journal_card.dart';

class JournalScreen extends HookConsumerWidget {
  static const routeName = '/journalScreen';
  const JournalScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final journals = ref.watch(journalProvider);

    Map<String, List<JournalEntry>> _categorizeJournals(List<JournalEntry> journals) {
      final now = DateTime.now();
      final categorizedJournals = <String, List<JournalEntry>>{};

      // Sort journals by most recent first
      journals.sort((a, b) => b.updatedAt!.compareTo(a.updatedAt!));

      for (final journal in journals) {
        final entryDate = journal.updatedAt;
        final difference = now.difference(entryDate!);

        String category;
        if (entryDate.isAfter(now.subtract(const Duration(days: 1)))) {
          category = 'Today';
        } else if (entryDate.isAfter(now.subtract(const Duration(days: 30)))) {
          category = 'Previous 30 Days';
        } else if (entryDate.year == now.year) {
          category = 'This Year';
        } else {
          category = 'Previous Years';
        }

        categorizedJournals.putIfAbsent(category, () => []).add(journal);
      }

      return categorizedJournals;
    }

    final categorizedJournals = _categorizeJournals(journals);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        forceMaterialTransparency: true,
        centerTitle: false,
        title: Text(
          'Journal',
          textAlign: TextAlign.start,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              showSearch(
                context: context,
                delegate: JournalSearchDelegate(journals),
              );
            },
            icon: const Icon(CupertinoIcons.search),
          ),
        ],
      ),
      body: journals.isEmpty
          ? const Center(child: Text('No Entries'))
          : ListView.builder(
              itemCount: categorizedJournals.length,
              itemBuilder: (context, categoryIndex) {
                final category = categorizedJournals.keys.elementAt(categoryIndex);
                final categoryJournals = categorizedJournals[category]!;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        category,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                    ...categoryJournals.map(
                      (journal) => JournalCard(
                        journal: journal,
                        onDismissed: (direction) async {
                          await ref.read(journalProvider.notifier).deleteJournal(journal.id!);
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(width: 40),
            Text('${journals.length} ${journals.length == 1 ? "Entry" : "Entries"}'),
            IconButton(
              onPressed: () => context.pushNamed(CreateJournalScreen.routeName),
              icon: const Icon(FontAwesomeIcons.penToSquare),
            ),
          ],
        ),
      ),
    );
  }
}
