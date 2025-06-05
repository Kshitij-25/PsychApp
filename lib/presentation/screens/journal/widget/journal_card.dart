import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../data/firebase_models/journal_entry.dart';
import '../create_journal_screen.dart';

class JournalCard extends StatelessWidget {
  const JournalCard({
    super.key,
    required this.journal,
    required this.onDismissed,
  });

  final JournalEntry journal;
  final Function(DismissDirection)? onDismissed;

  String formatJournalTime(DateTime? dateTime) {
    if (dateTime == null) return '';

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    if (dateTime.isAfter(today)) {
      // Today
      return DateFormat('h:mm a').format(dateTime);
    } else if (dateTime.isAfter(yesterday)) {
      // Yesterday
      return 'Yesterday';
    } else {
      // Older dates
      return DateFormat('MM/dd/yyyy').format(dateTime);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(journal.id!),
      direction: DismissDirection.endToStart,
      onDismissed: onDismissed,
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ),
      confirmDismiss: (direction) async {
        return await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog.adaptive(
              title: Text('Delete Journal Entry'),
              content: Text('Are you sure you want to delete this entry?'),
              actions: <Widget>[
                TextButton(
                  onPressed: () => context.pop(false),
                  child: Text('Cancel'),
                ),
                TextButton(
                  onPressed: () => context.pop(true),
                  child: Text('Delete'),
                ),
              ],
            );
          },
        );
      },
      child: ListTile(
        dense: true,
        title: Text(
          journal.title ?? 'Untitled',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w400,
              ),
        ),
        subtitle: Row(
          children: [
            Text(
              formatJournalTime(journal.updatedAt),
              style: Theme.of(context).textTheme.bodySmall,
            ),
            SizedBox(width: 15),
            if (journal.subTitle != null)
              Expanded(
                child: Text(
                  journal.subTitle!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              )
          ],
        ),
        onTap: () {
          context.pushNamed(
            CreateJournalScreen.routeName,
            extra: journal,
          );
        },
      ),
    );
  }
}
