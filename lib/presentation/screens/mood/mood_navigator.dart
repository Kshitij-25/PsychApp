import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'insights_screen.dart';
import 'mood_screen.dart';

class MoodNavigator extends HookConsumerWidget {
  static const routeName = '/moodNavigator';
  const MoodNavigator({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        forceMaterialTransparency: true,
        centerTitle: false,
        title: Text(
          'Moods & Insights',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
      ),
      body: DefaultTabController(
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
                    labelColor: Theme.of(context).colorScheme.primaryContainer,
                    indicatorAnimation: TabIndicatorAnimation.linear,
                    dividerColor: Colors.transparent,
                    unselectedLabelColor: Theme.of(context).tabBarTheme.unselectedLabelColor,
                    indicator: BoxDecoration(
                      color: Theme.of(context).colorScheme.surfaceContainerLowest,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    tabs: [
                      Tab(text: 'Mood'),
                      Tab(text: 'Insights'),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16),
              Expanded(
                child: TabBarView(
                  children: [
                    MoodScreen(),
                    InsightsScreen(),
                    // HistoryScreen(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
