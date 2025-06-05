import 'dart:io';

import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../data/repository/upload_file_repository.dart';

class FileUploadNotifier extends StateNotifier<AsyncValue<String?>> {
  final UploadFileRepository _uploadFileRepository;

  FileUploadNotifier(this._uploadFileRepository) : super(const AsyncValue.data(null));

  Future<String?> uploadProfilePicture(File imageFile) async {
    state = const AsyncValue.loading(); // Show loading state

    try {
      final imageUrl = await _uploadFileRepository.uploadProfilePicture(imageFile);
      state = AsyncValue.data(imageUrl);
      return imageUrl;
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      return null;
    }
  }
}
