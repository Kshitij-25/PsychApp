import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../data/local_data_source/expertise_data.dart';
import '../../../../data/models/professional_profile_data/daily_availability.dart';
import '../../../../data/models/professional_profile_data/professional_profile_model.dart';
import '../../../notifiers/psychologist_profile_creation_notifier.dart';
import '../../../widgets/multi_select_widget.dart';

class AvailablitiyServices extends ConsumerWidget {
  const AvailablitiyServices({
    super.key,
    required this.formKey,
    required this.newClients,
    required this.professionalformState,
  });

  final ValueNotifier<GlobalKey<FormState>> formKey;
  final ProfessionalProfileModel professionalformState;
  final ValueNotifier<bool> newClients;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Form(
      key: formKey.value, // Make sure you're wrapping this in a Form for validation
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildSectionHeader(context, 'Availability & Services'),
          const SizedBox(height: 20),

          // ✅ Preferred Therapy Mode (Multi-select Validation)
          FormField<List<String>>(
            initialValue: professionalformState.therapeuticModalities ?? [],
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please select at least one therapy mode';
              }
              return null;
            },
            builder: (state) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MultiSelectChip(
                  title: 'Preferred Therapy Mode*',
                  options: therapyModes.map((filter) => filter['label']!).toList(),
                  selectedValues: professionalformState.therapeuticModalities ?? [],
                  onSelectionChanged: (selectedList) {
                    ref.read(psychologistProfileFormProvider.notifier).updateField(
                          professionalformState.copyWith(therapeuticModalities: selectedList),
                        );
                    state.didChange(selectedList); // Important for validation
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
          ),
          const SizedBox(height: 10),

          // ✅ Accepting New Clients (Checkbox Validation)
          CheckboxListTile.adaptive(
            dense: true,
            value: newClients.value,
            checkboxScaleFactor: 1.5,
            onChanged: (value) {
              newClients.value = value!;
            },
            contentPadding: const EdgeInsets.symmetric(horizontal: 0),
            title: const Text('Are you accepting new clients?*'),
          ),
          const SizedBox(height: 10),

          // ✅ Availability Section (Dynamic Validation for Each Day)
          Text(
            'Availability*',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          _buildAvailabilitySection(context, ref, professionalformState),

          const SizedBox(height: 10),
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

  Widget _buildAvailabilitySection(
    BuildContext context,
    WidgetRef ref,
    ProfessionalProfileModel profile,
  ) {
    final days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];

    // ✅ Initialize availability controllers for each day
    final availabilityControllers = Map<String, Map<String, TextEditingController>>.fromEntries(
      days.map((day) {
        String fromTime = '';
        String toTime = '';

        final dailyAvailability = profile.availability?.dailyAvailability;
        final dayKey = day.toLowerCase();
        final availabilityStr = dailyAvailability?.toJson()[dayKey];

        if (availabilityStr != null && availabilityStr != 'Unavailable') {
          final times = availabilityStr.split(' - ');
          if (times.length == 2) {
            fromTime = times[0];
            toTime = times[1];
          }
        }

        return MapEntry(
          day,
          {
            'from': TextEditingController(text: fromTime),
            'to': TextEditingController(text: toTime),
          },
        );
      }),
    );

    Future<TimeOfDay?> _showTimePicker() async {
      return showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
        builder: (context, child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
            child: child!,
          );
        },
      );
    }

    String _formatTime(TimeOfDay time) {
      final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
      final minute = time.minute.toString().padLeft(2, '0');
      final period = time.period == DayPeriod.am ? 'AM' : 'PM';
      return '$hour:$minute $period';
    }

