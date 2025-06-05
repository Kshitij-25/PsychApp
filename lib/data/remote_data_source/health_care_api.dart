import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../error_handling/dio_error_handler.dart';
import '../firebase_models/articles.dart';

final newsApiServiceProvider = Provider<NewsApiService>((ref) {
  return NewsApiService();
});

class NewsState {
  final bool isLoading;
  Articles? data;
  final String? error;

  NewsState({this.isLoading = false, this.data, this.error});

  NewsState copyWith({
    bool? isLoading,
    Articles? data,
    String? error,
  }) {
    return NewsState(
      isLoading: isLoading ?? this.isLoading,
      data: data ?? this.data,
      error: error ?? this.error,
    );
  }
}

class NewsNotifier extends StateNotifier<NewsState> {
  final NewsApiService apiService;

  NewsNotifier(this.apiService) : super(NewsState());

  Future<void> fetchNews(String query) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final data = await apiService.fetchNews(query: query);
      state = state.copyWith(isLoading: false, data: data);
    } catch (e) {
      String errorMessage = 'An unexpected error occurred';
      if (e is DioException) {
        // Use DioErrorHandler to get the custom error message
        final errorHandler = DioErrorHandler(e);
        errorMessage = errorHandler.errorMessage ?? 'An unexpected error occurred';
        print(errorMessage); // This will print the correct error message now
      }
      state = state.copyWith(isLoading: false, error: errorMessage);
    }
  }
}

final newsProvider = StateNotifierProvider<NewsNotifier, NewsState>((ref) {
  final apiService = ref.read(newsApiServiceProvider);
  return NewsNotifier(apiService);
});

class NewsApiService {
  final Dio _dio;

  final String _baseUrl = "https://newsapi.org/v2/everything";
  final String? _apiKey = dotenv.env['API_KEY'];

  NewsApiService() : _dio = Dio();

  Future<Articles> fetchNews({
    required String query,
    String language = 'en',
  }) async {
    try {
      final response = await _dio.get(
        _baseUrl,
        queryParameters: {
          'q': query,
          'language': language,
          'apiKey': _apiKey,
        },
      );

      if (response.statusCode == 200) {
        return Articles.fromJson(response.data);
      } else {
        throw DioException(
          type: DioExceptionType.badResponse,
          response: response,
          requestOptions: RequestOptions(),
        );
      }
    } on DioException catch (e) {
      throw e; // Propagate DioException to be caught in the notifier
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
