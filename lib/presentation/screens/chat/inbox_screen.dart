import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class InboxScreen extends HookConsumerWidget {
  static const routeName = 'inboxScreen';
  const InboxScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchController = useTextEditingController();
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
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
              SizedBox(height: 16),
              ListTile(
                contentPadding: EdgeInsets.only(left: 0),
                leading: CircleAvatar(
                  radius: 30,
                  child: Icon(
                    FontAwesomeIcons.brain,
                    size: 18,
                  ),
                ),
                title: Text(
                  'Emergeny Help',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                subtitle: Text(
                  'Incoming Call',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.outline,
                      ),
                ),
                trailing: Text('Mon'),
              ),
              Divider(thickness: 0.3),
            ],
          ),
        ),
      ),
    );
  }
}
