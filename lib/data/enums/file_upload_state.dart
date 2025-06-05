enum UploadStatus { idle, uploading, success, failure }

class FileUploadState {
  final UploadStatus status;
  final String? fileUrl;
  final String? errorMessage;

  FileUploadState({this.status = UploadStatus.idle, this.fileUrl, this.errorMessage});

  FileUploadState copyWith({UploadStatus? status, String? fileUrl, String? errorMessage}) {
    return FileUploadState(
      status: status ?? this.status,
      fileUrl: fileUrl ?? this.fileUrl,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
