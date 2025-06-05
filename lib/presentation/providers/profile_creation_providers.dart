// Repository Provider
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../data/remote_data_source/create_profile_remote_source.dart';
import '../../data/repository/create_profile_repository.dart';

final createProfileRepositoryProvider = Provider<CreateProfileRepository>((ref) {
  return CreateProfileRepository(CreateProfileRemoteSource());
});
