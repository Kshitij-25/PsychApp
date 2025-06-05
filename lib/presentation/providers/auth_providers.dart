import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../data/enums/auth_state.dart';
import '../../data/remote_data_source/auth_remote_source.dart';
import '../../data/repository/auth_repository.dart';
import '../notifiers/auth_notifier.dart';

final authRemoteSourceProvider = Provider<AuthRemoteSource>((ref) {
  return AuthRemoteSource();
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final remoteSource = ref.read(authRemoteSourceProvider);
  return AuthRepository(remoteSource);
});

final authNotifierProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final repository = ref.read(authRepositoryProvider);
  return AuthNotifier(repository);
});

final isGuestLoginProvider = StateProvider.autoDispose<bool>((ref) => true);
