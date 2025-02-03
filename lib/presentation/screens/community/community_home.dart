import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../data/models/post_model.dart';
import '../../../data/models/psychologist_model.dart';
import '../../../data/remote_data_source/firebase_auth.dart';
import '../../notifiers/post_interaction_notifier.dart';
import '../../notifiers/post_notifier.dart';
import 'post_screen.dart';

// Additional Providers
final psychologistProvider = FutureProvider.family<PsychologistModel, String>((ref, uid) async {
  final doc = await FirebaseFirestore.instance.collection('psychologist').doc(uid).get();
  return PsychologistModel.fromJson(doc.data()!);
});

final likeStatusProvider = StreamProvider.family<bool, String>((ref, postId) {
  final user = ref.watch(authStateProvider).value;
  if (user == null) return Stream.value(false);

  return FirebaseFirestore.instance.collection('posts/$postId/likes').doc(user.uid).snapshots().map((doc) => doc.exists);
});

class CommunityHome extends HookConsumerWidget {
  const CommunityHome({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postsAsync = ref.watch(postsProvider);

    return postsAsync.when(
      loading: () => Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(child: Text('Error loading posts')),
      data: (posts) {
        if (posts.isEmpty) {
          return Center(
            child: Text('No Community Posts Found'),
          );
        }
        return ListView.builder(
          itemCount: posts.length,
          itemBuilder: (context, index) => PostContent(
            post: posts[index],
            isCardVisible: true,
          ),
        );
      },
    );
  }
}

class PostContent extends ConsumerWidget {
  final PostModel post;
  final bool? isCardVisible;

  PostContent({required this.post, this.isCardVisible = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authorAsync = ref.watch(psychologistProvider(post.authorId));

    return authorAsync.when(
      loading: () => SizedBox.shrink(),
      error: (_, __) => SizedBox.shrink(),
      data: (psychologist) {
        Uint8List? avatarBytes;
        Uint8List? postImageBytes;

        // Handle avatarData based on storage format
        if (psychologist.avatarData != null) {
          if (psychologist.avatarData is String) {
            // If stored as a base64-encoded string
            avatarBytes = base64.decode(psychologist.avatarData as String);
          } else if (psychologist.avatarData is List<dynamic>) {
            // If stored as a list of integers
            avatarBytes = Uint8List.fromList(psychologist.avatarData as List<int>);
          }
        }

        // Handle avatarData based on storage format
        if (post.imageData != null) {
          if (post.imageData is String) {
            // If stored as a base64-encoded string
            postImageBytes = base64.decode(post.imageData as String);
          } else if (post.imageData is List<dynamic>) {
            // If stored as a list of integers
            postImageBytes = Uint8List.fromList(post.imageData as List<int>);
          }
        }

        String customTimeAgo(DateTime input) {
          final now = DateTime.now().toLocal();
          final difference = now.difference(input.toLocal());

          if (difference.inSeconds < 60) {
            return 'Just now';
          } else if (difference.inMinutes < 60) {
            return '${difference.inMinutes}m';
          } else if (difference.inHours < 24) {
            return '${difference.inHours}h';
          } else if (difference.inDays < 7) {
            return '${difference.inDays}d';
          } else if (difference.inDays < 30) {
            final weeks = (difference.inDays / 7).floor();
            return '${weeks}w';
          } else if (difference.inDays < 365) {
            final months = (difference.inDays / 30).floor();
            return '${months}mo';
          } else {
            final years = (difference.inDays / 365).floor();
            return '${years}y';
          }
        }

        return GestureDetector(
          onTap: () {
            if (isCardVisible != false)
              context.pushNamed(
                PostScreen.routeName,
                extra: post.id,
              );
          },
          child: _PostCard(
            isCardVisible: isCardVisible!,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    leading: CircleAvatar(
                      backgroundImage: avatarBytes != null ? MemoryImage(avatarBytes) : null,
                    ),
                    title: Text(
                      psychologist.fullName ?? '',
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    trailing: Text(
                      customTimeAgo(post.timestamp),
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: Theme.of(context).colorScheme.outline,
                          ),
                    ),
                    subtitle: Text(
                      (psychologist.specialization != null && psychologist.specialization!.isNotEmpty)
                          ? psychologist.specialization![0].toUpperCase() + psychologist.specialization!.substring(1)
                          : 'N/A',
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: Theme.of(context).colorScheme.outline,
                          ),
                    ),
                  ),
                  if (post.imageData != null && post.imageData != '')
                    ConstrainedBox(
                      constraints: BoxConstraints.fromViewConstraints(
                        ViewConstraints(
                          maxHeight: 500,
                          minWidth: double.infinity,
                        ),
                      ),
                      child: GestureDetector(
                        onTap: () {
                          if (postImageBytes != null) {
                            showDialog(
                              context: context,
                              builder: (context) => Dialog(
                                child: InteractiveViewer(
                                  child: Image.memory(
                                    postImageBytes!,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                            );
                          }
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.memory(
                            postImageBytes!,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      post.content,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                  // isCardVisible == false ? Divider(thickness: 0.3) : SizedBox.shrink(),
                  _PostActions(post: post),
                  isCardVisible == false ? Divider(thickness: 0.3) : SizedBox.shrink(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// Post Actions Widget
class _PostActions extends ConsumerWidget {
  final PostModel post;

  _PostActions({required this.post});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hasLiked = ref.watch(likeStatusProvider(post.id));

    return Row(
      children: [
        IconButton(
          icon: hasLiked.when(
            data: (liked) => Icon(liked ? CupertinoIcons.heart_fill : CupertinoIcons.heart),
            loading: () => Icon(CupertinoIcons.heart),
            error: (_, __) => Icon(CupertinoIcons.heart),
          ),
          color: hasLiked.when(
            data: (liked) => liked ? Colors.red : null,
            loading: () => null,
            error: (_, __) => null,
          ),
          onPressed: () => ref.read(postInteractionProvider(post.id).notifier).toggleLike(),
        ),
        Text('${post.likes}'),
        IconButton(
          icon: Icon(CupertinoIcons.bubble_left),
          onPressed: () {},
        ),
        Text('${post.commentsCount}'),
      ],
    );
  }
}

class _PostCard extends StatelessWidget {
  const _PostCard({
    required this.child,
    this.isCardVisible = true,
  });

  final Widget child;
  final bool isCardVisible;

  @override
  Widget build(BuildContext context) {
    if (isCardVisible) {
      return Card(
        color: Theme.of(context).colorScheme.surfaceContainerLowest,
        child: child,
      );
    } else {
      return child;
    }
  }
}
