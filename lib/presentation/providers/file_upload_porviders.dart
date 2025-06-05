// Provider for the Upload Profile Picture Notifier
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../data/remote_data_source/upload_file_remote_source.dart';
import '../../data/repository/upload_file_repository.dart';
import '../notifiers/file_upload_notifer.dart';

final fileUploadProvider = StateNotifierProvider<FileUploadNotifier, AsyncValue<String?>>(
  (ref) => FileUploadNotifier(ref.watch(uploadFileRepositoryProvider)),
);

final uploadFileRepositoryProvider = Provider<UploadFileRepository>(
  (ref) => UploadFileRepository(ref.watch(uploadFileRemoteSourceProvider)),
);

final uploadFileRemoteSourceProvider = Provider<UploadFileRemoteSource>(
  (ref) => UploadFileRemoteSource(),
);
