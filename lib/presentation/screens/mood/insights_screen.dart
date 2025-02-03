import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

import '../../../services/moods/mood_storage.dart';
import '../../../shared/constants/assets.dart';
import '../../widgets/mood_chart.dart';

class InsightsScreen extends StatefulHookConsumerWidget {
  const InsightsScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _InsightsScreenState();
}

class _InsightsScreenState extends ConsumerState<InsightsScreen> {
  late DateTime _selectedWeek;
  late Future<Map<DateTime, Map<String, dynamic>>> _moodsFuture;
  final moodStorage = MoodStorage();

  @override
  void initState() {
    super.initState();
    _selectedWeek = _getStartOfWeek(DateTime.now()); // Start with the beginning of current week
    _moodsFuture = moodStorage.loadSavedData();
  }

  DateTime _getStartOfWeek(DateTime date) {
    // Calculate the start of week (Monday)
    final difference = date.weekday - DateTime.monday;
    return DateTime(date.year, date.month, date.day).subtract(Duration(days: difference));
  }

  String _getWeekIdentifier(DateTime date) {
    final weekNumber = ((date.difference(DateTime(date.year, 1, 1)).inDays) / 7).ceil();
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-W$weekNumber';
  }

  Map<String, DateTime> _getWeekRange(DateTime date) {
    final startOfWeek = _getStartOfWeek(date);
    // End of week is the start of next week minus 1 millisecond
    final endOfWeek = _getStartOfWeek(date.add(const Duration(days: 7))).subtract(const Duration(milliseconds: 1));

    return {'start': startOfWeek, 'end': endOfWeek};
  }

  Future<Map<String, List<Map<String, dynamic>>>> _loadMoodsGroupedByWeek() async {
    final data = await _moodsFuture;
    final groupedMoods = <String, List<Map<String, dynamic>>>{};

    for (final entry in data.entries) {
      final date = entry.key;
      final mood = entry.value['mood'] as String?;
      final chips = entry.value['chips'] as List<String>? ?? [];

      if (mood == null) continue;

      final weekId = _getWeekIdentifier(date);

      groupedMoods.putIfAbsent(weekId, () => []);
      groupedMoods[weekId]?.add({
        'date': DateFormat('MMM dd, yyyy').format(date),
        'mood': mood,
        'chips': chips,
      });
    }

    return groupedMoods;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildWeekSelector(context),
        const SizedBox(height: 16),
        Expanded(
          child: FutureBuilder<Map<DateTime, Map<String, dynamic>>>(
            future: _moodsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    'Error loading data: ${snapshot.error}',
                    textAlign: TextAlign.center,
                  ),
                );
              }

              final data = snapshot.data;
              if (data == null || data.isEmpty) {
                return const Center(
                  child: Text(
                    'No moods recorded yet.\nStart tracking your moods to see insights!',
                    textAlign: TextAlign.center,
                  ),
                );
              }

