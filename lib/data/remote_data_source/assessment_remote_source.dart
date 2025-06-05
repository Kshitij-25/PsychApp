import '../../shared/constants/api_constants.dart';
import '../core/dio_client.dart';
import '../models/api_model.dart';

class AssessmentRemoteSource {
  static final AssessmentRemoteSource _instance = AssessmentRemoteSource._internal();

  AssessmentRemoteSource._internal();

  factory AssessmentRemoteSource() => _instance;

  final DioClient _dioClient = DioClient();

  Future<ApiModel?> saveAssessment({
    String? email,
    List<int>? phq9Answers,
    List<int>? gad7Answers,
    bool? selfHarmThoughts,
    bool? selfHarmPlan,
    bool? suicideHistory,
    bool? unsafeEnvironment,
    int? functionalImpact,
    Set<String>? therapyGoals,
    String? openEndedResponse,
    bool? currentTreatment,
    String? diagnosisHistory,
    String? currentMedication,
    String? functionalImpactString,
  }) async {
    try {
      final response = await _dioClient.post(
        ApiConstants.saveAssessments,
        data: {
          'email': email,
          'phq9Responses': phq9Answers,
          'gad7Responses': gad7Answers,
          'selfHarmThoughts': selfHarmThoughts,
          'selfHarmPlan': selfHarmPlan,
          'suicideHistory': suicideHistory,
          'unsafeEnvironment': unsafeEnvironment,
          'functionalImpact': functionalImpactString ?? 'NOT_AT_ALL',
          'currentTreatment': currentTreatment,
          'diagnosisHistory': diagnosisHistory,
          'currentMedication': currentMedication,
          'therapyGoals': therapyGoals?.toList(),
        },
      );

      if (response.statusCode == 200) {
        final responseJson = response.data;
        return ApiModel.fromJson(responseJson);
      } else {
        throw Exception('Assessment not saved. Please try again.');
      }
    } catch (e) {
      print('saveAssessment Error: $e');
      throw e;
    }
  }
}
