import 'dart:io';

import '../remote_data_source/upload_file_remote_source.dart';

class UploadFileRepository {
  final UploadFileRemoteSource _uploadFileRemoteSource;

  UploadFileRepository(this._uploadFileRemoteSource);

  Future<String?> uploadProfilePicture(File imageFile) async {
    try {
      final response = await _uploadFileRemoteSource.uploadProfilePicture(imageFile);
      return response;
    } catch (e) {
      print('Repository uploadProfilePicture Error: $e');
      rethrow;
    }
  }
}
