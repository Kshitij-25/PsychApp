import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../data/models/articles.dart';
import '../webview/web_view_screen.dart';

class ArticleScreen extends HookConsumerWidget {
  static const routeName = '/articleScreen';
  const ArticleScreen({
    super.key,
    required this.articleData,
  });

  final Article articleData;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          articleData.source?.name ?? '',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CachedNetworkImage(
            placeholder: (context, url) => Center(child: const CircularProgressIndicator()),
            errorWidget: (context, url, error) => const Icon(Icons.error),
            imageUrl: articleData.urlToImage ?? '',
            cacheKey: articleData.urlToImage ?? '',
            filterQuality: FilterQuality.high,
            height: 250,
            memCacheHeight: 1080,
            memCacheWidth: 1920,
            width: double.infinity,
            fit: BoxFit.contain,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10, right: 15),
            child: Text(
              DateFormat('MMMM dd, yyyy h:mm a').format(DateTime.parse(articleData.publishedAt.toString())),
              textAlign: TextAlign.end,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15),
            child: Text(
              articleData.title ?? 'No Title',
              textAlign: TextAlign.start,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15),
            child: Text(
              articleData.description ?? 'No Title',
              textAlign: TextAlign.start,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15),
            child: Text(
              articleData.content ?? 'No Title',
              textAlign: TextAlign.start,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => WebViewScreen(
              url: articleData.url,
              source: articleData.source!.name,
            ),
          ));
        },
        icon: Icon(CupertinoIcons.link),
        label: Text('Read full article here'),
      ),
    );
  }
}
