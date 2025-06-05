import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../data/firebase_models/psychologist_model.dart';
import '../../../shared/constants/firebase_helper.dart';
import '../../notifiers/appointment_notifier.dart';
import '../../widgets/custom_elevated_button.dart';

class BookAppointmentScreen extends StatefulHookConsumerWidget {
  static const routeName = '/bookAppointmentScreen';
  const BookAppointmentScreen({
    super.key,
    required this.psychologistsData,
  });

  final PsychologistModel psychologistsData;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BookAppointmentScreenState();
}

class _BookAppointmentScreenState extends ConsumerState<BookAppointmentScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay = DateTime.now();
  String? _selectedTime;

  List<String> _generateTimeSlots(String timeRange) {
    if (timeRange == "Unavailable") {
      return [];
    }

    final parts = timeRange.split(" - ");
    final startTime = _parseTime(parts[0]);
    final endTime = _parseTime(parts[1]);

    List<String> timeSlots = [];
    DateTime currentTime = startTime;

    while (currentTime.isBefore(endTime)) {
      timeSlots.add(_formatTime(currentTime));
      currentTime = currentTime.add(Duration(minutes: 30));
    }

    return timeSlots;
  }

  DateTime _parseTime(String time) {
    final isPM = time.contains("PM");
    final timeParts = time.replaceAll(" AM", "").replaceAll(" PM", "").split(":");
    int hour = int.parse(timeParts[0]);
    int minute = int.parse(timeParts[1]);
    if (isPM && hour != 12) {
      hour += 12;
    } else if (!isPM && hour == 12) {
      hour = 0;
    }
    return DateTime(0, 0, 0, hour, minute);
  }

  String _formatTime(DateTime time) {
    return "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        forceMaterialTransparency: true,
        title: Text(
          'Appointment Schedule',
          textAlign: TextAlign.start,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerLowest,
                border: Border.all(
                  color: Theme.of(context).colorScheme.scrim,
                  width: 0.1,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: TableCalendar(
                firstDay: DateTime.utc(2020, 1, 1),
                lastDay: DateTime.utc(2030, 12, 31),
                focusedDay: _focusedDay,
                selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                enabledDayPredicate: (day) {
                  final now = DateTime.now();
                  return day.isAfter(DateTime(now.year, now.month, now.day).subtract(Duration(days: 0)));
                },
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                    _selectedTime = null; // Reset selected time on new day selection
                  });
                },
                calendarFormat: CalendarFormat.month,
                startingDayOfWeek: StartingDayOfWeek.sunday,
                headerStyle: HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: true,
                ),
                calendarStyle: CalendarStyle(
                  selectedDecoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    shape: BoxShape.circle,
                  ),
                  todayDecoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.outline,
                    shape: BoxShape.circle,
                  ),
                  outsideDaysVisible: true,
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              "Choose the right time",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            SizedBox(height: 10),
            _selectedDay != null
                ? Builder(
                    builder: (context) {
                      final dayOfWeek = _selectedDay!.weekday == 7
                          ? "sunday"
                          : ["monday", "tuesday", "wednesday", "thursday", "friday", "saturday"][_selectedDay!.weekday - 1];
                      final timeRange = widget.psychologistsData.availability![dayOfWeek]!;
                      final timeSlots = _generateTimeSlots(timeRange);

                      if (timeSlots.isEmpty) {
                        return Text(
                          "Unavailable",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.error,
                          ),
                        );
                      }
                      return Wrap(
                        spacing: 8.0,
                        children: timeSlots.map((time) {
                          // Calculate whether the slot is in the past
                          final now = DateTime.now();
                          final slotDateTime = DateTime(
                            _selectedDay!.year,
                            _selectedDay!.month,
                            _selectedDay!.day,
                            int.parse(time.split(":")[0]),
                            int.parse(time.split(":")[1]),
                          );
                          final isPast = slotDateTime.isBefore(now);

                          return ChoiceChip(
                            label: Text(time),
                            selected: _selectedTime == time,
                            onSelected: isPast
                                ? null
                                : (selected) {
                                    setState(() {
                                      _selectedTime = selected ? time : null;
                                    });
                                  },
                            selectedColor: Theme.of(context).colorScheme.primaryContainer,
                            backgroundColor: isPast ? Colors.grey[300] : Theme.of(context).colorScheme.surfaceContainerLowest,
                            labelStyle: TextStyle(
                              color: isPast
                                  ? Theme.of(context).colorScheme.outline
                                  : (_selectedTime == time
                                      ? Theme.of(context).colorScheme.onPrimaryContainer
                                      : Theme.of(context).colorScheme.primaryContainer),
                            ),
                            showCheckmark: false,
                          );
                        }).toList(),
                      );
                    },
                  )
                : Text("Select a day to view available times"),
            Spacer(),
            SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: CustomElevatedButton(
                      onPressed: (_selectedDay != null && _selectedTime != null)
                          ? () async {
                              try {
                                // Show loading indicator
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    behavior: SnackBarBehavior.floating,
                                    backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
                                    content: Row(
                                      children: [
                                        CircularProgressIndicator(),
                                        SizedBox(width: 16),
                                        Text(
                                          'Booking appointment...',
                                          textAlign: TextAlign.center,
                                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                                color: Theme.of(context).colorScheme.onTertiaryContainer,
                                              ),
                                        ),
                                      ],
                                    ),
                                    duration: Duration(seconds: 1),
                                  ),
                                );
                                final selectedDateTime = DateTime(
                                  _selectedDay!.year,
                                  _selectedDay!.month,
                                  _selectedDay!.day,
                                  int.parse(_selectedTime!.split(':')[0]),
                                  int.parse(_selectedTime!.split(':')[1]),
                                );

                                final formattedDateTime = DateFormat('dd MMM yyyy, hh:mm a').format(selectedDateTime);

                                // Book appointment
                                await ref.read(appointmentProvider.notifier).bookAppointment(
                                    userId: FirebaseHelper.currentUserId!,
                                    professionalId: widget.psychologistsData.uid ?? '',
                                    appointmentDateTime: selectedDateTime,
                                    consultationFee: 0.0,
                                    specialization: widget.psychologistsData.specialization ?? '');

                                if (context.mounted) {
                                  // Show success message
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      behavior: SnackBarBehavior.floating,
                                      content: Text(
                                        'Appointment set for $formattedDateTime',
                                        textAlign: TextAlign.center,
                                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                              color: Theme.of(context).colorScheme.onTertiaryContainer,
                                            ),
                                      ),
                                      backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
                                    ),
                                  );

                                  // Navigate back
                                  context.pop();
                                }
                              } catch (e) {
                                if (context.mounted) {
                                  // Show error message
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      behavior: SnackBarBehavior.floating,
                                      content: Text(
                                        'Failed to book appointment: ${e.toString()}',
                                        textAlign: TextAlign.center,
                                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                              color: Theme.of(context).colorScheme.error,
                                            ),
                                      ),
                                      backgroundColor: Theme.of(context).colorScheme.errorContainer,
                                    ),
                                  );
                                }
                              }
                            }
                          : null,
                      buttonLabel: 'Confirm Appointment',
                      buttonStyle: ElevatedButton.styleFrom(
                        enableFeedback: true,
                        backgroundColor: Theme.of(context).buttonTheme.colorScheme!.primaryContainer,
                        foregroundColor: Theme.of(context).buttonTheme.colorScheme!.onPrimaryContainer,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