    void _updateAvailability(String day) {
      final fromTime = availabilityControllers[day]!['from']!.text.trim();
      final toTime = availabilityControllers[day]!['to']!.text.trim();

      final currentAvailability = profile.availability?.dailyAvailability ?? DailyAvailability();

      // ✅ Create a new DailyAvailability with the updated day
      DailyAvailability updatedAvailability;

      switch (day.toLowerCase()) {
        case 'monday':
          updatedAvailability = currentAvailability.copyWith(
            monday: (fromTime.isEmpty && toTime.isEmpty) ? 'Unavailable' : '$fromTime - $toTime',
          );
          break;
        case 'tuesday':
          updatedAvailability = currentAvailability.copyWith(
            tuesday: (fromTime.isEmpty && toTime.isEmpty) ? 'Unavailable' : '$fromTime - $toTime',
          );
          break;
        case 'wednesday':
          updatedAvailability = currentAvailability.copyWith(
            wednesday: (fromTime.isEmpty && toTime.isEmpty) ? 'Unavailable' : '$fromTime - $toTime',
          );
          break;
        case 'thursday':
          updatedAvailability = currentAvailability.copyWith(
            thursday: (fromTime.isEmpty && toTime.isEmpty) ? 'Unavailable' : '$fromTime - $toTime',
          );
          break;
        case 'friday':
          updatedAvailability = currentAvailability.copyWith(
            friday: (fromTime.isEmpty && toTime.isEmpty) ? 'Unavailable' : '$fromTime - $toTime',
          );
          break;
        case 'saturday':
          updatedAvailability = currentAvailability.copyWith(
            saturday: (fromTime.isEmpty && toTime.isEmpty) ? 'Unavailable' : '$fromTime - $toTime',
          );
          break;
        case 'sunday':
          updatedAvailability = currentAvailability.copyWith(
            sunday: (fromTime.isEmpty && toTime.isEmpty) ? 'Unavailable' : '$fromTime - $toTime',
          );
          break;
        default:
          updatedAvailability = currentAvailability;
      }

      // ✅ Update the profile with new availability
      ref.read(psychologistProfileFormProvider.notifier).updateField(
            profile.copyWith(
              availability: profile.availability?.copyWith(
                dailyAvailability: updatedAvailability,
              ),
            ),
          );
    }

    return Column(
      children: days.map((day) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(day, style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              Row(
                children: [
                  // ✅ "From" Time Field
                  Expanded(
                    flex: 3,
                    child: TextFormField(
                      readOnly: true,
                      controller: availabilityControllers[day]!['from'],
                      decoration: const InputDecoration(
                        labelText: 'From',
                        border: OutlineInputBorder(),
                        suffixIcon: Icon(Icons.access_time),
                      ),
                      onTap: () async {
                        final time = await _showTimePicker();
                        if (time != null) {
                          availabilityControllers[day]!['from']!.text = _formatTime(time);
                          _updateAvailability(day);
                        }
                      },
                      validator: (value) {
                        final toTime = availabilityControllers[day]!['to']!.text;
                        if (value != null && value.isNotEmpty && toTime.isNotEmpty) {
                          final fromDate = DateFormat.jm().parse(value);
                          final toDate = DateFormat.jm().parse(toTime);
                          if (fromDate.isAfter(toDate)) {
                            return 'Start time must be before end time';
                          }
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 8),

                  // ✅ "To" Time Field
                  Expanded(
                    flex: 3,
                    child: TextFormField(
                      readOnly: true,
                      controller: availabilityControllers[day]!['to'],
                      decoration: const InputDecoration(
                        labelText: 'To',
                        border: OutlineInputBorder(),
                        suffixIcon: Icon(Icons.access_time),
                      ),
                      onTap: () async {
                        final time = await _showTimePicker();
                        if (time != null) {
                          availabilityControllers[day]!['to']!.text = _formatTime(time);
                          _updateAvailability(day);
                        }
                      },
                      validator: (value) {
                        final fromTime = availabilityControllers[day]!['from']!.text;
                        if (value != null && value.isNotEmpty && fromTime.isNotEmpty) {
                          final fromDate = DateFormat.jm().parse(fromTime);
                          final toDate = DateFormat.jm().parse(value);
                          if (fromDate.isAfter(toDate)) {
                            return 'End time must be after start time';
                          }
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
