import 'dart:convert';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../data/firebase_models/comment_model.dart';
import '../../../data/firebase_models/psychologist_model.dart';
import '../../../data/firebase_models/user_model.dart';
import '../../../shared/constants/firebase_helper.dart';
import '../../notifiers/post_interaction_notifier.dart';
import '../../notifiers/post_notifier.dart';
import 'community_home.dart';

final userProvider = FutureProvider.family<UserModel, String>((ref, uid) async {
  final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
  return UserModel.fromJson(doc.data() ?? {});
});

class PostScreen extends HookConsumerWidget {
  static const routeName = "/postScreen";
  final String postId;

  const PostScreen({super.key, required this.postId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final commentController = useTextEditingController();
    final postAsync = ref.watch(singlePostProvider(postId));
    final commentsAsync = ref.watch(postCommentsProvider(postId));

    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Expanded(
            child: CustomScrollView(
              slivers: [
                // Post Content
                SliverToBoxAdapter(
                  child: postAsync.when(
                    data: (post) => PostContent(
                      post: post,
                      isCardVisible: false,
                    ),
                    loading: () => const Center(child: CircularProgressIndicator()),
                    error: (e, _) => Center(child: Text('Error loading post: $e')),
                  ),
                ),
                // Comments List
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 0),
                  sliver: commentsAsync.when(
                    data: (comments) => SliverList.separated(
                      itemCount: comments.length,
                      itemBuilder: (context, index) => CommentWidget(comment: comments.reversed.toList()[index]),
                      separatorBuilder: (context, index) => Divider(
                        thickness: 0.2,
                      ),
                    ),
                    loading: () => const SliverFillRemaining(
                      child: Center(child: CircularProgressIndicator()),
                    ),
                    error: (e, _) => SliverToBoxAdapter(
                      child: Center(child: Text('Error loading comments: $e')),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Comment Input
          SafeArea(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: Colors.grey.shade800)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: commentController,
                      decoration: const InputDecoration(
                        hintText: 'Write a comment...',
                        border: InputBorder.none,
                      ),
                      minLines: 1,
                      maxLines: 3,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: () {
                      final content = commentController.text.trim();
                      if (content.isNotEmpty) {
                        ref.read(postInteractionProvider(postId).notifier).addComment(content);
                        commentController.clear();
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Comment Widget
class CommentWidget extends ConsumerWidget {
  final CommentModel comment;

  const CommentWidget({super.key, required this.comment});

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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder<String>(
      future: FirebaseHelper.getUserRole(comment.authorId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const ListTile(
            leading: CircleAvatar(),
            title: Text('Loading...'),
          );
        } else if (snapshot.hasError) {
          return const ListTile(
            leading: CircleAvatar(),
            title: Text('Error loading user role'),
          );
        }

        final userRole = snapshot.data!;
        final authorAsync = userRole == "user"
            ? ref.watch(userProvider(comment.authorId))
            : ref.watch(
                psychologistProvider(comment.authorId),
              );

        return authorAsync.when(
          data: (user) {
            // Explicitly cast the user object to the correct type
            final String fullName;
            final String? avatarData;

            if (user is UserModel) {
              fullName = user.fullName ?? '';
              avatarData = user.avatarData;
            } else if (user is PsychologistModel) {
              fullName = user.fullName!;
              avatarData = user.avatarData;
            } else {
              return const ListTile(
                leading: CircleAvatar(),
                title: Text('Unknown user'),
              );
            }

            Uint8List? avatarBytes;

            if (avatarData != null) {
              avatarBytes = base64.decode(avatarData);
            }
            return ListTile(
              dense: true,
              leading: CircleAvatar(
                backgroundImage: avatarBytes != null ? MemoryImage(avatarBytes) : null,
              ),
              title: Text(
                fullName,
                style: Theme.of(context).textTheme.labelLarge,
              ),
              subtitle: Text(
                comment.content,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              trailing: Text(
                customTimeAgo(comment.timestamp),
                style: Theme.of(context).textTheme.bodySmall,
              ),
            );
          },
          loading: () => const ListTile(
            leading: CircleAvatar(),
            title: Text('Loading...'),
          ),
          error: (_, __) => const ListTile(
            leading: CircleAvatar(),
            title: Text('Error loading user'),
          ),
        );
      },
    );
  }
}
