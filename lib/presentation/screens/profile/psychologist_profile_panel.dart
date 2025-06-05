import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../data/firebase_models/psychologist_model.dart';
import '../../../shared/constants/firebase_helper.dart';

final psychologistProvider = FutureProvider<PsychologistModel>((ref) async {
  final userId = FirebaseHelper.currentUserId;
  if (userId == null) {
    throw Exception('User ID is null');
  }
  final docSnapshot = await FirebaseHelper.getUserDocument(userId);
  if (docSnapshot == null || docSnapshot.data() == null) {
    throw Exception('Document snapshot is null');
  }
  return PsychologistModel.fromJson(docSnapshot.data() as Map<String, dynamic>);
});

class PsychologistProfilePanel extends HookConsumerWidget {
  const PsychologistProfilePanel({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(psychologistProvider).when(
          data: (psychologist) {
            Uint8List? avatarBytes;

            // Handle avatarData based on storage format
            if (psychologist.avatarData != null) {
              if (psychologist.avatarData is String) {
                // If stored as a base64-encoded string
                avatarBytes = base64.decode(psychologist.avatarData as String);
              } else if (psychologist.avatarData is List<int>) {
                // If stored as a list of integers
                avatarBytes = Uint8List.fromList(psychologist.avatarData as List<int>);
              }
            }
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Profile Header
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (avatarBytes != null) {
                            showDialog(
                              context: context,
                              builder: (context) => Dialog(
                                child: InteractiveViewer(
                                  child: Image.memory(
                                    avatarBytes!,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                            );
                          }
                        },
                        child: CircleAvatar(
                          radius: 50,
                          child: avatarBytes == null ? Icon(CupertinoIcons.person, size: 20) : null,
                          backgroundImage: avatarBytes != null ? MemoryImage(avatarBytes) : null,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            psychologist.fullName ?? 'N/A',
                            style: Theme.of(context).textTheme.headlineSmall,
                            textAlign: TextAlign.start,
                          ),
                          Text(
                            (psychologist.specialization != null && psychologist.specialization!.isNotEmpty)
                                ? psychologist.specialization![0].toUpperCase() + psychologist.specialization!.substring(1)
                                : 'N/A',
                            textAlign: TextAlign.start,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ],
                      ),
                      Spacer(),
                      IconButton(
                        onPressed: () {},
                        icon: Icon(
                          FontAwesomeIcons.penToSquare,
                          color: Theme.of(context).colorScheme.primaryContainer,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Ratings and Reviews
                  _buildInfoCard(
                    context,
                    title: 'Ratings & Reviews',
                    content: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.star, color: Colors.amber),
                            Text(
                              ' ${psychologist.ratings?.toStringAsFixed(1) ?? 'N/A'} ',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            Text('(${psychologist.reviews ?? 0} reviews)'),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // About Section
                  if (psychologist.about != null) ...[
                    const SizedBox(height: 5),
                    _buildInfoCard(
                      context,
                      title: 'About',
                      content: Text(psychologist.about!),
                    ),
                  ],

                  // Expertise
                  if (psychologist.expertise?.isNotEmpty ?? false) ...[
                    const SizedBox(height: 5),
                    _buildInfoCard(
                      context,
                      title: 'Expertise',
                      content: Wrap(
                        spacing: 8,
                        children: psychologist.expertise!
                            .map(
                              (item) => Chip(
                                side: BorderSide.none,
                                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                                labelStyle: TextStyle(
                                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                                ),
                                visualDensity: VisualDensity.compact,
                                label: Text(item.replaceAll('_', ' ').split(' ').map((word) {
                                  return word[0].toUpperCase() + word.substring(1).toLowerCase();
                                }).join(' ')),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  ],

                  // Publications
                  if (psychologist.publications?.isNotEmpty ?? false) ...[
                    const SizedBox(height: 5),
                    _buildInfoCard(
                      context,
                      title: 'Publications',
                      content: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: List.generate(
                          psychologist.publications!.length,
                          (index) => Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: InkWell(
                              onTap: () {
                                // Handle publication link tap
                                if (psychologist.publicationsLinks?[index] != null) {
                                  // Launch URL
                                }
                              },
                              child: Text(
                                psychologist.publications![index],
                                style: const TextStyle(
                                  decoration: TextDecoration.underline,
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],

                  // Availability
                  if (psychologist.availability?.isNotEmpty ?? false) ...[
                    const SizedBox(height: 5),
                    _buildInfoCard(
                      context,
                      title: 'Availability',
                      content: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: psychologist.availability!.entries
                            .map(
                              (item) => Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: Text(
                                  '${item.key[0].toUpperCase() + item.key.substring(1)}: ${item.value == '' ? 'Unavailable' : item.value}',
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  ],

                  // Contact Information
                  const SizedBox(height: 5),
                  _buildInfoCard(
                    context,
                    title: 'Contact Information',
                    content: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (psychologist.email != null) _buildContactRow(CupertinoIcons.mail_solid, psychologist.email!),
                        if (psychologist.phoneNumber != null) _buildContactRow(CupertinoIcons.phone_fill, psychologist.phoneNumber!),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(
            child: Text('Error loading profile: $error'),
          ),
        );
  }

  Widget _buildInfoCard(
    BuildContext context, {
    required String title,
    required Widget content,
  }) {
    return Card(
      color: Theme.of(context).colorScheme.surfaceContainerLowest,
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            content,
          ],
        ),
      ),
    );
  }

  Widget _buildContactRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 8),
          Text(text),
        ],
      ),
    );
  }
}
