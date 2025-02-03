import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:psych_app/presentation/screens/community/post_screen.dart';

import '../../../data/models/appointment_model.dart';
import '../../../shared/constants/firebase_helper.dart';
import '../../notifiers/appointment_notifier.dart';
import '../community/community_home.dart';

class HistoryScreen extends HookConsumerWidget {
  const HistoryScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(userAppointmentsStreamProvider(FirebaseHelper.currentUserId!)).when(
          data: (appointment) {
            return ListView.separated(
              itemCount: appointment.length,
              itemBuilder: (context, index) {
                return AppointmentWidget(
                  appointment: appointment[index],
                );
              },
              separatorBuilder: (context, index) {
                return Divider(
                  thickness: 0.3,
                );
              },
            );
          },
          loading: () => Center(
            child: CircularProgressIndicator(),
          ),
          error: (error, _) {
            print('Error loading chat rooms: $error');
            return Center(
              child: Text(
                error.toString(),
              ),
            );
          },
        );
  }
}

class AppointmentWidget extends ConsumerWidget {
  const AppointmentWidget({
    super.key,
    required this.appointment,
  });

  final AppointmentModel appointment;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final psychologistUser = ref.watch(psychologistProvider(appointment.professionalId));
    final customerUser = ref.watch(userProvider(appointment.userId));

    return psychologistUser.when(
      data: (psychologist) {
        Uint8List? avatarBytes;

        if (psychologist.avatarData != null) {
          if (psychologist.avatarData is String) {
            avatarBytes = base64.decode(psychologist.avatarData as String);
          } else if (psychologist.avatarData is List<dynamic>) {
            avatarBytes = Uint8List.fromList(psychologist.avatarData as List<int>);
          }
        }
        return Card(
          child: SizedBox(
            height: 80,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  width: 5,
                  decoration: BoxDecoration(
                    color: appointment.status == 'pending'
                        ? Colors.amber
                        : appointment.status == 'accepted'
                            ? Colors.green
                            : Colors.red,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(4),
                      bottomLeft: Radius.circular(4),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: CircleAvatar(
                    radius: 28,
                    backgroundImage: MemoryImage(avatarBytes!),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        psychologist.fullName ?? '',
                        style: Theme.of(context).textTheme.labelLarge,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        appointment.specialization,
                        style: Theme.of(context).textTheme.labelMedium?.copyWith(
                              color: Theme.of(context).colorScheme.outline,
                            ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        DateFormat('hh:mm a').format(appointment.appointmentDateTime),
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                      Text(
                        DateFormat('dd MMM yyyy').format(appointment.appointmentDateTime),
                        style: Theme.of(context).textTheme.labelMedium?.copyWith(
                              color: Theme.of(context).colorScheme.outline,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
      loading: () => SizedBox.shrink(),
      error: (_, __) => SizedBox.shrink(),
    );
  }
}