              return SafeArea(
                bottom: true,
                child: CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: _buildWeeklySummary(data),
                    ),
                    SliverToBoxAdapter(
                      child: _buildMoodList(data),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildWeekSelector(BuildContext context) {
    final weekRange = _getWeekRange(_selectedWeek);
    final isCurrentWeek = _selectedWeek.isAtSameMomentAs(_getStartOfWeek(DateTime.now()));

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left),
            style: IconButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
              shape: const CircleBorder(),
            ),
            onPressed: () => setState(() {
              _selectedWeek = _selectedWeek.subtract(const Duration(days: 7));
            }),
          ),
          Column(
            children: [
              Text(
                DateFormat('MMMM yyyy').format(weekRange['start']!),
                style: Theme.of(context).textTheme.titleSmall,
              ),
              Text(
                '${DateFormat('MMM d').format(weekRange['start']!)} - ${DateFormat('MMM d').format(weekRange['end']!)}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            style: IconButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
              shape: const CircleBorder(),
            ),
            onPressed: isCurrentWeek
                ? null
                : () => setState(() {
                      _selectedWeek = _selectedWeek.add(const Duration(days: 7));
                    }),
          ),
        ],
      ),
    );
  }

  Widget _buildMoodList(Map<DateTime, Map<String, dynamic>> data) {
    return FutureBuilder<Map<String, List<Map<String, dynamic>>>>(
      future: _loadMoodsGroupedByWeek(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final weekRange = _getWeekRange(_selectedWeek);
        final weekStart = weekRange['start']!;
        final weekEnd = weekRange['end']!;

        // Filter data for the exact week
        final weekMoods = data.entries
            .where((entry) {
              final entryDate = DateTime(
                entry.key.year,
                entry.key.month,
                entry.key.day,
              );
              return entryDate.isAtSameMomentAs(weekStart) ||
                  (entryDate.isAfter(weekStart) && entryDate.isBefore(weekEnd)) ||
                  entryDate.isAtSameMomentAs(weekEnd);
            })
            .map((entry) => {
                  'date': DateFormat('MMM dd, yyyy').format(entry.key),
                  'mood': entry.value['mood'],
                  'chips': entry.value['chips'] ?? <String>[],
                })
            .toList();

        if (weekMoods.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Text('No detailed mood data for this week.'),
          );
        }

        // Sort entries by date
        weekMoods
            .sort((a, b) => DateFormat('MMM dd, yyyy').parse(a['date'] as String).compareTo(DateFormat('MMM dd, yyyy').parse(b['date'] as String)));

        return ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: weekMoods.length,
          itemBuilder: (context, index) {
            final entry = weekMoods[index];
            final chips = (entry['chips'] as List<String>?) ?? [];
            return ExpansionTile(
              enableFeedback: true,
              dense: true,
              expandedAlignment: Alignment.centerLeft,
              shape: const RoundedRectangleBorder(side: BorderSide.none),
              title: Text(entry['date'] ?? 'Unknown Date'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (entry['mood'] != null)
                    Row(
                      children: [
                        const Text('Mood: '),
                        Text(
                          entry['mood']![0].toUpperCase() + entry['mood']!.substring(1),
                          style: TextStyle(
                            color: entry['mood']! == 'happy'
                                ? Colors.green
                                : entry['mood']! == 'neutral'
                                    ? Colors.purple
                                    : Colors.blue,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
              leading: Lottie.asset(
                entry['mood'] == 'happy'
                    ? Assets.happy
                    : entry['mood'] == 'neutral'
                        ? Assets.neutral
                        : Assets.sad,
                height: 50,
                width: 50,
              ),
              children: [
                if (chips.isNotEmpty)
                  Wrap(
                    spacing: 8.0,
                    children: chips.map((chip) {
                      return Chip(
                        side: BorderSide.none,
                        visualDensity: VisualDensity.compact,
                        label: Text(chip.replaceAll('_', ' ').split(' ').map((word) {
                          return word[0].toUpperCase() + word.substring(1).toLowerCase();
                        }).join(' ')),
                        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                        labelStyle: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimaryContainer,
                        ),
                      );
                    }).toList(),
                  ),
              ],
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return Divider(thickness: 0.3);
          },
        );
      },
    );
  }

  Widget _buildWeeklySummary(Map<DateTime, Map<String, dynamic>> data) {
    final weekRange = _getWeekRange(_selectedWeek);
    final weekStart = weekRange['start']!;
    final weekEnd = weekRange['end']!;

    final weekData = data.entries.where((entry) {
      final entryDate = DateTime(
        entry.key.year,
        entry.key.month,
        entry.key.day,
      );
      return entryDate.isAtSameMomentAs(weekStart) ||
          (entryDate.isAfter(weekStart) && entryDate.isBefore(weekEnd)) ||
          entryDate.isAtSameMomentAs(weekEnd);
    }).toList();

    if (weekData.isEmpty) {
      return Card(
        margin: const EdgeInsets.all(16),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Center(
            child: Text(
              'No data recorded for this week',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
        ),
      );
    }

    final moodCounts = _calculateMoodCounts(weekData);
    final chipCounts = _calculateChipCounts(weekData);
    final comparisonText = _generateComparisonText(data, weekRange);

    return Card(
      color: Theme.of(context).colorScheme.surfaceContainerLowest,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Weekly Summary',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            if (moodCounts.isNotEmpty) ...[
              Center(
                child: MoodDonutChart(
                  moodCounts: moodCounts,
                  size: 150,
                  strokeWidth: 20,
                ),
              ),
              const SizedBox(height: 16),
            ],
            if (comparisonText.isNotEmpty) ...[
              Text(
                comparisonText,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
            ],
            if (chipCounts.isNotEmpty) ...[
              Text(
                'Top Feelings',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: chipCounts.entries
                    .sorted((a, b) => b.value.compareTo(a.value))
                    .take(3)
                    .map((entry) => Chip(
                          side: BorderSide.none,
                          label: Text(entry.key.replaceAll('_', ' ').split(' ').map((word) {
                            return word[0].toUpperCase() + word.substring(1).toLowerCase();
                          }).join(' ')),
                          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                          labelStyle: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimaryContainer,
                          ),
                        ))
                    .toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Map<String, int> _calculateMoodCounts(List<MapEntry<DateTime, Map<String, dynamic>>> weekData) {
    final moodCounts = <String, int>{};
    for (var entry in weekData) {
      final mood = entry.value['mood'] as String?;
      if (mood != null) {
        moodCounts[mood] = (moodCounts[mood] ?? 0) + 1;
      }
    }
    return moodCounts;
  }

  Map<String, int> _calculateChipCounts(List<MapEntry<DateTime, Map<String, dynamic>>> weekData) {
    final chipCounts = <String, int>{};
    for (var entry in weekData) {
      final chips = (entry.value['chips'] as List<String>?) ?? [];
      for (var chip in chips) {
        chipCounts[chip] = (chipCounts[chip] ?? 0) + 1;
      }
    }
    return chipCounts;
  }

  String _generateComparisonText(Map<DateTime, Map<String, dynamic>> data, Map<String, DateTime> currentWeekRange) {
    final currentWeekStart = currentWeekRange['start']!;
    final currentWeekEnd = currentWeekRange['end']!;

    final lastWeekStart = _getStartOfWeek(currentWeekStart.subtract(const Duration(days: 7)));
    final lastWeekEnd = currentWeekStart.subtract(const Duration(milliseconds: 1));

    // Filter data for current week
    final currentWeekData = data.entries.where((entry) {
      final entryDate = DateTime(
        entry.key.year,
        entry.key.month,
        entry.key.day,
      );
      return entryDate.isAtSameMomentAs(currentWeekStart) ||
          (entryDate.isAfter(currentWeekStart) && entryDate.isBefore(currentWeekEnd)) ||
          entryDate.isAtSameMomentAs(currentWeekEnd);
    }).toList();

    // Filter data for previous week
    final lastWeekData = data.entries.where((entry) {
      final entryDate = DateTime(
        entry.key.year,
        entry.key.month,
        entry.key.day,
      );
      return entryDate.isAtSameMomentAs(lastWeekStart) ||
          (entryDate.isAfter(lastWeekStart) && entryDate.isBefore(lastWeekEnd)) ||
          entryDate.isAtSameMomentAs(lastWeekEnd);
    }).toList();

    if (lastWeekData.isEmpty || currentWeekData.isEmpty) return '';

    final currentWeekMoods = _calculateMoodCounts(currentWeekData);
    final lastWeekMoods = _calculateMoodCounts(lastWeekData);

    if (currentWeekMoods.isEmpty) return '';

    final dominantMood = currentWeekMoods.entries.reduce((a, b) => a.value > b.value ? a : b).key;

    // Compare with last week
    final lastWeekCount = lastWeekMoods[dominantMood] ?? 0;
    final currentWeekCount = currentWeekMoods[dominantMood] ?? 0;

    if (currentWeekCount > lastWeekCount) {
      return 'You\'re in a $dominantMood mood more often this week compared to last week.';
    } else if (currentWeekCount < lastWeekCount) {
      return 'You\'re in a $dominantMood mood less often this week compared to last week.';
    } else {
      return 'Your $dominantMood mood frequency is similar to last week.';
    }
  }
}
