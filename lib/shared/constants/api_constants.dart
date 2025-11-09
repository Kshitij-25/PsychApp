class ApiConstants {
  ApiConstants._();

  static final baseUrl =
      // kDebugMode ?
      'https://mind-nest-backend.onrender.com/api';
  // : 'http://localhost:8080/api';

  static final loginUrl = '/auth/login';
  static final registerUserUrl = '/auth/signup';
  static final logoutUser = '/auth/logout';
  static final createUserProfile = '/create-user-profile';
  static final createProfessionalProfile = '/create-professional-profile';
  static final uploadProfilePicUrl = '/upload-profile-pic';
  static final saveAssessments = '/save-assessments';
}
