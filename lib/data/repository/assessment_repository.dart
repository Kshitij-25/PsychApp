import '../models/api_model.dart';
import '../remote_data_source/assessment_remote_source.dart';

class AssessmentRepository {
  final AssessmentRemoteSource _assessmentRemoteSource;

  AssessmentRepository(this._assessmentRemoteSource);

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
      final response = await _assessmentRemoteSource.saveAssessment(
        email: email,
        phq9Answers: phq9Answers,
        gad7Answers: gad7Answers,
        selfHarmThoughts: selfHarmThoughts,
        selfHarmPlan: selfHarmPlan,
        suicideHistory: suicideHistory,
        unsafeEnvironment: unsafeEnvironment,
        functionalImpact: functionalImpact,
        therapyGoals: therapyGoals,
        openEndedResponse: openEndedResponse,
        currentTreatment: currentTreatment,
        diagnosisHistory: diagnosisHistory,
        currentMedication: currentMedication,
        functionalImpactString: functionalImpactString,
      );
      return response;
    } catch (e) {
      print('Repository saveAssessment Error: $e');
      rethrow;
    }
  }
}
