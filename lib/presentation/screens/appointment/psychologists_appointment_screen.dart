import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../data/models/appointment_model.dart';
import '../../../shared/constants/firebase_helper.dart';
import '../../notifiers/appointment_notifier.dart';
import '../community/post_screen.dart';

class PsychologistsAppointmentScreen extends HookConsumerWidget {
  const PsychologistsAppointmentScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(professionalAppointmentsStreamProvider(FirebaseHelper.currentUserId!)).when(
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
    final customerUser = ref.watch(userProvider(appointment.userId));

    return customerUser.when(
      data: (user) {
        Uint8List? avatarBytes;

        if (user.avatarData != null) {
          if (user.avatarData is String) {
            avatarBytes = base64.decode(user.avatarData as String);
          } else if (user.avatarData is List<dynamic>) {
            avatarBytes = Uint8List.fromList(user.avatarData as List<int>);
          }
        }
        return Card(
          child: SizedBox(
            height: 120,
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
                        user.fullName ?? '',
                        style: Theme.of(context).textTheme.labelLarge,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            DateFormat('dd MMM yyyy').format(appointment.appointmentDateTime),
                            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                  color: Theme.of(context).colorScheme.outline,
                                ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '- ' + DateFormat('hh:mm a').format(appointment.appointmentDateTime),
                            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                  color: Theme.of(context).colorScheme.outline,
                                ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                if (appointment.status == 'pending')
                  Padding(
                    padding: const EdgeInsets.only(right: 15),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () async {
                            ref.read(appointmentProvider.notifier).updateAppointmentStatus(
                                  appointmentId: appointment.id,
                                  status: 'accepted',
                                );
                          },
                          child: Text(
                            'ACCEPT',
                            style: TextStyle(color: Colors.green),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            ref.read(appointmentProvider.notifier).updateAppointmentStatus(
                                  appointmentId: appointment.id,
                                  status: 'rejected',
                                );
                          },
                          child: Text(
                            'REJECT',
                            style: TextStyle(color: Colors.redAccent),
                          ),
                        ),
                      ],
                    ),
                  ),
                if (appointment.status != 'pending')
                  Padding(
                    padding: const EdgeInsets.only(right: 15),
                    child: Center(
                      child: Text(
                        appointment.status.toUpperCase(),
                        style: TextStyle(
                          color: appointment.status == 'accepted' ? Colors.green : Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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
