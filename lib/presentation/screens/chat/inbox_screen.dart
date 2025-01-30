import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../shared/constants/firebase_helper.dart';
import '../../notifiers/chat_notifier.dart';
import 'chat_screen.dart';

class InboxScreen extends HookConsumerWidget {
  static const routeName = 'inboxScreen';
  const InboxScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchController = useTextEditingController();
    final searchQuery = useState('');

    // Update search query on text change
    useEffect(() {
      searchController.addListener(() {
        searchQuery.value = searchController.text.trim().toLowerCase();
      });
      return null;
    }, [searchController]);

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          forceMaterialTransparency: true,
          centerTitle: false,
          title: Text(
            'Chats',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          actions: [
            IconButton(
              onPressed: () {},
              icon: Icon(
                FontAwesomeIcons.penToSquare,
                color: Theme.of(context).colorScheme.primaryContainer,
              ),
            )
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: [
              SearchBar(
                shape: WidgetStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                elevation: WidgetStatePropertyAll(0),
                hintText: 'Search',
                controller: searchController,
                leading: Icon(CupertinoIcons.search),
              ),
              SizedBox(height: 15),
              Expanded(
                child: ref.watch(chatRoomsProvider).when(
                      data: (rooms) {
                        // Filter chat rooms based on the search query
                        final filteredRooms = searchQuery.value.isEmpty
                            ? rooms
                            : rooms.where((room) {
                                final currentUserId = FirebaseHelper.currentUserId;
                                final isPsychologist = currentUserId == room.psychologistId;

                                final searchTarget = isPsychologist ? room.userFullName!.toLowerCase() : room.psychologistFullName!.toLowerCase();

                                return searchTarget.contains(searchQuery.value);
                              }).toList();

                        if (filteredRooms.isEmpty) {
                          return Center(
                            child: Text('No Chats found.'),
                          );
                        }

                        return ListView.separated(
                          itemCount: filteredRooms.length,
                          separatorBuilder: (_, __) => Divider(thickness: 0.3),
                          itemBuilder: (context, index) {
                            final room = filteredRooms[index];
                            final currentUserId = FirebaseHelper.currentUserId;
                            final isPsychologist = currentUserId == room.psychologistId;

                            Uint8List? avatarBytes;
                            // If stored as a base64-encoded string
                            avatarBytes = base64.decode(isPsychologist ? (room.userAvatar ?? '') : (room.psychologistAvatar ?? ''));

                            return ListTile(
                              contentPadding: EdgeInsets.only(left: 0),
                              leading: CircleAvatar(
                                radius: 30,
                                backgroundImage: MemoryImage(avatarBytes),
                              ),
                              title: Text(isPsychologist ? room.userFullName ?? '' : room.psychologistFullName ?? ''),
                              subtitle: Text(
                                room.lastMessage ?? '',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              trailing: Text(
                                room.lastMessageTimestamp != null ? DateFormat.jm().format(room.lastMessageTimestamp as DateTime) : '',
                              ),
                              onTap: () {
                                List<String> ids = [room.userId!, room.psychologistId!];
                                ids.sort(); // Ensure consistent ordering
                                String chatRoomId = ids.join('_');

                                context.pushNamed(
                                  ChatScreen.routeName,
                                  extra: {
                                    'psychologistAvatar': room.psychologistAvatar,
                                    'psychologistId': room.psychologistId,
                                    'psychologistName': room.psychologistFullName,
                                    'userId': room.userId,
                                    'chatRoomId': chatRoomId,
                                    'userAvatar': room.userAvatar,
                                  },
                                );
                              },
                            );
                          },
                        );
                      },
                      loading: () => Center(
                        child: CircularProgressIndicator(),
                      ),
                      error: (error, _) {
                        print(error.toString());
                        return Center(
                          child: Text(
                            error.toString(),
                          ),
                        );
                      },
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
