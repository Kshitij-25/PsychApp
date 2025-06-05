import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../data/firebase_models/psychologist_model.dart';

class PsychologistsCard extends StatelessWidget {
  const PsychologistsCard({
    Key? key,
    required this.psychologistsData,
    required this.onTap,
  }) : super(key: key);

  final PsychologistModel psychologistsData;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    Uint8List? avatarBytes;

    // Handle avatarData based on storage format
    if (psychologistsData.avatarData != null) {
      if (psychologistsData.avatarData is String) {
        // If stored as a base64-encoded string
        avatarBytes = base64.decode(psychologistsData.avatarData as String);
      } else if (psychologistsData.avatarData is List<dynamic>) {
        // If stored as a list of integers
        avatarBytes = Uint8List.fromList(List<int>.from(psychologistsData.avatarData as List<dynamic>));
      }
    }

    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 0.5,
        color: Theme.of(context).colorScheme.surfaceContainerLowest,
        child: Row(
          spacing: 16,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: CircleAvatar(
                radius: 30,
                child: avatarBytes == null ? Icon(CupertinoIcons.person, size: 20) : null,
                backgroundImage: avatarBytes != null ? MemoryImage(avatarBytes) : null,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  psychologistsData.fullName ?? '',
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                Text(
                  psychologistsData.specialization?.replaceAll('_', ' ').split(' ').map((word) {
                        return word[0].toUpperCase() + word.substring(1).toLowerCase();
                      }).join(' ') ??
                      '',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: Theme.of(context).colorScheme.outline,
                      ),
                ),
                psychologistsData.ratings != null
                    ? Row(
                        spacing: 5,
                        children: [
                          Text(
                            psychologistsData.ratings != null ? psychologistsData.ratings.toString() : 'NA',
                            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                  color: Theme.of(context).colorScheme.outline,
                                ),
                          ),
                          Icon(
                            CupertinoIcons.star_fill,
                            size: 13,
                            color: Colors.amber,
                          )
                        ],
                      )
                    : SizedBox.shrink(),
              ],
            ),
            Spacer(),
            IconButton(
              onPressed: () {},
              icon: Icon(
                CupertinoIcons.bookmark,
              ),
            )
          ],
        ),
      ),
    );
  }
}
