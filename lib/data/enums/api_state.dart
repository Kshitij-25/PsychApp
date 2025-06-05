class ApiState<T> {
  final bool isLoading;
  final T? data;
  final String? error;

  ApiState({this.isLoading = false, this.data, this.error});

  factory ApiState.loading() => ApiState(isLoading: true);
  factory ApiState.success(T data) => ApiState(data: data);
  factory ApiState.error(String error) => ApiState(error: error);
}
