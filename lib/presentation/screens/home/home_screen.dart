import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../data/local_data_source/psychologists_type.dart';
import '../../../data/remote_data_source/health_care_api.dart';
import '../article/article_screen.dart';

final selectedNewsFilterProvider = StateProvider<String>((ref) => "all");

class HomeScreen extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final newsState = ref.watch(newsProvider);
    final newsNotifier = ref.read(newsProvider.notifier);
    final selectedFilter = ref.watch(selectedNewsFilterProvider);

    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final query = selectedFilter == "all" ? "psychology" : selectedFilter;
        newsNotifier.fetchNews(query);
      });
      return null;
    }, [selectedFilter]);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Column(
        children: [
          _buildFilterBar(context, ref),
          const SizedBox(height: 16),
          Expanded(
            child: newsState.isLoading
                ? const Center(child: CircularProgressIndicator())
                : newsState.error != null
                    ? Center(child: Text('Error: ${newsState.error}'))
                    : newsState.data?.articles?.isEmpty ?? true
                        ? Center(
                            child: Text('No articles available for ${selectedFilter.replaceAll('_', ' ').split(' ').map((word) {
                              return word[0].toUpperCase() + word.substring(1).toLowerCase();
                            }).join(' ')}.'),
                          )
                        : ListView.builder(
                            itemCount: newsState.data?.articles?.length ?? 0,
                            itemBuilder: (context, index) {
                              final article = newsState.data?.articles?[index];

                              final hasValidData = article != null &&
                                  (article.urlToImage?.isNotEmpty ?? false) &&
                                  (article.title?.isNotEmpty ?? false) &&
                                  (article.description?.isNotEmpty ?? false);

                              if (hasValidData) {
                                return GestureDetector(
                                  onTap: () {
                                    context.pushNamed(ArticleScreen.routeName, extra: article);
                                  },
                                  child: Card(
                                    color: Theme.of(context).colorScheme.surfaceContainerLowest,
                                    elevation: 2,
                                    child: Column(
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(8),
                                            topRight: Radius.circular(8),
                                          ),
                                          child: CachedNetworkImage(
                                            placeholder: (context, url) => Center(child: const CircularProgressIndicator()),
                                            errorWidget: (context, url, error) => const Icon(Icons.error),
                                            imageUrl: article.urlToImage ?? '',
                                            cacheKey: article.urlToImage ?? '',
                                            filterQuality: FilterQuality.high,
                                            height: 200,
                                            memCacheHeight: 1080,
                                            memCacheWidth: 1920,
                                            width: double.infinity,
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(10),
                                          child: Text(
                                            article.title ?? 'No Title',
                                            textAlign: TextAlign.start,
                                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }
                              return SizedBox.shrink();
                            },
                          ),
          ),
        ],
      ),
    );
  }
}

Widget _buildFilterBar(BuildContext context, WidgetRef ref) {
  final selectedFilter = ref.watch(selectedNewsFilterProvider);

  return SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: Row(
      children: [
        _FilterChipButton(
          label: "All",
          value: "all",
          isSelected: selectedFilter == "all",
          onTap: () {
            ref.read(selectedNewsFilterProvider.notifier).state = "all";
          },
        ),
        ...specializationFilters.where((filter) => filter["label"]?.toLowerCase() != "recommended").map(
          (filter) {
            final label = filter["label"];
            final value = filter["value"];

            return _FilterChipButton(
              label: label ?? "",
              value: value ?? "",
              isSelected: selectedFilter == value,
              onTap: () {
                ref.read(selectedNewsFilterProvider.notifier).state = value ?? "";
              },
            );
          },
        ),
      ],
    ),
  );
}

class _FilterChipButton extends StatelessWidget {
  final String label;
  final String value;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChipButton({
    Key? key,
    required this.label,
    required this.value,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Theme.of(context).colorScheme.primaryContainer : Theme.of(context).colorScheme.primaryFixed,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Theme.of(context).colorScheme.onPrimaryContainer : Theme.of(context).colorScheme.onPrimaryFixed,
          ),
        ),
      ),
    );
  }
}
