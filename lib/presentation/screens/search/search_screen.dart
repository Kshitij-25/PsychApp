import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'history_screen.dart';
import 'therapist_search_screen.dart';

class SearchScreen extends HookConsumerWidget {
  const SearchScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: TabBar(
                  indicatorSize: TabBarIndicatorSize.tab,
                  labelColor: Theme.of(context).colorScheme.onPrimaryContainer,
                  indicatorAnimation: TabIndicatorAnimation.linear,
                  dividerColor: Colors.transparent,
                  unselectedLabelColor: Theme.of(context).tabBarTheme.unselectedLabelColor,
                  indicator: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  tabs: [
                    Tab(text: 'Therapists'),
                    Tab(text: 'Appointments'),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: TabBarView(
                children: [
                  TherapistSearchScreen(),
                  HistoryScreen(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
