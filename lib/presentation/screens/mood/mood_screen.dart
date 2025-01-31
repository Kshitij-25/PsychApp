import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:psych_app/data/local_data_source/mood_states.dart';
import 'package:psych_app/presentation/widgets/custom_elevated_button.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../services/moods/mood_storage.dart';
import '../../../shared/constants/assets.dart';
import '../../../shared/constants/firebase_helper.dart';

final selectedMoodsStateProvider = StateProvider<Set<String>>((ref) => {});

class MoodScreen extends HookConsumerWidget {
  MoodScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final moods = useState<Map<DateTime, String>>({});
    final selectedMood = useState<String?>(null);
    final moodStorage = MoodStorage();

    useEffect(() {
      moodStorage.loadMoods(FirebaseHelper.currentUserId!).then((loadedMoods) {
        moods.value = loadedMoods.map(
          (key, value) => MapEntry(DateTime.parse(key), value),
        );
      });
      return null;
    }, []);

    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerLowest,
              border: Border.all(
                color: Theme.of(context).colorScheme.scrim,
                width: 0.1,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: TableCalendar(
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              focusedDay: DateTime.now(),
              calendarStyle: CalendarStyle(
                outsideDaysVisible: true,
                todayDecoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.outline,
                  shape: BoxShape.circle,
                ),
              ),
              headerStyle: HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
              ),
              rowHeight: 100,
              calendarFormat: CalendarFormat.month,
              startingDayOfWeek: StartingDayOfWeek.monday,
              calendarBuilders: CalendarBuilders(
                markerBuilder: (context, day, events) {
                  final mood = moods.value[day];
                  if (mood != null) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 30.0),
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Lottie.asset(
                          mood == 'happy'
                              ? Assets.happy
                              : mood == 'neutral'
                                  ? Assets.neutral
                                  : Assets.sad,
                          height: 30,
                          width: 30,
                        ),
                      ),
                    );
                  }
                  return null;
                },
              ),
              onDaySelected: (selectedDay, focusedDay) {
                _showMoodSelectionSheet(
                  context,
                  selectedDay,
                  moods,
                  ref,
                  selectedMood,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showMoodSelectionSheet(
    BuildContext context,
    DateTime selectedDay,
    ValueNotifier<Map<DateTime, String>> moods,
    WidgetRef ref,
    ValueNotifier<String?> selectedMood,
  ) {
    // Initialize MoodStorage
    final moodStorage = MoodStorage();
    // Get current user's UID - you'll need to have access to this
    final String? uid = FirebaseHelper.currentUserId;
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        final formattedDateTime = DateFormat('MMM dd, yyyy').format(selectedDay);
        final selectedMoodsState = ref.watch(selectedMoodsStateProvider);

        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setSheetState) {
            String currentOverallMood = moodStorage.determineOverallMoodLocally(selectedMoodsState);

            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      formattedDateTime,
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    Lottie.asset(
                      selectedMoodsState.isEmpty
                          ? Assets.neutral // Show neutral if no mood is selected
                          : currentOverallMood == 'happy'
                              ? Assets.happy
                              : currentOverallMood == 'sad'
                                  ? Assets.sad
                                  : Assets.neutral, // Default to neutral in case of an unknown mood
                      height: 150,
                      width: 150,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Which words describe your feelings best?',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 20),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 450,
                      child: SingleChildScrollView(
                        child: Wrap(
                          spacing: 8.0,
                          runSpacing: 8.0,
                          children: moodStates.map((filter) {
                            return _FilterChipButton(
                              label: filter["label"] ?? "",
                              value: filter["value"] ?? "",
                              isSelected: selectedMoodsState.contains(filter["value"]),
                              onTap: () {
                                setSheetState(() {
                                  if (selectedMoodsState.contains(filter["value"])) {
                                    selectedMoodsState.remove(filter["value"]);
                                  } else {
                                    selectedMoodsState.add(filter["value"]!);
                                  }
                                  ref.read(selectedMoodsStateProvider.notifier).state = selectedMoodsState;
                                  selectedMood.value = currentOverallMood;
                                });
                              },
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: CustomElevatedButton(
                            onPressed: () async {
                              await moodStorage.saveMood(
                                uid: uid!,
                                selectedDay: selectedDay,
                                currentMoods: selectedMoodsState,
                                moods: moods,
                              );

                              // Clear selected moods
                              ref.read(selectedMoodsStateProvider.notifier).state = {};
                              Navigator.pop(context);
                            },
                            buttonLabel: 'Save',
                            buttonStyle: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).buttonTheme.colorScheme!.primaryContainer,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
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
