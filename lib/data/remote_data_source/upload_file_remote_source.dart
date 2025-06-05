import 'dart:io';

import 'package:dio/dio.dart';
import 'package:http_parser/src/media_type.dart';
import 'package:mime/src/mime_type.dart';

import '../../shared/constants/api_constants.dart';
import '../core/dio_client.dart';

class UploadFileRemoteSource {
  static final UploadFileRemoteSource _instance = UploadFileRemoteSource._internal();

  UploadFileRemoteSource._internal();

  factory UploadFileRemoteSource() => _instance;

  final DioClient _dioClient = DioClient();

  Future<String?> uploadProfilePicture(File imageFile) async {
    try {
      final fileName = imageFile.path.split('/').last;
      final mimeType = lookupMimeType(imageFile.path);
      final mediaType = mimeType != null ? MediaType.parse(mimeType) : null;

      FormData formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          imageFile.path,
          filename: fileName,
          contentType: mediaType,
        ),
      });

      // Make the API call
      final response = await _dioClient.post(
        ApiConstants.uploadProfilePicUrl,
        data: formData,
      );

      if (response.statusCode == 200) {
        print(response.data);
        return response.data['data'];
      } else {
        throw Exception('Profile picture upload failed. Please try again.');
      }
    } catch (e) {
      print('Profile Picture Upload Error: $e');
      throw e;
    }
  }
}
